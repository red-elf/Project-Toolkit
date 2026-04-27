#!/bin/bash
# git-sync-and-push.sh PROJECT_DIR
#
# 1. Auto-stash any local changes (named stash).
# 2. Fetch from every configured remote.
# 3. Determine the project's default branch (main/master/develop).
# 4. For each remote that has the default branch, merge --no-ff into HEAD.
#    On conflict: try obvious auto-resolutions (whitespace, addendum
#    text already present); stop on semantic conflict.
# 5. Pop the stash; if pop conflicts, stop and surface.
# 6. Caller does its work (vendor + governance).
# 7. Caller calls git-sync-and-push.sh again with --push to push to
#    every configured remote.
#
# Two modes:
#   git-sync-and-push.sh PROJECT_DIR        -> sync mode (steps 1-5)
#   git-sync-and-push.sh PROJECT_DIR --push -> push mode (step 7)

set -euo pipefail
PROJECT_DIR="${1:?usage: $0 PROJECT_DIR [--push]}"
MODE="${2:-sync}"

cd "$PROJECT_DIR"

# --- detect default branch ---
detect_default_branch() {
  local b
  for r in $(git remote); do
    b=$(git symbolic-ref "refs/remotes/$r/HEAD" 2>/dev/null | sed "s|^refs/remotes/$r/||" || true)
    [[ -n "$b" ]] && { echo "$b"; return; }
  done
  for c in main master develop trunk; do
    git show-ref --verify --quiet "refs/heads/$c" && { echo "$c"; return; }
  done
  git rev-parse --abbrev-ref HEAD
}

DEFAULT_BRANCH=$(detect_default_branch)
echo "  [git] default branch: $DEFAULT_BRANCH"

if [[ "$MODE" == "--push" ]]; then
  PUSH_OK=0; PUSH_FAIL=0; FAIL_LIST=""
  for r in $(git remote); do
    echo "  [git] push -> $r/$DEFAULT_BRANCH"
    if git push "$r" "HEAD:refs/heads/$DEFAULT_BRANCH"; then
      PUSH_OK=$((PUSH_OK + 1))
    else
      PUSH_FAIL=$((PUSH_FAIL + 1))
      FAIL_LIST="$FAIL_LIST $r"
      echo "  [git] push to $r FAILED (continuing with other remotes)"
    fi
  done
  echo "  [git] push summary: $PUSH_OK OK, $PUSH_FAIL FAILED ($FAIL_LIST)"
  # Exit 0 if at least one push succeeded; non-zero only if ALL remotes failed.
  [[ $PUSH_OK -gt 0 ]] && exit 0 || exit 1
fi

# --- sync mode ---

# 1. stash if dirty (count stash entries before/after to detect actual stash creation;
#    submodule "M" status from interior dirty trees is reported by `git status` but
#    is NOT stashable, so the count check guards against the empty-stash trap)
DIRTY=$(git status --porcelain | head -n1)
STASHED=0
if [[ -n "$DIRTY" ]]; then
  STASH_BEFORE=$(git stash list 2>/dev/null | wc -l)
  git stash push -u -m "host-power-management-rollout $(date -Iseconds)" >/dev/null 2>&1 || true
  STASH_AFTER=$(git stash list 2>/dev/null | wc -l)
  if [[ "$STASH_AFTER" -gt "$STASH_BEFORE" ]]; then
    STASHED=1
    echo "  [git] stashed local changes (entries: $STASH_BEFORE -> $STASH_AFTER)"
  else
    echo "  [git] no stashable changes (only submodule interior modifications, not stashable)"
  fi
fi

# 2. fetch each remote individually, tolerating per-remote failures
#    (some remotes may be down, auth-broken, or pointing at non-existent
#    repos; those are noted but don't abort the sync — we only care
#    that AT LEAST ONE remote is reachable for a meaningful merge).
FETCH_OK=0; FETCH_FAIL=0
for r in $(git remote); do
  if git fetch --prune "$r" 2>&1 | tail -3; then
    FETCH_OK=$((FETCH_OK + 1))
  else
    FETCH_FAIL=$((FETCH_FAIL + 1))
    echo "  [git] fetch warning: $r unreachable (continuing)"
  fi
done
echo "  [git] fetch summary: $FETCH_OK OK, $FETCH_FAIL FAILED (continuing with reachable remotes)"

# 3 & 4. merge from each remote
git checkout "$DEFAULT_BRANCH" 2>/dev/null || true
for r in $(git remote); do
  if git show-ref --verify --quiet "refs/remotes/$r/$DEFAULT_BRANCH"; then
    echo "  [git] merge $r/$DEFAULT_BRANCH (no-ff)"
    if ! git merge --no-ff --no-edit "$r/$DEFAULT_BRANCH"; then
      # try obvious auto-resolutions
      AUTOFIXED=0
      # 4a. addendum-already-present markers — accept the version
      # that already contains the addendum
      if git diff --name-only --diff-filter=U | grep -qE '^(CONSTITUTION|AGENTS|CLAUDE)\.md$'; then
        for f in $(git diff --name-only --diff-filter=U | grep -E '^(CONSTITUTION|AGENTS|CLAUDE)\.md$'); do
          if grep -qF "BEGIN host-power-management addendum (CONST-033)" "$f"; then
            git checkout --theirs -- "$f" || true
            git add "$f"
            AUTOFIXED=1
          fi
        done
      fi
      # 4b. trivial whitespace-only conflicts: prefer ours
      for f in $(git diff --name-only --diff-filter=U); do
        # check if the conflict is whitespace-only by extracting both sides
        ours=$(git show ":2:$f" 2>/dev/null | tr -d '[:space:]' || true)
        theirs=$(git show ":3:$f" 2>/dev/null | tr -d '[:space:]' || true)
        if [[ -n "$ours" ]] && [[ "$ours" == "$theirs" ]]; then
          git checkout --ours -- "$f" || true
          git add "$f"
          AUTOFIXED=1
        fi
      done
      if [[ $AUTOFIXED -eq 1 ]] && git diff --name-only --diff-filter=U | head -n1 | grep -q . ; then
        # still unresolved — abort
        echo "  [git] semantic conflicts remain after auto-resolution; aborting merge" >&2
        git merge --abort || true
        [[ $STASHED -eq 1 ]] && git stash pop || true
        exit 2
      fi
      if [[ $AUTOFIXED -eq 1 ]]; then
        git commit --no-edit
        echo "  [git] auto-resolved trivial conflicts"
      else
        echo "  [git] merge $r/$DEFAULT_BRANCH conflicts — semantic, aborting" >&2
        git merge --abort || true
        [[ $STASHED -eq 1 ]] && git stash pop || true
        exit 2
      fi
    fi
  else
    echo "  [git] $r has no $DEFAULT_BRANCH ref — skipping"
  fi
done

# 5. pop stash
if [[ $STASHED -eq 1 ]]; then
  if ! git stash pop; then
    echo "  [git] stash pop CONFLICTS — manual resolution required" >&2
    exit 3
  fi
fi
