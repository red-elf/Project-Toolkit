# AGENTS.md — {{PROJECT_NAME}}

> **Audience:** AI coding agents (Codex, Cursor, OpenCode, Crush, etc.)
> working in this repository. For Claude Code specifically, see also
> `CLAUDE.md`.

## Project at a glance

{{ONE_LINE_PROJECT_BRIEF}}

See `README.md` for the long-form overview.

## How to work in this repo

1. Read `CONSTITUTION.md` first — its numbered rules (`CONST-NNN`) are
   non-negotiable.
2. Use SSH URLs for git (`git@…`). HTTPS is prohibited.
3. Conventional Commits (`feat:`, `fix:`, `chore:`, …).
4. Run `challenges/scripts/run_all_challenges.sh` before claiming a
   fix is complete (or the per-challenge equivalents listed in
   `README.md`).
5. Don't bypass git hooks (`--no-verify`). If a hook fails, fix the
   underlying issue and retry.

## Git remotes

Push to **all** configured remotes. Audit with `git remote -v`.

{{INSERT_CONST_033_BLOCK}}

## See also

- `CONSTITUTION.md` — authoritative rules.
- `CLAUDE.md` — Claude Code-specific guidance.
- `docs/HOST_POWER_MANAGEMENT.md` — CONST-033 background and runbook.
