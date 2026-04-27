#!/bin/bash
# apply-governance.sh PROJECT_DIR PROJECT_NAME
#
# Patches CONSTITUTION.md / AGENTS.md / CLAUDE.md in PROJECT_DIR with
# the CONST-033 addendum. If a file is missing, creates it from the
# matching skeleton. Idempotent: looks for the BEGIN/END markers
# before re-applying.

set -euo pipefail
PROJECT_DIR="${1:?usage: $0 PROJECT_DIR PROJECT_NAME}"
PROJECT_NAME="${2:?usage: $0 PROJECT_DIR PROJECT_NAME}"

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HPM_ROOT="$(cd "$THIS_DIR/.." && pwd)"
DOCS="$HPM_ROOT/docs"
TPL="$HPM_ROOT/templates"

START="<!-- BEGIN host-power-management addendum (CONST-033) -->"
END="<!-- END host-power-management addendum (CONST-033) -->"

apply_one() {
  local file="$1" addendum="$2" skeleton="$3" tag="$4"
  local target="$PROJECT_DIR/$file"
  if [[ -f "$target" ]]; then
    if grep -qF "$START" "$target"; then
      echo "  [$tag] $file: addendum already present — skipping"
      return 0
    fi
    {
      echo
      cat "$DOCS/$addendum"
      echo
    } >> "$target"
    echo "  [$tag] $file: addendum appended"
  else
    # create from skeleton
    if [[ ! -f "$TPL/$skeleton" ]]; then
      echo "ERROR: skeleton $TPL/$skeleton missing" >&2
      return 1
    fi
    local block
    block=$(cat "$DOCS/$addendum")
    # render skeleton
    awk -v name="$PROJECT_NAME" -v block="$block" -v brief="See README.md." '
      {
        gsub(/\{\{PROJECT_NAME\}\}/, name)
        gsub(/\{\{ONE_LINE_PROJECT_BRIEF\}\}/, brief)
        gsub(/\{\{ONE_PARAGRAPH_PROJECT_BRIEF — see README.md for the long form.\}\}/, brief)
        if ($0 ~ /\{\{INSERT_CONST_033_BLOCK\}\}/) { print block; next }
        print
      }
    ' "$TPL/$skeleton" > "$target"
    echo "  [$tag] $file: created from skeleton"
  fi
}

apply_one "CONSTITUTION.md" "CONSTITUTION_ADDENDUM.md" "CONSTITUTION_SKELETON.md" "const"
apply_one "AGENTS.md"       "AGENTS_ADDENDUM.md"       "AGENTS_SKELETON.md"       "agents"
apply_one "CLAUDE.md"       "CLAUDE_ADDENDUM.md"       "CLAUDE_SKELETON.md"       "claude"
