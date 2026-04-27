# CLAUDE.md — {{PROJECT_NAME}}

This file provides guidance to Claude Code (claude.ai/code) when
working with code in this repository.

## Read first

1. `CONSTITUTION.md` — numbered, non-negotiable rules (`CONST-NNN`).
2. `AGENTS.md` — generic AI-agent guidance.
3. This file — Claude-specific reminders.

## Project at a glance

{{ONE_LINE_PROJECT_BRIEF}}

See `README.md` for the long-form overview.

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

{{INSERT_CONST_033_BLOCK}}

## See also

- `CONSTITUTION.md` — authoritative rules.
- `AGENTS.md` — guidance for non-Claude agents.
- `docs/HOST_POWER_MANAGEMENT.md` — CONST-033 background and runbook.
