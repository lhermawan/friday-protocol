# 🧪 Empirical UAT & Evidence Checklist (BSSN & DevSecOps Aligned)

> **Standard:** FRIDAY-PROTOCOL v2.0.0  
> **Mandate:** Record hard, objective proof during **Phase 7 (Empirical UAT)** BEFORE declaring any task complete. No task may be marked done based on assumptions or hypothetical code reviews.

---

## 1. Full-Chain Traceability Checklist

### 1.1 Input $\rightarrow$ Live State & Schema Validation
- [ ] **Action:** Submit valid and intentionally malformed payloads (boundary testing).
- [ ] **Expected:** Valid payloads update state reactively; malformed payloads return clear 422/400 errors without server crashes.
- [ ] **Empirical Proof:** `[Paste HTTP response / test runner output]`

### 1.2 Live State $\rightarrow$ Persistence (Cold Restart Test)
- [ ] **Action:** Save changes, then execute a hard reboot/cold restart (Ctrl+F5, restart process, clear local cache).
- [ ] **Expected:** Data persists accurately from database/storage without reverting to default presets.
- [ ] **Empirical Proof:** `[Paste database query row / file inspection proof]`

### 1.3 Persistence $\rightarrow$ Downstream Consumers & Queues
- [ ] **Action:** Trigger export (PDF, Excel, report) or background worker queue.
- [ ] **Expected:** Downstream engine consumes persisted state; sensitive PII is masked; jobs complete with status `COMPLETED`.
- [ ] **Empirical Proof:** `[Paste worker log / PDF inspection verification]`

### 1.4 Security & Multi-Role Negative Verification (BFLA/BOLA)
- [ ] **Admin Test:** Privileged user accesses target route and receives `200 OK`.
- [ ] **Non-Admin Negative Test:** Regular authenticated user or anonymous guest attempts same action and receives strict `403 Forbidden` or `401 Unauthorized`.
- [ ] **Channel Isolation Test:** Ensure WebSocket alerts are scoped (`io.to('admin')`), never leaked to regular clients.
- [ ] **Empirical Proof:** `[Paste curl command / HTTP status codes]`

### 1.5 UU PDP & Audit Trail Verification
- [ ] **Data at Rest Check:** Database records confirm sensitive PII (NIK, salary) is stored encrypted (**AES-256-CBC**).
- [ ] **Blind Index Check:** Query by `*_hash` returns exact match efficiently without plaintext leak.
- [ ] **Audit Log Verification:** Query `audit_logs` table confirms an immutable entry was written:
  - `actor_id`, `action_type`, `resource_id`, `timestamp`, `ip_address`, `before_after_json`.
- [ ] **Empirical Proof:** `[Paste select * from audit_logs output]`

### 1.6 Pre-Release Security Scans (SAST & SCA)
- [ ] **Gitleaks Scan:** Zero secrets detected (`Exit Code 0`).
- [ ] **Trivy fs Scan:** Zero HIGH or CRITICAL CVEs in dependencies (`Exit Code 0`).
- [ ] **Test Coverage:** Automated unit/feature test suite passes with coverage $\ge 80\%$.
- [ ] **Empirical Proof:** `[Paste scan command output]`

---

## 2. Hard Empirical Evidence Log
```text
[Paste terminal exit codes (0), test runner output, curl status lines, or logs here]
```

---

> **Sign-Off Statement:** *"I hereby confirm with empirical proof that all 6 dimensions of the feature are functional, the 8 pillars of secure coding are upheld, and no regressions exist in adjacent systems."*
