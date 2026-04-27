#!/bin/bash
# deploy-recursive.sh PROJECT_DIR
#
# Walks all `git submodule` entries in PROJECT_DIR and deploys to each
# that:
#   - is a git repo,
#   - has at least one configured remote,
#   - is not on a third-party-skip list.
#
# Skip list comes from .deploy-suspend-skip in the project root, one
# path glob per line. HelixAgent's .deploy-suspend-skip will list
# `cli_agents` and `MCP/`. By default, common third-party paths are
# always skipped.

set -uo pipefail
PROJECT_DIR="${1:?usage: $0 PROJECT_DIR}"
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HPM_ROOT="$(cd "$THIS_DIR/.." && pwd)"

cd "$PROJECT_DIR"

DEFAULT_SKIPS=( "cli_agents" "MCP" "MCP_Module/submodules" "vendor" "third_party" "Upstreams" )

# Read project-specific skips
EXTRA_SKIPS=()
if [[ -f "$PROJECT_DIR/.deploy-suspend-skip" ]]; then
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    [[ "$line" =~ ^# ]] && continue
    EXTRA_SKIPS+=( "$line" )
  done < "$PROJECT_DIR/.deploy-suspend-skip"
fi

ALL_SKIPS=( "${DEFAULT_SKIPS[@]}" "${EXTRA_SKIPS[@]}" )

# Iterate submodules
SUBMODULES=$(git submodule status --recursive 2>/dev/null \
  | awk '{print $2}' || true)

for sm in $SUBMODULES; do
  abs="$PROJECT_DIR/$sm"
  skip=false
  for sk in "${ALL_SKIPS[@]}"; do
    if [[ "$sm" == "$sk" ]] || [[ "$sm" == "$sk/"* ]] || [[ "$sm" == *"/$sk" ]] || [[ "$sm" == *"/$sk/"* ]]; then
      skip=true; break
    fi
  done
  if $skip; then
    echo "  [submod] SKIP $sm (on skip list)"
    continue
  fi
  if ! ( cd "$abs" 2>/dev/null && git remote 2>/dev/null | head -n1 | grep -q . ); then
    echo "  [submod] SKIP $sm (no remote configured)"
    continue
  fi
  echo "  [submod] deploy $sm"
  bash "$HPM_ROOT/deploy/deploy-suspend-guard.sh" "$abs" "$(basename "$sm")" \
    || echo "  [submod] FAIL $sm (continuing)"
done
