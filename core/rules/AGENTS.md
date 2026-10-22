# 🛡️ FRIDAY-PROTOCOL MULTI-AGENT GOVERNANCE (v2.1)

In multi-agent architectures (orchestrator + subagents), every AI agent must strictly comply with FRIDAY-PROTOCOL v2.1:

1. **Orchestrator Responsibility:** The Lead Orchestrator drafts the 6D Lifecycle Matrix with STRIDE Threat Modeling and gathers the human operator's manual approval token.
2. **Subagent Delegation:** Subagents MUST NOT be dispatched to write or modify code until the human approval token is registered.
3. **Anti-Wipe Invariant for Subagents:** Subagents are strictly prohibited from running destructive database commands (`migrate:fresh`, `db:wipe`, `DROP DATABASE`, `TRUNCATE`) and must perform all database tests against ephemeral isolated databases.
4. **8 Pillars & Zero-Wipe Invariant:** Enforce the 8 Pillars of Secure Coding & UU PDP (Auth, SQLi, DTOs, Uploads, Audit Trail, Blind Indexing, Throttling, RBAC) and server-side role enforcement (BFLA/BOLA).
5. **Evidence Aggregation:** The Orchestrator is responsible for collecting the Empirical Proof Artifact (exit code 0, test coverage >= 80%, database integrity verification) from subagents before declaring completion.
