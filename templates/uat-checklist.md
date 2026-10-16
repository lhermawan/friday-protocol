# 🧪 Empirical UAT & Evidence Checklist

Use this sheet during **Phase 7 (Empirical UAT)** to record objective proof before declaring any task complete.

---

## 1. Traceability Checklist

- [ ] **Input $\rightarrow$ Live State:**
  - Action performed: 
  - Result:
  - Evidence (log/screenshot/exit code):

- [ ] **Live State $\rightarrow$ Persistence:**
  - Action performed (Save & Cold Reload):
  - Result (did data persist or fallback to default?):
  - Evidence:

- [ ] **Persistence $\rightarrow$ Downstream Consumers (e.g. PDF / Worker / Export):**
  - Action performed:
  - Result (did exported file accurately reflect user input?):
  - Evidence:

- [ ] **Multi-Role & Access Control Check:**
  - Admin Role Test: Status code / payload received.
  - Regular User Negative Test: Verified `403 Forbidden` / null payload received.
  - Evidence:

- [ ] **Anti-Regression Check:**
  - Tested existing adjacent features:
  - Result: No regressions observed.

---

## 2. Hard Evidence Artifact
```text
[Paste terminal exit codes (0), curl responses, or execution stdout here]
```

---

> **Sign-Off Statement:** *"I hereby confirm with empirical evidence that all 6 dimensions of the feature are functional and no existing features were broken."*
