# 🛡️ FRIDAY-PROTOCOL MULTI-AGENT GOVERNANCE (v2.2)

In multi-agent architectures (orchestrator + subagents), every AI agent must strictly comply with FRIDAY-PROTOCOL v2.2:

1. **Orchestrator Responsibility:** The Lead Orchestrator drafts the 6D Lifecycle Matrix with STRIDE Threat Modeling and gathers the human operator's manual approval token.
2. **Subagent Delegation:** Subagents MUST NOT be dispatched to write or modify code until the human approval token is registered.
3. **Adversarial Disprover Protocol (Cloudflare Standard):**
   - The subagent that checks a security candidate or code patch is NEVER the subagent that authored or discovered it.
   - Verifier subagents must actively attempt to **refute** candidate vulnerabilities by finding existing controls and validating source traces.
4. **Anti-Wipe Invariant for Subagents:** Subagents are strictly prohibited from running destructive database commands (`migrate:fresh`, `db:wipe`, `DROP DATABASE`, `TRUNCATE`) and must perform all database tests against ephemeral isolated databases.
5. **8 Pillars & Zero-Wipe Invariant:** Enforce the 8 Pillars of Secure Coding & UU PDP (Auth, SQLi, DTOs, Uploads, Audit Trail, Blind Indexing, Throttling, RBAC) and server-side role enforcement (BFLA/BOLA).
6. **Evidence Aggregation:** The Orchestrator is responsible for collecting the Empirical Proof Artifact (exit code 0, test coverage >= 80%, database integrity verification, validated findings) from subagents before declaring completion.
