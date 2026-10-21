# 🛡️ SAST & Security Hardening Checklist (BSSN & OWASP Aligned)

> **Standard:** FRIDAY-PROTOCOL v2.0.0  
> **Mandate:** All code generated or modified by AI agents and developers must be audited against this checklist during **Phase 6 (SAST)** BEFORE functional UAT begins.  
> **Alignment:** BSSN RI Secure Application Guidelines, OWASP API Top 10, UU No. 27/2022 Pelindungan Data Pribadi (UU PDP).

---

## 🏛️ The 8 Pillars of Secure Backend Engineering

### 1. Insecure Web Authentication & Session Governance
- [ ] **Short-Lived Access Tokens:** JWT `access_token` lifetime MUST be strictly short (5–15 minutes). Never issue tokens valid for days/weeks.
- [ ] **HttpOnly Cookie Storage:** Refresh tokens and sensitive auth state MUST be stored in `HttpOnly, Secure, SameSite=Lax/Strict` cookies to block XSS theft. Never store long-lived tokens in `localStorage` or `sessionStorage`.
- [ ] **Cryptographic Signature & Claim Validation:** Always verify token signature, issuer (`iss`), audience (`aud`), and expiration (`exp`) on every incoming request.
- [ ] **Revocation & Logout Mechanism:** Provide explicit token revocation lists (e.g., Redis blocklist / database token invalidation) so compromised tokens can be terminated immediately.
- [ ] **Single Sign-On (SSO) Drift Check:** Re-verify subject identity on session restore or tab refocus to prevent account contamination.

### 2. SQL & Command Injection Prevention (OWASP A03)
- [ ] **Parameter Binding / Prepared Statements:** NEVER concatenate or interpolate raw user inputs into SQL/NoSQL queries (`SELECT * WHERE id = " . $input`).
- [ ] **ORM & Query Builder Discipline:** Use safe ORM methods (Eloquent, Prisma, TypeORM, SQLAlchemy) and verify that raw expressions (`DB::raw()`, `$query->whereRaw()`) do not contain unsanitized input.
- [ ] **Input Sanitization & Type Coercion:** Reject payloads with malformed characters or unexpected SQL keywords before queries execute.
- [ ] **Command Execution Prohibition:** Prohibit raw `exec()`, `system()`, `spawn()`, or `eval()` using dynamic client input.

### 3. Mass Assignment & DTO Strictness
- [ ] **Single-Responsibility Endpoints:** Avoid "fat" multi-purpose update endpoints. Break routes down into granular, purpose-built APIs (e.g., `/user/update-profile` vs `/admin/assign-role`).
- [ ] **Explicit Whitelisting (`$fillable` / DTOs):** Never trust `request()->all()`. Use strict Data Transfer Objects (DTOs), Zod schemas, or explicit `$fillable` arrays. Never use empty `$guarded = []`.
- [ ] **Privilege Guarding:** Ensure sensitive attributes like `role`, `is_admin`, `balance`, `status`, or `verified` cannot be injected through public request bodies.

### 4. Multi-Layer File Upload Defense
- [ ] **MIME Type & Extension Whitelist:** Validate both extension and MIME type against a strict whitelist (e.g., `image/jpeg`, `image/png`, `application/pdf`).
- [ ] **Magic Bytes Inspection:** Inspect initial file header bytes (magic bytes) to ensure renamed binaries/scripts cannot bypass extension checks.
- [ ] **Unpredictable Random Naming:** Rename uploaded files using cryptographically secure random names (UUIDv4 or SHA-256 hash). Never preserve original client filenames or sequential IDs (`file_0001.jpg`).
- [ ] **Private Cloud Storage & Signed URLs:** Store sensitive files (e.g., KTP, slips, invoices) in private non-public directories or private S3 buckets. Deliver access only via temporary signed URLs with short expiry.
- [ ] **Disable Direct Execution:** Ensure target upload directories have script execution disabled (`Options -Indexes -ExecCGI` / `nginx: location ^~ /uploads { deny all; }`).

### 5. Non-Repudiation & Tamper-Proof Audit Trail
- [ ] **Structured Audit Event Logging:** Record an immutable audit log for all critical business actions (CREATE, UPDATE, DELETE, APPROVE, REJECT, DISBURSE, ROLE_CHANGE).
- [ ] **Mandatory Context Capture:** Audit logs MUST record:
  1. `actor_id` (User ID / Agent ID).
  2. `action_type` (Enum: APPROVE, EDIT, etc.).
  3. `resource_type` and `resource_id`.
  4. Server-side `timestamp` (UTC ISO 8601).
  5. `ip_address` and `user_agent`.
  6. Before-After state snapshot (State delta in JSON).
- [ ] **Append-Only / Read-Only Storage:** Audit trail tables must not support modification or unauthorized deletion.
- [ ] **No Cascade Deletions:** Audit logs and security event foreign keys MUST use `ON DELETE SET NULL`, never `CASCADE`, to preserve forensic evidence if a user account is deleted.

### 6. UU PDP Compliance & Insecure Privacy Data Handling (PII Protection)
- [ ] **Strong Encryption at Rest:** Personally Identifiable Information (PII) such as NIK, KTP number, bank accounts, and salaries MUST be encrypted using authenticated encryption (**AES-256-CBC** with unique IV and HMAC, or AES-256-GCM).
- [ ] **Blind Indexing for High-Performance Queries:** If encrypted PII needs to be queried by exact match, compute and store a hashed search index (e.g., `nik_hash = HMAC_SHA256(nik, secret_pepper)`). Index the hash column in the database; never search plaintext across rows.
- [ ] **Data Minimization & Masking:** Mask sensitive data when rendering in Admin UIs and public API responses (e.g., `3207**********01`, `lucky****@gmail.com`).
- [ ] **Log & Backup Sanitization:** Ensure PII, passwords, and tokens are scrubbed from server logs, Sentry error reports, and database dump backups.

### 7. DoS, Brute Force & Resource Exhaustion Defense
- [ ] **Rate Limiting Middleware:** Enforce API rate limits per IP and route on sensitive endpoints (e.g., maximum 5 requests/minute for login, submission, or claim verification: HTTP 429).
- [ ] **Anti-Bot Invisible Honeypots:** Embed hidden honeypot fields in public forms to silently trap and drop spam submissions without frustrating human users.
- [ ] **Adaptive Verification (CAPTCHA):** Apply CAPTCHA (Cloudflare Turnstile, reCAPTCHA v3) on high-risk public endpoints upon abnormal traffic spikes.
- [ ] **UI Protection & Debouncing:** Disable submit buttons immediately upon click to prevent accidental double-submission or race conditions.
- [ ] **Worker Queue Offloading:** Long-running processes (PDF compiling, mass notifications, analytics) must be offloaded to asynchronous background queues to avoid starving HTTP thread pools.

### 8. Elevation of Privilege & Broken Access Control (OWASP A01)
- [ ] **Server-Side Authorization Boundary:** Enforce roles and permissions via server-side middleware, Policies, and Gates. Never rely on frontend CSS (`display: none`) or conditional rendering (`v-if="user.isAdmin"`).
- [ ] **BFLA (Broken Function Level Authorization):** Verify that administrative endpoints cannot be accessed by authenticated regular users or anonymous visitors.
- [ ] **BOLA / IDOR (Broken Object Level Authorization):** Ensure queries for resources verify ownership or tenancy (`WHERE id = :id AND tenant_id = :currentTenant`).
- [ ] **WebSocket & Broadcast Channel Scoping:** Never broadcast private alerts to all connected clients (`io.emit()`). Always scope broadcasts to private authenticated rooms (`io.to('admin_room').emit()`).

---

## 🔑 Secrets & Credential Hygiene
- [ ] **Zero Hardcoded Secrets:** Scan code with Gitleaks. Ensure no API tokens, SSH keys, database credentials, or Tailscale auth keys are in git.
- [ ] **Environment Segregation:** Store all configurations in `.env` files protected by `.gitignore` or dedicated Secret Managers (Vault, Infisical).
