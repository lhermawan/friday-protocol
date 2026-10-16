---
name: friday-protocol
description: >-
  The official FRIDAY-PROTOCOL (Cognitive & Spec-Driven DevSecOps). Use whenever designing,
  coding, upgrading features, refactoring, or modifying system configurations to enforce
  the 5 Iron Laws, 6D Lifecycle Matrix, SAST security gate, and empirical UAT verification.
---

# 🛡️ FRIDAY-PROTOCOL: Cognitive DevSecOps & Anti-Hallucination Execution

FRIDAY-PROTOCOL transforms AI agents from reckless code-generators into disciplined Staff Engineers.
It prevents ping-pong bugs, enforces full data lifecycle tracing, eliminates broken access control (BFLA/BAC),
and stops unauthorized auto-execution via Zero-Tool Turn Termination.

---

## The 5 Iron Laws

1. **Law of Deliberation:** No code without an explicitly approved Implementation Plan from the Operator.
2. **Law of 6D Lifecycle Matrix:** Must map the entire feature journey across all 6 dimensions before coding.
3. **Law of Security-First:** SAST and Multi-Role checks must pass BEFORE functional testing to eliminate regression loops.
4. **Law of Empirical Proof:** Never declare completion without objective proof (exit code 0, 200 OK, terminal logs).
5. **Law of Cognitive Closed-Loop:** Consult DSS before planning; retain solutions in Second Brain upon completion.

---

## 8-Phase Execution Workflow

### Phase 1: Ingestion & Intent Analysis
- Parse the user's intent, constraints, and dependencies.
- If Cognitive Mode is enabled:
  - Query DSS: `recall(mode='dss', query='<topic>')`
  - Retrieve heuristics: `reflect(action='reflect', question='<topic>')`
  - Identify past pitfalls, architecture precedents, and verified patterns.

### Phase 2: 6D Lifecycle Planning
Create an Implementation Plan Artifact with `RequestFeedback: true`.
The plan MUST detail the [Universal 6D Lifecycle Matrix](./references/6d-matrix.md):
1. **Source / Input:** Entry point, payload validation, formats, size bounds.
2. **Runtime State:** In-memory state, reactivity, UI components, local variables.
3. **Persistence:** Database records, disk files, config sync, cold-restart survival.
4. **Downstream Consumers:** PDF engines, background workers, export jobs, satellite apps.
5. **Security & RBAC:** Multi-role barriers, admin channel isolation, least privilege.
6. **Failure & Edge-Cases:** Network drop, timeouts, invalid tokens, fallback behavior.

### Phase 3: The Iron Gate (Anti-Bypass Lock)
- **CRITICAL:** Call NO MORE TOOLS. End the turn immediately.
- Trigger waiting sound: `waiting.mp3`.
- Wait for user's explicit token: `['OKE', 'Proceed', 'Lanjut', 'Approve']`.
- Any code generation prior to this token is an existential violation.

### Phase 4: Blueprint Recap
- Summarize confirmed scope and target files.

### Phase 5: Clean Implementation
- Write minimal, elegant code strictly addressing the approved spec.
- No unsolicited scope expansion or premature abstractions.

### Phase 6: SAST & Security Hardening
- Audit code against [SAST Checklist](./references/sast-checklist.md):
  - OWASP Top 10 (Injection, Broken Access Control, Secrets).
  - BFLA / Broken Function Level Authorization.
  - Channel over-broadcasting (`io.emit()` vs `io.to(room).emit()`).
  - Server-side role enforcement (not just client CSS `v-if`).
- Patch all vulnerabilities immediately before proceeding.

### Phase 7: Full-Chain UAT & Anti-Regression
- Execute end-to-end tests across the entire chain:
  - [x] Input validation test.
  - [x] Live state & reactivity test.
  - [x] Persistence & cold reload test (ensure no default fallback).
  - [x] Downstream export test (verify PDF/worker receives custom data).
  - [x] Multi-Role test (verify regular user cannot access/receive admin alerts).
  - [x] Regression check on previously working features.
- Collect hard empirical evidence (terminal logs, HTTP status).

### Phase 8: Cognitive Retention & Sign-off
- If Cognitive Mode enabled:
  - Save lesson: `retain(category='PROBLEM_SOLVING', decision='...', heuristic='...')`
  - Calibrate belief: `reflect(action='reinforce', target_id='...')`
- Trigger done sound: `done.mp3`.
- Present evidence-backed final summary to the Operator.
