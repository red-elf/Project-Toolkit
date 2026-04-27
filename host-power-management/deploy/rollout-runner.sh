#!/bin/bash
# rollout-runner.sh
#
# Iterates the in-scope project list and runs deploy-suspend-guard.sh
# against each. Records per-project status into a report and continues
# on per-project failure (so one bad repo doesn't block the rest).

set -uo pipefail
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HPM_ROOT="$(cd "$THIS_DIR/.." && pwd)"
WORKSPACE="${WORKSPACE:-/run/media/milosvasic/DATA4TB/Projects}"
REPORT_DIR="${REPORT_DIR:-$HPM_ROOT/reports}"
mkdir -p "$REPORT_DIR"
TS=$(date +%Y%m%d-%H%M%S)
REPORT="$REPORT_DIR/rollout-$TS.md"

PROJECTS=(
  HelixAgent HelixCode HelixFlow HelixGitpx HelixTranslate Helix
  Boba Catalogizer MeTube LLMsVerifier
  LLMGateway LLMOrchestrator LLMProvider
  Auth Auth-KMP Bear-Mail Bear-Messenger
  Concurrency Concurrency-KMP Config Config-KMP
  Database Database-KMP Document Document-KMP
  Distributed-AOSP-Building DocProcessor
  Formatters Formatters-KMP
  My-Patreon-Manager Notes Project-Toolkit
  Proxy RateLimiter RateLimiter-KMP
  Security Security-KMP Storage Storage-KMP
  UI-Components-KMP VisionEngine Yole CCode-Private
)

{
  echo "# Host Power Management Rollout Report — $TS"
  echo
  echo "| Project | Status | Exit | Notes |"
  echo "|---------|--------|------|-------|"
} > "$REPORT"

PASS=0
FAIL=0
for p in "${PROJECTS[@]}"; do
  dir="$WORKSPACE/$p"
  if [[ ! -d "$dir" ]]; then
    echo "| $p | SKIP | - | dir not found |" >> "$REPORT"
    continue
  fi
  echo
  echo "###################  $p  ###################"
  set +e
  bash "$HPM_ROOT/deploy/deploy-suspend-guard.sh" "$dir" "$p"
  rc=$?
  set -e
  if [[ $rc -eq 0 ]]; then
    PASS=$((PASS + 1))
    echo "| $p | OK | 0 | |" >> "$REPORT"
  else
    FAIL=$((FAIL + 1))
    case $rc in
      10) note="git sync failed (conflict/stash)" ;;
      20) note="scanner found violations" ;;
      30) note="pre-commit hook failed after auto-fix" ;;
      40) note="push failed" ;;
      *)  note="unknown error" ;;
    esac
    echo "| $p | FAIL | $rc | $note |" >> "$REPORT"
  fi
done

{
  echo
  echo "## Summary"
  echo "- PASS: $PASS"
  echo "- FAIL: $FAIL"
} >> "$REPORT"

echo
echo "================================================================"
echo "Rollout complete: $PASS pass, $FAIL fail"
echo "Report: $REPORT"
echo "================================================================"
