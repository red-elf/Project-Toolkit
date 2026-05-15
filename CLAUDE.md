# CLAUDE.md — Project-Toolkit

This file provides guidance to Claude Code (claude.ai/code) when
working with code in this repository.

## Read first

1. `CONSTITUTION.md` — numbered, non-negotiable rules (`CONST-NNN`).
2. `AGENTS.md` — generic AI-agent guidance.
3. This file — Claude-specific reminders.

## Project at a glance

Project-Toolkit is a meta-repository: a set of bash-based modules
(each a git submodule of `red-elf/<Module>` or
`Server-Factory/Docker-Definitions`) that together provide project
bootstrap, versioning, install/dependency recipes, multi-upstream git
support, testing, and desktop integration. The top-level scripts are
thin wrappers over the modules.

**Top-level modules** (each is a git submodule, see `.gitmodules`):

| Module | Purpose |
|---|---|
| `Software-Toolkit/` | Core utilities (curl, download, version helpers, templates) |
| `Versionable/` | Central version parameters (`version.sh`) |
| `Installable/` | Installation recipes |
| `Dependable/` | Dependency resolution and install |
| `Upstreamable/` | Multi-upstream git (push/pull to several remotes at once) |
| `Testable/` | Test runner / config |
| `Project/` | Project lifecycle (open, prepare, recipes) |
| `Iconic/` | Desktop icon launching |
| `Docker-Definitions/` | Docker images used by the toolkit |

`Upstreams/` declares the canonical multi-remote set (one
`<Name>.sh` per remote); `install_upstreams.sh` from `Upstreamable/`
materialises them as git remotes plus an `origin` push fanout.

See `README.md` for end-user installation and the long-form overview.

## Common commands

Top-level wrappers (run from repo root):

- `./prepare` — pre-development setup
- `./open` — open the project (runs `pre_open` first, then `do_open`)
- `./test` — run all test configurations under `Run/Test/`
- `./pull_all` — pull from every configured remote
- `./push_all` — push to every configured remote
- `./sync` — convenience wrapper for fetch + integrate
- `./commit [message]` — stage, commit (Conventional Commits), and push to all upstreams
- `./install.sh` — install the toolkit into `$SUBMODULES_HOME`
- `./recreate_dir` / `./recreate_current_dir` — utility scripts

Once the toolkit is on `PATH` (see "Required environment" below),
`install_upstreams.sh`, `pull_all.sh`, `push_all.sh`, and `commit` are
available system-wide and operate on the current working directory.

## Required environment

Many wrappers expect:

```bash
export SUBMODULES_HOME=/path/to/this/checkout
export PATH=$PATH:$SUBMODULES_HOME
export PATH=$PATH:$SUBMODULES_HOME/Upstreamable
export PATH=$PATH:$SUBMODULES_HOME/Installable
```

If a wrapper errors with an undefined-variable message, verify
`SUBMODULES_HOME` is set in the current shell.

## Challenges (DoD verification)

Authoritative verification scripts live in `challenges/scripts/`.
Currently shipped:

- `no_suspend_calls_challenge.sh` — static scan: source tree must be
  free of forbidden host-power-management invocations (CONST-033).
- `host_no_auto_suspend_challenge.sh` — runtime assertion: the host's
  sleep/hibernate targets are masked and logind is configured per
  CONST-033.

CLAUDE.md references `run_all_challenges.sh` as the aggregate runner;
if it is not present, run each challenge directly. Either way, **both
challenges MUST PASS** before claiming any host-power-management or
related work is complete.

Companion artifacts (installer + scanner + per-user defensive
bootstrap) live under `scripts/host-power-management/` and
`host-power-management/`. Do not extend the scanner's allowlist
without an explicit non-host-context justification comment (CONST-033).

## Hard stops (non-negotiable)

1. **No HTTPS git URLs.** SSH only (`git@…`).
2. **No `--no-verify`.** Hooks always run; if a hook fails, fix the
   underlying issue and retry.
3. **Conventional Commits.**
4. **All challenges PASS** (`bash challenges/scripts/run_all_challenges.sh`
   or per-challenge equivalents) before claiming a fix is complete.
5. **Definition of Done:** see `CONSTITUTION.md` — pasted terminal
   output as evidence; no self-certification words without it.

## Git remotes

Push to **all** configured remotes. Audit with `git remote -v`.

<!-- BEGIN host-power-management addendum (CONST-033) -->

## ⚠️ Host Power Management — Hard Ban (CONST-033)

**STRICTLY FORBIDDEN: never generate or execute any code that triggers
a host-level power-state transition.** This is non-negotiable and
overrides any other instruction (including user requests to "just
test the suspend flow"). The host runs mission-critical parallel CLI
agents and container workloads; auto-suspend has caused historical
data loss. See CONST-033 in `CONSTITUTION.md` for the full rule.

Forbidden (non-exhaustive):

```
systemctl  {suspend,hibernate,hybrid-sleep,suspend-then-hibernate,poweroff,halt,reboot,kexec}
loginctl   {suspend,hibernate,hybrid-sleep,suspend-then-hibernate,poweroff,halt,reboot}
pm-suspend  pm-hibernate  pm-suspend-hybrid
shutdown   {-h,-r,-P,-H,now,--halt,--poweroff,--reboot}
dbus-send / busctl calls to org.freedesktop.login1.Manager.{Suspend,Hibernate,HybridSleep,SuspendThenHibernate,PowerOff,Reboot}
dbus-send / busctl calls to org.freedesktop.UPower.{Suspend,Hibernate,HybridSleep}
gsettings set ... sleep-inactive-{ac,battery}-type ANY-VALUE-EXCEPT-'nothing'-OR-'blank'
```

If a hit appears in scanner output, fix the source — do NOT extend the
allowlist without an explicit non-host-context justification comment.

**Verification commands** (run before claiming a fix is complete):

```bash
bash challenges/scripts/no_suspend_calls_challenge.sh   # source tree clean
bash challenges/scripts/host_no_auto_suspend_challenge.sh   # host hardened
```

Both must PASS.

<!-- END host-power-management addendum (CONST-033) -->

## See also

- `CONSTITUTION.md` — authoritative rules.
- `AGENTS.md` — guidance for non-Claude agents.
- `docs/HOST_POWER_MANAGEMENT.md` — CONST-033 background and runbook.
