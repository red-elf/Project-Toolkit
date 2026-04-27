#!/bin/bash
# check-no-suspend-calls.sh — CONST-033 static scanner.
#
# Walks the project tree and fails if ANY file invokes a host-level
# power-state transition (suspend, hibernate, hybrid-sleep, poweroff,
# halt, reboot, kexec, suspend-then-hibernate) via systemctl, loginctl,
# pm-*, shutdown, DBus (login1 / UPower), or gsettings sleep-inactive-*
# set to anything other than 'nothing'.
#
# Usage:
#   bash check-no-suspend-calls.sh [project_root]
#
# Exit:
#   0 = clean
#   1 = one or more violations found (printed)
#   2 = invocation error

set -uo pipefail
ROOT="${1:-.}"

if [[ ! -d "$ROOT" ]]; then
  echo "ERROR: $ROOT is not a directory" >&2
  exit 2
fi

# Directories never scanned (third-party / generated / large binary).
EXCLUDE_DIRS=(
  ".git" ".svn" ".hg"
  "node_modules" "vendor" "third_party" "Upstreams" "upstreams"
  "cli_agents" "MCP" "MCP_Module/submodules"
  ".cache" ".gradle" ".idea" ".vscode" ".venv" "venv" "__pycache__"
  "build" "dist" "target" "out" "bin" "obj"
  "releases"
  "Example_Projects"
  "submodules"
)

# File-path substrings allowlisted (the canonical artifacts and
# governance docs ARE allowed to mention these patterns).
EXCLUDE_PATHS=(
  "host-power-management/"
  "host_no_auto_suspend_challenge.sh"
  "no_suspend_calls_challenge.sh"
  "HOST_POWER_MANAGEMENT.md"
  "CONSTITUTION.md"
  "CONSTITUTION.json"
  "AGENTS.md"
  "CLAUDE.md"
  "QWEN.md"
  "GEMINI.md"
  "/docs/issues/fixed/BUGFIXES.md"
  "/CHANGELOG.md"
  "/docs/superpowers/plans/"
  "anthropic-quickstarts/"
  # Test fixtures listing forbidden commands as block-list inputs (not invocations):
  "/tests/security/"
  "/test/security/"
  "/internal/workflow/autonomy/autonomy_test.go"
  "/internal/workflow/executor_test.go"
  "/internal/security/tools_security_test.go"
  # User notes / knowledge-base markdown documenting legacy NAS commands:
  "/Knowledge Base/Tech/NAS/"
  "/Knowledge Base/Tech/Linux/"
  # Documentation-only references in third-party security models:
  "/COMMAND_SECURITY_MODEL.md"
  # Third-party AI agent configs that DENY suspend-related commands:
  "vtcode.toml"
  "vtcode.toml.example"
  "/zed-extension/vtcode.toml"
  "/vtcode-config/src/core/commands.rs"
)

# Forbidden grep -E patterns. Real, tight regexes — not bare words.
#
# Categories:
#   1. systemctl / loginctl / pm-* / shutdown power-state transitions
#   2. DBus calls into login1.Manager / UPower for the same
#   3. gsettings sleep-inactive-{ac,battery}-type set to anything
#      other than 'nothing' / 'blank'
#   4. User-session termination — logout, kill-user, kill-session,
#      systemctl --user exit, systemctl stop user@, login1.Manager
#      .TerminateUser / KillUser / TerminateSession / KillSession.
#      The host runs persistent CLI agents and container workloads
#      under a regular user account; killing that user terminates
#      everything the same way auto-suspend does.
#   5. Desktop-session quit (gnome-session-quit, xfce4-session-logout,
#      qdbus to KDE ksmserver logout) — same outcome as 4.
#   6. systemctl isolate <emergency|rescue|reboot.target|...> — yanks
#      the user-session targets out from under us.
#   7. xset DPMS force off/standby/suspend — note `xset s off` and
#      `xset -dpms` are NOT forbidden (they DISABLE the screensaver /
#      DPMS, which is the protective behaviour we ship).
FORBIDDEN=(
  '\bsystemctl[[:space:]]+(suspend|hibernate|hybrid-sleep|suspend-then-hibernate|poweroff|halt|reboot|kexec)\b'
  '\bloginctl[[:space:]]+(suspend|hibernate|hybrid-sleep|suspend-then-hibernate|poweroff|halt|reboot)\b'
  '\bpm-(suspend|hibernate|suspend-hybrid)\b'
  '\bshutdown[[:space:]]+(-h|-r|-P|-H|now|--halt|--poweroff|--reboot)\b'
  'org\.freedesktop\.login1\.Manager\.(Suspend|Hibernate|HybridSleep|SuspendThenHibernate|PowerOff|Reboot)'
  'org\.freedesktop\.UPower\.(Suspend|Hibernate|HybridSleep)'
  '(sleep-inactive-(ac|battery)-type)[[:space:]]+["'\'']?(suspend|hibernate|shutdown|hybrid-sleep|interactive)["'\'']?'
  '\bdbus-send\b.*\b(Suspend|Hibernate|PowerOff|Reboot|HybridSleep)\b'
  '\bbusctl\b.*\bcall\b.*\b(Suspend|Hibernate|PowerOff|Reboot|HybridSleep)\b'
  # Session termination
  '\bloginctl[[:space:]]+(terminate-(user|session|seat)|kill-(user|session)|logout)\b'
  '\bsystemctl[[:space:]]+(--user[[:space:]]+exit|stop[[:space:]]+user@|kill[[:space:]]+user@)\b'
  '\bsystemctl[[:space:]]+isolate[[:space:]]+(emergency|rescue|reboot|poweroff|halt|shutdown)(\.target)?\b'
  'org\.freedesktop\.login1\.Manager\.(TerminateUser|KillUser|TerminateSession|KillSession|TerminateSeat)'
  '\bdbus-send\b.*\b(TerminateUser|KillUser|TerminateSession|KillSession|TerminateSeat|Logout)\b'
  '\bbusctl\b.*\bcall\b.*\b(TerminateUser|KillUser|TerminateSession|KillSession|TerminateSeat)\b'
  # Desktop session quit
  '\bgnome-session-quit[[:space:]]+(--logout|--reboot|--power-off|--no-prompt|--force)\b'
  '\bxfce4-session-logout\b'
  '\bqdbus[[:space:]]+org\.kde\.ksmserver[[:space:]]+/KSMServer[[:space:]]+(logout|org\.kde\.KSMServerInterface\.logout)\b'
  # Force-off display (NOT `xset s off` / `xset -dpms` which DISABLE blanking)
  '\bxset[[:space:]]+dpms[[:space:]]+force[[:space:]]+(off|standby|suspend)\b'
  '\bsetterm[[:space:]]+--blank[[:space:]]+force\b'
  '\bvbetool[[:space:]]+dpms[[:space:]]+off\b'
)

# Build grep arguments
EXCL_ARGS=()
for d in "${EXCLUDE_DIRS[@]}"; do EXCL_ARGS+=( --exclude-dir="$d" ); done
PATTERN=$(IFS='|'; echo "${FORBIDDEN[*]}")

TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT

# Scan
grep -RInE "$PATTERN" "${EXCL_ARGS[@]}" -- "$ROOT" 2>/dev/null > "$TMP" || true

# Filter allowlist substrings
VIOLATIONS=$(awk -v root="$ROOT" -v EXCLUDE_PATHS_PIPED="$(IFS='|'; echo "${EXCLUDE_PATHS[*]}")" '
  BEGIN {
    n = split(EXCLUDE_PATHS_PIPED, arr, "|")
    for (i=1;i<=n;i++) ex[i] = arr[i]
    excount = n
  }
  {
    skip = 0
    for (i=1;i<=excount;i++) {
      if (ex[i] != "" && index($0, ex[i]) > 0) { skip = 1; break }
    }
    if (!skip) print
  }
' "$TMP")

if [[ -z "$VIOLATIONS" ]]; then
  echo "OK: no forbidden host-power-management calls in $ROOT"
  exit 0
fi

echo "FAIL: forbidden host-power-management invocations (CONST-033):"
echo "$VIOLATIONS"
echo
echo "If a hit is a legitimate non-host context (e.g. a container's"
echo "internal init, a documentation example), add the file path to"
echo "EXCLUDE_PATHS at the top of this script."
exit 1
