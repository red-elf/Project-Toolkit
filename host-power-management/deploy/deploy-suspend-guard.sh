#!/bin/bash
# deploy-suspend-guard.sh PROJECT_DIR PROJECT_NAME
#
# Per-project rollout: sync from all remotes, vendor canonical
# artifacts, patch governance, run static scanner, commit, push to
# all remotes. Idempotent: re-running on a project that's already
# been deployed produces no new commit.
#
# Exit codes:
#   0  = success (deployed or already up-to-date)
#   10 = git sync failed (semantic conflict or stash pop conflict)
#   20 = scanner failed
#   30 = pre-commit hook failed after auto-fix attempt
#   40 = push failed
#   90 = invalid invocation

set -uo pipefail
PROJECT_DIR="${1:-}"
PROJECT_NAME="${2:-$(basename "${PROJECT_DIR:-}")}"
[[ -z "$PROJECT_DIR" ]] && { echo "usage: $0 PROJECT_DIR [PROJECT_NAME]"; exit 90; }
[[ ! -d "$PROJECT_DIR/.git" ]] && [[ ! -f "$PROJECT_DIR/.git" ]] && { echo "ERROR: $PROJECT_DIR is not a git repo"; exit 90; }

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HPM_ROOT="$(cd "$THIS_DIR/.." && pwd)"

echo "================================================================"
echo "Deploying host-power-management guard to: $PROJECT_NAME"
echo "  path: $PROJECT_DIR"
echo "================================================================"

# 1. git sync
echo "[1/6] git sync"
if ! bash "$HPM_ROOT/deploy/git-sync-and-push.sh" "$PROJECT_DIR"; then
  echo "[!] git sync failed for $PROJECT_NAME"
  exit 10
fi

# 2. vendor artifacts
echo "[2/6] vendor artifacts"
bash "$HPM_ROOT/deploy/vendor-artifacts.sh" "$PROJECT_DIR"

# 3. governance
echo "[3/6] apply governance"
bash "$HPM_ROOT/deploy/apply-governance.sh" "$PROJECT_DIR" "$PROJECT_NAME"

# 4. run static scanner against the project
echo "[4/6] static scanner"
if ! bash "$PROJECT_DIR/scripts/host-power-management/check-no-suspend-calls.sh" "$PROJECT_DIR"; then
  echo "[!] scanner found violations in $PROJECT_NAME — manual fix required"
  exit 20
fi

# 5. commit (only if there are staged changes)
echo "[5/6] commit"
cd "$PROJECT_DIR"
git add \
  scripts/host-power-management/ \
  challenges/scripts/host_no_auto_suspend_challenge.sh \
  challenges/scripts/no_suspend_calls_challenge.sh \
  docs/HOST_POWER_MANAGEMENT.md \
  CONSTITUTION.md AGENTS.md CLAUDE.md 2>/dev/null || true

if git diff --cached --quiet; then
  echo "  [commit] no changes — already up-to-date"
else
  COMMIT_MSG="chore(governance): add CONST-033 host-power-management guard

Adds the canonical host-suspend-prevention artifacts:
- scripts/host-power-management/install-host-suspend-guard.sh (manual prereq)
- scripts/host-power-management/user_session_no_suspend_bootstrap.sh
- scripts/host-power-management/check-no-suspend-calls.sh (static scanner)
- challenges/scripts/host_no_auto_suspend_challenge.sh (host-state guard)
- challenges/scripts/no_suspend_calls_challenge.sh (source-tree guard)
- docs/HOST_POWER_MANAGEMENT.md (background, runbook)

CONSTITUTION.md / AGENTS.md / CLAUDE.md patched (or created from
skeleton) with CONST-033: hard ban on host-level power-state
transitions (suspend, hibernate, hybrid-sleep, poweroff, halt, reboot).

Background: 2026-04-26 18:23:43 host suspended mid-session, killing
HelixAgent + 41 services. Defence in depth: target masking + drop-in
sleep.conf + logind IdleAction=ignore + source-tree static scanner."

  if ! git commit -m "$COMMIT_MSG"; then
    echo "[!] pre-commit hook failed in $PROJECT_NAME — attempting auto-fix"
    # auto-fix: re-run formatters / linters that the hook complained about
    # if the project has well-known fixers, run them
    [[ -f Makefile ]] && grep -qE '^(fmt|format):' Makefile && make fmt 2>/dev/null || true
    [[ -f Makefile ]] && grep -qE '^lint:' Makefile && make lint 2>/dev/null || true
    [[ -f package.json ]] && command -v npm >/dev/null && grep -q '"format"' package.json && npm run format 2>/dev/null || true
    [[ -f pyproject.toml ]] && command -v ruff >/dev/null && ruff check --fix . 2>/dev/null || true
    git add -A
    if ! git commit -m "$COMMIT_MSG"; then
      echo "[!] pre-commit hook still failing after auto-fix in $PROJECT_NAME"
      exit 30
    fi
  fi
fi

# 6. push
echo "[6/6] push to all remotes"
if ! bash "$HPM_ROOT/deploy/git-sync-and-push.sh" "$PROJECT_DIR" --push; then
  echo "[!] push failed for $PROJECT_NAME"
  exit 40
fi

echo "[OK] $PROJECT_NAME deployed"
exit 0
