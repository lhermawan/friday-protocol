# 📊 Universal 6D Lifecycle Matrix & Threat Modeling Guide

> **Standard:** FRIDAY-PROTOCOL v2.1.0  
> **Mandate:** The **Universal 6D Lifecycle Matrix** forces AI agents and engineers to examine the complete end-to-end journey of every feature before writing any code.  
> **Integration:** Combines Full Data-Flow Tracing with **Anti-Wipe Database Safeguards**, **STRIDE Threat Modeling (NIST SP 800-160/154)**, and CIA Triad mapping to eradicate "Ping-Pong QA", architectural oversights, and catastrophic data loss.

---

## 🏛️ The 6 Mandatory Dimensions

Every Implementation Plan MUST address each dimension in concrete detail:

### 1. Source & Ingestion Dimension (The Entry Point)
- **Origination:** Form inputs, REST API payload, GraphQL, Webhook, WebSocket, CLI flag, file upload.
- **Verification & Defense Rules:**
  - Strict input schemas (Zod, Pydantic, FormRequest) with type coercion and size limits.
  - Granular single-responsibility API routes (prevent "fat update" endpoints).
  - Multi-layer upload validation (MIME whitelist, extension, magic bytes header, UUID/hash file renaming).
  - Anti-bot traps: Hidden honeypot fields on public endpoints.

### 2. Runtime & Reactive State Dimension (In-Memory Processing)
- **Lifecycle:** Memory footprint in React/Vue stores (Pinia, Redux, Zustand), backend process memory, worker threads.
- **Verification & Defense Rules:**
  - Token memory hygiene: Store short-lived access tokens (5–15 min) in memory or secure context; NEVER store long-term secrets in `localStorage`.
  - Reactive sync: UI must update reactively without requiring manual reloads.
  - Lifecycle cleanup: Unsubscribe event listeners, WebSocket rooms, and worker polling on component unmount to prevent memory leaks and zombie connections.

### 3. Storage & Persistence Dimension (The Source of Truth & Anti-Wipe Invariant)
- **Persistence Target:** PostgreSQL, MySQL, Redis, SQLite, disk files, S3 buckets.
- **Anti-Wipe & Zero-Data-Loss Invariant:**
  - **Zero Destructive Commands:** Strictly FORBIDDEN from running `migrate:fresh`, `migrate:reset`, `db:wipe`, `DROP TABLE`, or `TRUNCATE` against active dev or production databases.
  - **Additive Migrations Only:** New schema changes must be non-destructive (`ALTER TABLE ... ADD COLUMN`, nullable defaults, or multi-step backfills).
  - **Foreign Key Cascade Protection:** Never use `ON DELETE CASCADE` blindly on critical audit logs, telemetry, or security events; use `ON DELETE SET NULL` or `RESTRICT` to prevent mass orphan data loss.
  - **Test Suite Isolation:** Guarantee that unit/e2e test runners use isolated ephemeral databases (e.g., `:memory:` or `_test`), never the active development database.
  - **Cold Restart Test:** Hard-refresh the page (Ctrl+F5) or restart the backend process. Does the state remain intact, and do existing database records survive without falling back to defaults?
  - **UU PDP (PII Protection):** Sensitive data (NIK, financial details, passwords) MUST be encrypted at rest using authenticated **AES-256-CBC/GCM**.
  - **Blind Indexing:** Implement indexed hash columns (`nik_hash = HMAC(nik, secret)`) for instant searchability without plaintext exposure.
  - **Audit Non-Repudiation:** Record actor ID, action enum, target resource, timestamp, and IP into immutable audit tables. Foreign keys for security logs must use `ON DELETE SET NULL`.

### 4. Downstream & Consumer Pipeline Dimension (The Ripple Effect)
- **Dependent Subsystems:**
  - Document & PDF compilation engines (Puppeteer, Playwright, wkhtmltopdf).
  - Background workers, queue jobs (BullMQ, Celery, Laravel Queue).
  - Satellite platforms (e.g., Single Sign-On consumers, webhook subscribers, analytics reporting).
- **Verification & Defense Rules:**
  - Confirm that modifications to state flow cleanly into exported PDFs, notifications, and satellite systems.
  - Async queue isolation: Heavy computational tasks (file compression, mass mailing) must run asynchronously to protect API response latency.

### 5. Security, RBAC & STRIDE Threat Modeling Dimension
- **Adversarial Thinking (NIST SP 800-160):** Think like an attacker before implementing.
- **The STRIDE vs CIA Triad Matrix:**

| STRIDE Threat Category | Violates Security Goal | Target Defense Checklist |
| :--- | :--- | :--- |
| **S** - **Spoofing** (Impersonating someone else) | **Authentication** | HttpOnly cookies, signature verification, multi-factor auth, session drift verification. |
| **T** - **Tampering** (Modifying data in transit/rest) | **Integrity** | Parameterized queries (anti-SQLi), DTO payload whitelisting, cryptographic payload signing. |
| **R** - **Repudiation** (Denying an action was taken) | **Non-Repudiation** | Immutable append-only audit trail logging (Actor, Time, IP, Action, Before-After delta). |
| **I** - **Information Disclosure** (Data leaks) | **Confidentiality** | PII field masking in UI/API, private storage buckets, signed URLs, zero-leak exception handlers. |
| **D** - **Denial of Service** (Crashing or exhausting system) | **Availability** | Rate limiting / route throttling (5 req/min), anti-bot honeypots, submit button disabling, async queues. |
| **E** - **Elevation of Privilege** (Unauthorized privileges) | **Authorization** | Strict server-side Gates & Policies (BFLA/BOLA checks), isolated admin routes, channel scoping (`io.to()`). |

### 6. Failure Modes & Edge-Cases Dimension (Resilience Under Fire)
- **Failure Scenarios:** Database timeouts, third-party API downtime, network disconnects, token expiration during checkout/form submission, concurrent race conditions.
- **Verification & Defense Rules:**
  - Database transactions (`DB::transaction`) to ensure atomic multi-table operations with automatic rollback.
  - Graceful HTTP 429 (Too Many Requests) handling with user-friendly retry banners.
  - Real-time exception capture via Sentry / central telemetry with PII scrubbed out.
  - Explicit rollback plan documented for every production release.
