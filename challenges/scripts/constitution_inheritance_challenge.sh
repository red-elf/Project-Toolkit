#!/bin/bash
# constitution_inheritance_challenge.sh — Helix Constitution inheritance gate.
#
# Asserts that this project actually consumes the Helix Constitution
# submodule and that every required anchor + every required parent-
# governance pointer is in place. Paired with
# meta_test_constitution_inheritance_mutation.sh under §1.1 (anti-bluff)
# so this gate cannot itself become a bluff.
#
# Resolves the project root from the script's location, so it works
# from the project root, from challenges/scripts/, or from anywhere
# else inside the working tree.
#
# Exit:
#   0 = every invariant holds
#   1 = at least one invariant failed (details printed to stderr)
#   2 = project root could not be located
#
# See: constitution/Constitution.md §11.4.35 + agent-prompt Step 7.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

find_project_root() {
  local d="$1"
  while [[ "$d" != "/" ]]; do
    if [[ -f "$d/CONSTITUTION.md" && -f "$d/CLAUDE.md" && -f "$d/AGENTS.md" ]]; then
      echo "$d"; return 0
    fi
    d=$(dirname "$d")
  done
  return 1
}

PROJECT_ROOT=$(find_project_root "$SCRIPT_DIR" || true)
if [[ -z "${PROJECT_ROOT:-}" ]]; then
  echo "FAIL: cannot locate project root (CONSTITUTION.md + CLAUDE.md + AGENTS.md)" >&2
  exit 2
fi

echo "=== constitution_inheritance_challenge ==="
echo "Root: $PROJECT_ROOT"
echo

CONST_DIR="$PROJECT_ROOT/constitution"
fail=0
report() {
  local status="$1"; shift
  printf "  %-4s  %s\n" "$status" "$*"
  [[ "$status" = "FAIL" ]] && fail=1
}

# Invariant 1 — constitution submodule directory exists
if [[ -d "$CONST_DIR" ]]; then
  report "PASS" "Invariant 1: constitution/ directory exists"
else
  report "FAIL" "Invariant 1: constitution/ directory missing at $CONST_DIR"
fi

# Invariant 2 — constitution/Constitution.md present + carries forensic anchor
CONST_FILE="$CONST_DIR/Constitution.md"
ANCHOR_CONST='§11.4 End-user quality guarantee — forensic anchor'
if [[ -f "$CONST_FILE" ]] && grep -qF "$ANCHOR_CONST" "$CONST_FILE"; then
  report "PASS" "Invariant 2: Constitution.md carries §11.4 forensic-anchor string"
else
  report "FAIL" "Invariant 2: Constitution.md missing or anchor '$ANCHOR_CONST' absent"
fi

# Invariant 3 — constitution/CLAUDE.md present + carries anti-bluff covenant anchor
CLAUDE_FILE="$CONST_DIR/CLAUDE.md"
ANCHOR_CLAUDE='MANDATORY ANTI-BLUFF COVENANT'
if [[ -f "$CLAUDE_FILE" ]] && grep -qF "$ANCHOR_CLAUDE" "$CLAUDE_FILE"; then
  report "PASS" "Invariant 3: constitution/CLAUDE.md carries '$ANCHOR_CLAUDE' anchor"
else
  report "FAIL" "Invariant 3: constitution/CLAUDE.md missing or anchor absent"
fi

# Invariant 4 — constitution/AGENTS.md present + carries anti-bluff covenant anchor (case-insensitive)
AGENTS_FILE="$CONST_DIR/AGENTS.md"
ANCHOR_AGENTS='Anti-bluff covenant'
if [[ -f "$AGENTS_FILE" ]] && grep -qiF "$ANCHOR_AGENTS" "$AGENTS_FILE"; then
  report "PASS" "Invariant 4: constitution/AGENTS.md carries '$ANCHOR_AGENTS' anchor"
else
  report "FAIL" "Invariant 4: constitution/AGENTS.md missing or anchor absent"
fi

# Invariant 5 — parent governance files reference the constitution submodule.
# Accept any of: a path under `constitution/` (the submodule directory),
# the canonical repo name `HelixConstitution`, or the `find_constitution.sh`
# helper — any one is sufficient evidence of inheritance wiring.
parent_refs=(
  'constitution/'
  'HelixConstitution'
  'find_constitution.sh'
)

for parent_file in CLAUDE.md AGENTS.md CONSTITUTION.md; do
  fpath="$PROJECT_ROOT/$parent_file"
  matched=0
  if [[ -f "$fpath" ]]; then
    for needle in "${parent_refs[@]}"; do
      if grep -qF "$needle" "$fpath"; then matched=1; break; fi
    done
  fi
  if [[ $matched -eq 1 ]]; then
    report "PASS" "Invariant 5: $parent_file references constitution submodule"
  else
    report "FAIL" "Invariant 5: $parent_file missing or no constitution reference"
  fi
done

echo
if [[ $fail -eq 0 ]]; then
  echo "=== summary: PASS ==="
  exit 0
else
  echo "=== summary: FAIL ===" >&2
  exit 1
fi
