# Retry-push-tolerant — 20260427-122518

Re-runs the 16 HelixAgent submodules that previously failed at the push step,
now with the per-remote-tolerant push helper (exit 0 if at least one remote succeeds).

| Submodule | Status | Exit |
|-----------|--------|------|
| Agentic | OK | 0 |
| Benchmark | OK | 0 |
| Challenges | OK | 0 |
| Containers | OK | 0 |
| ConversationContext | OK | 0 |
| DebateOrchestrator | OK | 0 |
| HelixLLM | OK | 0 |
| HelixMemory | OK | 0 |
| HelixSpecifier | OK | 0 |
| LLMOps | OK | 0 |
| LLMOrchestrator | FAIL | 40 |
| Models | OK | 0 |
| Planning | OK | 0 |
| SelfImprove | OK | 0 |
| SkillRegistry | OK | 0 |
| ToolSchema | OK | 0 |

## Summary
- PASS: 15
- FAIL: 1
