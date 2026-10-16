# 🛡️ SAST & Security Hardening Checklist

All code produced under the FRIDAY-PROTOCOL must be audited against this checklist during **Phase 6 (SAST)** BEFORE functional UAT begins.

---

## 1. Access Control & Authorization (OWASP A01: Broken Access Control)
- [ ] **BFLA (Broken Function Level Authorization):** Verify that administrative endpoints and controllers enforce strict server-side role checks (`requireRole('admin')`).
- [ ] **BOLA / IDOR (Broken Object Level Authorization):** Ensure users can only query/update records belonging to their tenant/account (e.g., `WHERE id = :id AND user_id = :currentUser`).
- [ ] **Client vs Server Enforcement:** Never rely on frontend CSS (`display: none`) or conditional rendering (`v-if="user.isAdmin"`) for security. Always enforce guards at the API boundary.

## 2. Realtime & Event Broadcasting Isolation
- [ ] **Channel Scoping:** For WebSockets, SSE, and Pub/Sub systems, verify that admin alerts are emitted ONLY to authenticated admin rooms (`io.to('admin_room').emit(...)`), NEVER broadcast to all sockets (`io.emit(...)`).
- [ ] **Payload Sanitization:** Ensure real-time message payloads do not leak sensitive PII, hashes, or internal database keys to unauthorized listeners.

## 3. Single Sign-On (SSO) & Session Governance
- [ ] **Single Logout (SLO):** Ensure logging out of the Identity Provider (IdP) revokes active sessions across satellite service providers.
- [ ] **Session Drift Check:** Satellite apps must re-verify the active subject on focus or cold start. If the active user has switched, purge stale tokens and re-authenticate.
- [ ] **Zombie Token Prevention:** Set sensible expiration times (`exp`) and support explicit revocation lists (e.g., Redis blacklists).

## 4. Injection & Input Sanitization (OWASP A03: Injection)
- [ ] **SQL / NoSQL Injection:** Use parameterized queries or ORMs exclusively. No raw string concatenation in SQL queries.
- [ ] **Command Injection:** Avoid running unsanitized user inputs through `exec()`, `spawn()`, or shell commands.
- [ ] **XSS (Cross-Site Scripting):** Sanitize HTML outputs and escape rendered user strings. Use Content Security Policies (CSP).

## 5. Secrets & Credential Hygiene
- [ ] **No Hardcoded Secrets:** Scan for exposed API keys, private tokens, passwords, or Tailscale auth keys.
- [ ] **Environment Isolation:** Use `.env` or secret managers. Ensure `.env` is listed in `.gitignore`.
