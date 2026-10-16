# 📊 Universal 6D Lifecycle Matrix Guide

The **Universal 6D Lifecycle Matrix** forces AI agents to examine the complete end-to-end journey of a feature before generating any code. This directly eliminates the "Ping-Pong QA" trap where fixing one layer breaks downstream consumers.

---

## The 6 Mandatory Dimensions

Every Implementation Plan MUST address each dimension:

### 1. Source & Ingestion Dimension
- Where does the data/event originate?
- Form inputs, REST API payload, GraphQL, Webhook, WebSocket, CLI flag, file upload.
- **Verification Rule:** Validate MIME type, payload size bounds, data schemas (Zod / Pydantic / TypeScript types), sanitize inputs.

### 2. Runtime & Reactive State Dimension
- How is the state held in memory during execution?
- React/Vue reactive state, Redux/Zustand store, server-side process memory, thread pools.
- **Verification Rule:** Does the UI update reactively without requiring an explicit browser reload? Does state clean up on unmount (prevent memory leaks)?

### 3. Storage & Persistence Dimension
- Where does data persist permanently?
- PostgreSQL, MySQL, Redis, SQLite, disk files, browser LocalStorage/IndexedDB.
- **Verification Rule:** Perform a "Cold Restart Test": Hard-refresh the page (Ctrl+F5) or restart the backend process. Does the state remain intact, or does it silently fallback to defaults?

### 4. Downstream & Consumer Pipeline Dimension
- What secondary systems rely on this data?
- PDF generation engines (Puppeteer / wkhtmltopdf / WeasyPrint).
- Background workers, queue jobs (BullMQ / Celery), analytics pipelines, third-party webhooks.
- Satellite apps (e.g., SSO consumers like Raidpass relying on Maskii Studio).
- **Verification Rule:** If a custom font or user setting is saved, confirm that the exported PDF or worker output embeds that exact setting rather than defaulting.

### 5. Security & Isolation Dimension
- Who is authorized to interact with or observe this feature?
- Role-Based Access Control (RBAC), multi-tenancy boundaries, token verification.
- **Channel Isolation:** Never broadcast private alerts globally (e.g., avoid `io.emit()` for admin notifications; use isolated rooms `io.to('admin').emit()`).
- **Server Enforcement:** Never rely on UI hiding (`v-if="isAdmin"`). Always guard the backend route/middleware.

### 6. Failure Modes & Edge-Cases Dimension
- What happens when things go wrong?
- Network disconnects, database timeouts, corrupted files, token expiration, race conditions.
- **Verification Rule:** Provide graceful user feedback, automated retry with backoff, offline indicators, and transaction rollbacks.
