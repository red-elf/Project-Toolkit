#!/bin/bash
# vendor-artifacts.sh PROJECT_DIR
#
# Copies the canonical host-power-management artifacts from
# Project-Toolkit/host-power-management/ into PROJECT_DIR.
# Idempotent (rsync with content compare). Preserves exec bits.

set -euo pipefail
PROJECT_DIR="${1:?usage: $0 PROJECT_DIR}"

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HPM_ROOT="$(cd "$THIS_DIR/.." && pwd)"

mkdir -p \
  "$PROJECT_DIR/scripts/host-power-management" \
  "$PROJECT_DIR/challenges/scripts" \
  "$PROJECT_DIR/docs"

cp -p "$HPM_ROOT/scripts/install-host-suspend-guard.sh"          "$PROJECT_DIR/scripts/host-power-management/"
cp -p "$HPM_ROOT/scripts/user_session_no_suspend_bootstrap.sh"   "$PROJECT_DIR/scripts/host-power-management/"
cp -p "$HPM_ROOT/scripts/check-no-suspend-calls.sh"              "$PROJECT_DIR/scripts/host-power-management/"
cp -p "$HPM_ROOT/challenges/host_no_auto_suspend_challenge.sh"   "$PROJECT_DIR/challenges/scripts/"
cp -p "$HPM_ROOT/challenges/no_suspend_calls_challenge.sh"       "$PROJECT_DIR/challenges/scripts/"
cp -p "$HPM_ROOT/docs/HOST_POWER_MANAGEMENT.md"                  "$PROJECT_DIR/docs/"

# Restore exec bits (cp -p preserves them, but be explicit on FAT/exFAT).
chmod +x \
  "$PROJECT_DIR/scripts/host-power-management/"*.sh \
  "$PROJECT_DIR/challenges/scripts/host_no_auto_suspend_challenge.sh" \
  "$PROJECT_DIR/challenges/scripts/no_suspend_calls_challenge.sh"

echo "  [vendor] $PROJECT_DIR: artifacts vendored"
