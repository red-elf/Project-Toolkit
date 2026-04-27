# Final verification — 20260427-123922

Per-project status of the host-power-management rollout. Columns:
- **scripts/**: `scripts/host-power-management/` directory present
- **chal/**: `challenges/scripts/{host_no_auto_suspend,no_suspend_calls}_challenge.sh` present
- **docs/**: `docs/HOST_POWER_MANAGEMENT.md` present
- **CLAUDE addendum**: CONST-033 block present in CLAUDE.md (HEAD)
- **scanner**: `no_suspend_calls_challenge.sh` exits 0
- **host**: `host_no_auto_suspend_challenge.sh` exits 0
- **all-pushed**: every configured remote at ahead=0

| Project | scripts | chal | docs | CLAUDE | scanner | host | all-pushed |
|---------|---------|------|------|--------|---------|------|------------|
| HelixAgent | Y | Y | Y | Y | PASS | PASS | Y |
| HelixCode | Y | Y | Y | Y | PASS | PASS | Y |
| HelixFlow | Y | Y | Y | Y | PASS | PASS | Y |
| HelixGitpx | Y | Y | Y | Y | PASS | PASS | Y |
| HelixTranslate | Y | Y | Y | Y | PASS | PASS | Y |
| Helix | Y | Y | Y | Y | PASS | PASS | Y |
| Boba | Y | Y | Y | Y | PASS | PASS | Y |
| Catalogizer | Y | Y | Y | Y | PASS | PASS | N |
| MeTube | Y | Y | Y | Y | PASS | PASS | Y |
| LLMsVerifier | Y | Y | Y | Y | PASS | PASS | Y |
| LLMGateway | Y | Y | Y | Y | PASS | PASS | Y |
| LLMOrchestrator | Y | Y | Y | N | PASS | PASS | N |
| LLMProvider | Y | Y | Y | Y | PASS | PASS | N |
| Auth | Y | Y | Y | Y | PASS | PASS | Y |
| Auth-KMP | Y | Y | Y | Y | PASS | PASS | Y |
| Bear-Mail | Y | Y | Y | Y | PASS | PASS | Y |
| Bear-Messenger | Y | Y | Y | Y | PASS | PASS | Y |
| Concurrency | Y | Y | Y | Y | PASS | PASS | Y |
| Concurrency-KMP | Y | Y | Y | Y | PASS | PASS | Y |
| Config | Y | Y | Y | Y | PASS | PASS | Y |
| Config-KMP | Y | Y | Y | Y | PASS | PASS | Y |
| Database | Y | Y | Y | Y | PASS | PASS | Y |
| Database-KMP | Y | Y | Y | Y | PASS | PASS | Y |
| Document | Y | Y | Y | Y | PASS | PASS | Y |
| Document-KMP | Y | Y | Y | Y | PASS | PASS | Y |
| Distributed-AOSP-Building | Y | Y | Y | Y | PASS | PASS | Y |
| DocProcessor | Y | Y | Y | N | PASS | PASS | N |
| Formatters | Y | Y | Y | Y | PASS | PASS | Y |
| Formatters-KMP | Y | Y | Y | Y | PASS | PASS | Y |
| My-Patreon-Manager | Y | Y | Y | Y | PASS | PASS | Y |
| Notes | Y | Y | Y | Y | PASS | PASS | Y |
| Project-Toolkit | Y | Y | Y | Y | PASS | PASS | Y |
| Proxy | Y | Y | Y | Y | PASS | PASS | Y |
| RateLimiter | Y | Y | Y | Y | PASS | PASS | Y |
| RateLimiter-KMP | Y | Y | Y | Y | PASS | PASS | Y |
| Security | Y | Y | Y | Y | PASS | PASS | Y |
| Security-KMP | Y | Y | Y | Y | PASS | PASS | Y |
| Storage | Y | Y | Y | Y | PASS | PASS | Y |
| Storage-KMP | Y | Y | Y | Y | PASS | PASS | Y |
| UI-Components-KMP | Y | Y | Y | Y | PASS | PASS | Y |
| VisionEngine | N | N | N | N | - | - | N |
| Yole | Y | Y | Y | Y | PASS | PASS | Y |
| CCode-Private | Y | Y | Y | Y | PASS | PASS | Y |

## Summary (44 in-scope workspace projects)
- **Fully deployed (everything Y/PASS, all remotes pushed):** 38
- **Partial (artifacts present but governance / push not fully applied):** 4
- **Failed (artifacts missing):** 1
