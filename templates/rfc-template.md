# 📑 Request For Change (RFC): [RFC-YYYYMMDD-XXX]

> **Standard:** FRIDAY-PROTOCOL v2.0.0 (ITIL & BSSN DevSecOps Aligned)  
> **Status:** [DRAFT / PENDING_CAB_APPROVAL / APPROVED / IMPLEMENTING / COMPLETED / ROLLED_BACK]  
> **System / Target Node:** [e.g. lucky (100.117.89.44) / vm-maskii (100.79.34.4) / SIKANDI Prod]

---

## 1. Change Inception & Metadata

| Field | Detail |
| :--- | :--- |
| **RFC Identifier** | `RFC-20261021-001` |
| **Change Category** | [Standard / Normal / Emergency] |
| **Requester** | [Name / Role / Agent] |
| **System / Service** | [e.g. SIKANDI API, Auth Service, DB Cluster] |
| **Target Implementation Window**| [Date & Time UTC/WIB] |
| **Estimated Downtime** | [None (Zero-downtime rolling) / 10 Minutes] |

---

## 2. Business Justification & Technical Scope
- **Reason for Change:** What problem or business requirement does this change address?
- **Detailed Scope of Work:**
  - Files to be updated:
  - Database migrations / schema changes:
  - Configuration or environment variables:
- **Non-Goals / Out of Scope:**

---

## 3. Security & Impact Assessment (BSSN Standard)
- **Service Impact:** Which users, OPDs, or dependent services will be affected during the deployment?
- **Security Assessment:**
  - [ ] Are new ports or public endpoints exposed?
  - [ ] Does this alter authentication, encryption, or RBAC logic?
  - [ ] Is personally identifiable information (PII) handled compliant with UU PDP?
  - [ ] Have static security scans (SAST / Gitleaks / Trivy) passed with Zero High/Critical findings?

---

## 4. Rollback & Contingency Plan (Mandatory)
Every production change MUST have an explicit, tested rollback plan:
- **Rollback Trigger Criteria:** (e.g., HTTP 5xx error rate > 1%, critical auth failure, DB timeout > 5s).
- **Step-by-Step Rollback Procedure:**
  1. Revert Git release tag / commit: `git checkout <previous-tag>`
  2. Rollback database migrations: `php artisan migrate:rollback --step=1` (or equivalent)
  3. Restore configuration backup: `cp .env.backup .env`
  4. Restart services & verify health: `pm2 restart <app> || systemctl restart <app>`
- **Backup Verification:** Confirmed that a full database dump and state backup exist prior to deployment.

---

## 5. Post-Implementation Verification & UAT Checklist
- [ ] Service restarted and HTTP 200 OK returned on `/health` endpoint.
- [ ] Database migrations applied cleanly with zero orphaned foreign keys.
- [ ] Sentry real-time error monitor observed for 15 minutes (Zero new exceptions).
- [ ] Critical user journeys tested (Login $\rightarrow$ Action $\rightarrow$ Audit Log generated).
- [ ] Multi-role permission check verified (Admin vs Regular User).

---

## 6. Authorization & Sign-off (CAB Gate)

| Role | Name | Status | Date & Timestamp |
| :--- | :--- | :--- | :--- |
| **Change Requester** | | Submitted | |
| **Security Reviewer** | | Approved | |
| **Operations Lead / CAB** | | Approved | |
| **Post-Implementation Review** | | Closed / Signed-off | |
