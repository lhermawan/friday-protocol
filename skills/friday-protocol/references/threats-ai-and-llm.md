# 🤖 AI, LLM, and Agentic Threat Catalog

> **Standard:** FRIDAY-PROTOCOL v2.2.0 (Cognitive DevSecOps)  
> **Target Surface:** Chatbots, AI Agents, Autonomous Tool-Calling Loops, RAG Pipelines, MCP (Model Context Protocol) Clients/Servers, and Persistent Knowledge Graphs.  
> **Core Invariant:** *Untrusted Content $\rightarrow$ Model/Memory $\rightarrow$ Sinks (Database, Shell, IPC, API).*

---

## 🏛️ Core Hunting Discipline

1. **Prompt Injection Alone is Not a Finding:** Require a concrete, source-visible boundary failure where attacker-influenced content reaches another principal's session, invokes unauthorized authority, leaks sensitive context, or feeds an unsafe downstream sink.
2. **Model Outputs & Tool Arguments are Untrusted:** Never trust model-generated arguments directly. The backend dispatcher must enforce strict schema parsing, tenant boundary checks, and capability allowlists before execution.
3. **Guardrail Prompts are NOT Security Boundaries:** System prompts like *"Do not reveal secrets"* are easily bypassed by jailbreaks. Only deterministic backend code controls, parameter binding, cryptographic isolation, and hard RBAC gates constitute valid defenses.
4. **Action-Confirmation & Approval Binding:** An approval token from an operator is strictly bound to the exact, normalized action, target resource, and parameter set. Approvals must never carry over across turns or apply to mutated arguments.

---

## 🔍 Attack Classes & Hunting Vectors

### 1. Context, Retrieval, and Memory Attacks
- **Indirect Prompt Injection via RAG / Knowledge Base:**
  - *Vector:* Attacker injects adversarial instructions into indexed documents, tickets, issues, external web pages, or email threads consumed by RAG pipelines.
  - *Vulnerability:* The model reads injected instructions and switches roles or extracts other users' data.
  - *Audit Check:* Ensure retrieval queries strictly filter by authenticated `tenant_id`/`user_id`, and prompt assembly strictly delimits untrusted document snippets from system governance instructions.
- **Cross-Session / Cross-Tenant Context Bleed:**
  - *Vector:* Vector database caches, semantic search indexes, or embedding store lookups omit tenant isolation keys.
  - *Audit Check:* Verify that every vector search query explicitly passes tenant metadata filters at the database engine level, not in client post-processing.
- **Persistent Memory & Belief Poisoning:**
  - *Vector:* Low-trust user interactions or third-party web content are persistently retained into the Second Brain / episodic graph without operator sign-off or secret sanitization.
  - *Audit Check:* Enforce sanitization gates and provenance verification before calling `retain` or mutating long-term cognitive graph nodes.

### 2. Tool-Calling & Sink Injection
- **Tool-Argument Injection into Downstream Sinks:**
  - *Vector:* LLM tool call outputs raw arguments into SQL query builders, shell execution commands (`child_process.exec`, `system()`), filesystem paths, or HTTP fetch clients.
  - *Audit Check:* Verify that tool handler functions re-validate and parameterize every argument. Structured JSON tool calls do not guarantee safety.
- **Excessive Agency & Confused Deputy:**
  - *Vector:* The AI agent executes commands using high-privilege service credentials (e.g. root DB connection, master API key) without verifying if the human initiator possesses rights to the target entity.
  - *Audit Check:* Verify that tool execution evaluates server-side authorization policies (BFLA/BOLA) against the calling user's identity, not the agent's system credentials.
- **Unbounded Delegated Action Loops:**
  - *Vector:* Autonomous agent recursive loops enqueue endless API calls, external transactions, or compute jobs without a per-request budget, timeout, or cancellation token.
  - *Audit Check:* Enforce maximum iterations, wall-clock timeout caps, and per-action spend limits.

### 3. MCP (Model Context Protocol) Security
- **Subagent & MCP Trust Inheritance:**
  - *Vector:* Delegated subagents or third-party MCP servers receive unrestricted environment tokens, global filesystem access, or root credentials.
  - *Audit Check:* Practice least privilege; provide scoped capability tokens and sandbox scratch directories.
- **MCP Server Identity & Tool Collision:**
  - *Vector:* Malicious or untrusted MCP server registers a tool with the same name as a trusted system tool, intercepting sensitive parameters.
  - *Audit Check:* Namespace tool identifiers by verified server URI/origin (`server:tool_name`).
- **MCP Metadata as Authority:**
  - *Vector:* Backend trusts descriptions, tool schemas, or completion hints from external MCP servers as authorization policy.
  - *Audit Check:* External MCP metadata must guide LLM selection only; actual execution permissions must reside in local, immutable policy.
