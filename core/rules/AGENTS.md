# 🛡️ FRIDAY-PROTOCOL: MULTI-AGENT SPECIFICATION

In multi-agent architectures (orchestrator + subagents), the **Lead Orchestrator** is strictly governed by the FRIDAY-PROTOCOL:

1. **Orchestrator Responsibility:** The Orchestrator drafts the 6D Lifecycle Matrix and gathers the human operator's approval token.
2. **Subagent Delegation:** Subagents MUST NOT be dispatched to write code until the human approval token is registered.
3. **Evidence Aggregation:** The Orchestrator is responsible for collecting the Empirical Proof Artifact from subagents before declaring completion.
