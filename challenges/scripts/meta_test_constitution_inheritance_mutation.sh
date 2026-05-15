#!/bin/bash
# meta_test_constitution_inheritance_mutation.sh — paired mutation for
# constitution_inheritance_challenge.sh under Constitution §1.1.
#
# Constitution §1.1 mandates that every gate ship with a mutation
# proving the gate is not itself a bluff gate. This meta-test:
#
#   1. Captures a backup of constitution/Constitution.md.
#   2. Strips the §11.4 forensic-anchor string ("MUTATED_OUT").
#   3. Runs constitution_inheritance_challenge.sh — expects exit 1.
#   4. Restores the backup.
#   5. Runs the challenge again — expects exit 0.
#
# If step 3 returns 0, the gate is a bluff (silently passes a clear
# regression): meta-test exits non-zero and the operator must fix the
# gate.
# If step 5 returns non-zero, the restore left damage: meta-test
# exits non-zero.
#
# The mutation is local + reversible. No host-power-management calls,
# no network, no destructive operation outside the constitution file.
#
# Exit:
#   0 = mutation correctly caught, gate is not a bluff
#   1 = gate failed to catch the mutation (gate is itself a bluff)
#   2 = restore failed or post-restore gate misbehaved
#   3 = preconditions missing (constitution dir, anchor, gate script)

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
  echo "FAIL: cannot locate project root" >&2
  exit 3
fi

GATE="$PROJECT_ROOT/challenges/scripts/constitution_inheritance_challenge.sh"
TARGET="$PROJECT_ROOT/constitution/Constitution.md"
ANCHOR='§11.4 End-user quality guarantee — forensic anchor'

[[ -x "$GATE" ]]                       || { echo "FAIL: gate not executable: $GATE" >&2; exit 3; }
[[ -f "$TARGET" ]]                     || { echo "FAIL: target missing: $TARGET" >&2; exit 3; }
grep -qF "$ANCHOR" "$TARGET"           || { echo "FAIL: anchor absent in target before mutation" >&2; exit 3; }

echo "=== meta_test_constitution_inheritance_mutation ==="
echo "Gate:   $GATE"
echo "Target: $TARGET"
echo

BACKUP="$TARGET.mut.bak"
trap 'if [[ -f "$BACKUP" ]]; then mv -f "$BACKUP" "$TARGET"; echo "(trap) restored target from backup"; fi' EXIT

# Snapshot
cp -- "$TARGET" "$BACKUP"

# Mutate
# Use a literal-safe sed: escape regex metachars in ANCHOR by switching
# to fixed-string replacement via awk. (sed -F doesn't exist on macOS.)
awk -v needle="$ANCHOR" -v repl='MUTATED_OUT' '
  {
    pos = index($0, needle)
    while (pos > 0) {
      $0 = substr($0, 1, pos - 1) repl substr($0, pos + length(needle))
      pos = index($0, needle)
    }
    print
  }
' "$BACKUP" > "$TARGET"

# Verify mutation actually happened
if grep -qF "$ANCHOR" "$TARGET"; then
  echo "FAIL: mutation did not strip the anchor" >&2
  exit 2
fi

# Run gate under mutation — expect non-zero exit
set +e
bash "$GATE" >/dev/null 2>&1
mutated_rc=$?
set -e

echo "Mutated-tree gate exit: $mutated_rc"
if [[ $mutated_rc -eq 0 ]]; then
  echo "BLUFF: gate exited 0 on a mutated tree — paired mutation failed to catch regression" >&2
  # Restore is handled by EXIT trap
  exit 1
fi

# Restore via mv (atomic) and clear trap
mv -f "$BACKUP" "$TARGET"
trap - EXIT

# Verify restore
if ! grep -qF "$ANCHOR" "$TARGET"; then
  echo "FAIL: anchor not restored — file may be damaged" >&2
  exit 2
fi

# Post-restore gate — expect zero exit
set +e
bash "$GATE" >/dev/null 2>&1
restored_rc=$?
set -e

echo "Restored-tree gate exit: $restored_rc"
if [[ $restored_rc -ne 0 ]]; then
  echo "FAIL: gate did not pass on a restored tree — gate may be broken" >&2
  exit 2
fi

echo
echo "=== summary: PASS (mutation caught, restore verified) ==="
exit 0
