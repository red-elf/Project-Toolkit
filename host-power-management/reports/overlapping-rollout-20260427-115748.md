# Overlapping-projects rollout — 20260427-115748

These 11 projects are both workspace standalones AND HelixAgent submodules.
Run in parallel with the HelixAgent recursion (idempotent; race losers retried).

| Project | Status | Exit | Notes |
|---------|--------|------|-------|
| Auth | OK | 0 | |
| Concurrency | OK | 0 | |
| Database | OK | 0 | |
| DocProcessor | FAIL | 10 | git sync failed |
| Formatters | OK | 0 | |
| LLMOrchestrator | FAIL | 10 | git sync failed |
| LLMProvider | FAIL | 10 | git sync failed |
| LLMsVerifier | OK | 0 | |
| Security | OK | 0 | |
| Storage | OK | 0 | |
| VisionEngine | FAIL | 10 | git sync failed |

## Summary
- PASS: 7
- FAIL: 4
