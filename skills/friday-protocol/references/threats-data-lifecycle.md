# 💾 Data Lifecycle, Isolation, and Anti-Wipe Threat Catalog

> **Standard:** FRIDAY-PROTOCOL v2.2.0 (Cognitive DevSecOps)  
> **Target Surface:** Multi-Tenant Databases, Persistent Storage, Migrations, Seeders, Caches, Object Storage, Backup/Restore Pipelines, and Export Jobs.  
> **Core Invariant:** *Data isolation must be enforced by deterministic query predicates; lifecycle mutations must guarantee Zero Data Loss.*

---

## 🏛️ Core Hunting Discipline

1. **A Tenant Field on a Record is NOT Isolation:** Merely having `tenant_id` or `user_id` on a database column does not prevent data leaks. The auditor must verify that every query (raw, ORM, join, aggregate, subquery) deterministically binds to the authenticated tenant.
2. **Trace Derived Copies:** Primary data that is properly isolated can silently leak when copied into search indexes (Elasticsearch, Meilisearch), Redis caches, export bundles, backups, analytics logs, or message queues where tenant filtering is omitted.
3. **Zero-Wipe Invariant:** Migrations, rollbacks, and schema evolution must never drop or truncate tables on active databases. Migrations must be non-destructive and backward-compatible.
4. **Foreign Key Cascade Prudence:** Audit all `ON DELETE` rules. Relational models holding critical telemetry, audit trails, or threat intelligence must use `ON DELETE SET NULL` or `RESTRICT` rather than cascading deletes.

---

## 🔍 Attack Classes & Hunting Vectors

### 1. Multi-Tenant & Object Isolation Attacks
- **Missing Tenant Enforcement on Lookups:**
  - *Vector:* Endpoints query resources by ID alone (`find(id)` or `WHERE id = ?`) without validating that the record belongs to the requesting tenant (`WHERE id = ? AND tenant_id = ?`).
  - *Audit Check:* Look for un-scoped queries, bypasses of global ORM scopes, raw queries in administrative routes, and nested relations.
- **Cache Key & Namespace Collisions:**
  - *Vector:* Redis cache keys, S3 object keys, or temporary files use global IDs (e.g. `cache:user:123`) without prefixing tenant identity (`cache:tenant_{tenant_id}:user:123`).
  - *Audit Check:* Ensure all cache keys and cloud storage paths explicitly incorporate tenant/environment prefixes.
- **Policy & Query Disagreement:**
  - *Vector:* The application implements row-level security or authorization middleware, but background jobs, report exports, or batch processing scripts execute using un-scoped database connections.
  - *Audit Check:* Verify that background workers and scheduled tasks carry and enforce tenant context throughout their lifecycle.

### 2. Migration, Seeder, and Anti-Wipe Vulnerabilities
- **Destructive Command Execution in Development/Staging:**
  - *Vector:* Test suites, CI/CD scripts, or deployment routines execute `migrate:fresh`, `db:wipe`, or `DROP DATABASE` on active databases instead of ephemeral test databases.
  - *Audit Check:* Audit package scripts (`package.json`, Makefile, compose files) and test harness bootstrap files (`phpunit.xml`, `pytest.ini`, test setup hooks).
- **Migration Default Confusion & Incompatible Rollbacks:**
  - *Vector:* A migration alters a column or adds a `NOT NULL` constraint without a safe default value, causing existing records to fail validation or corrupting data during partial rollouts.
  - *Audit Check:* Enforce additive migrations (`ADD COLUMN` with nullable or safe defaults) and multi-step backfills before tightening constraints.
- **Foreign Key Cascading Mass-Deletion:**
  - *Vector:* A table with `ON DELETE CASCADE` causes thousands of security events, audit logs, or relational records to be deleted permanently when an agent or user is reset.
  - *Audit Check:* Verify constraints on audit, security, and telemetric tables specify `ON DELETE SET NULL` or `RESTRICT`.

### 3. Export, Backup, and Deletion Lifecycle
- **Export & Backup Scope Expansion:**
  - *Vector:* A CSV, Excel, or PDF export feature queries records using a high-privilege service client without tenant filtering, allowing one user to download cross-tenant data.
  - *Audit Check:* Trace the full export lifecycle: ensure authorization filters apply both during record querying and at the file download endpoint.
- **Soft-Delete & Tombstone Bypass:**
  - *Vector:* Soft-deleted records (`deleted_at IS NOT NULL`) are inadvertently included in aggregate statistics, search indexes, or nested relationship lookups.
  - *Audit Check:* Verify that all queries, search index builders, and export functions respect soft-delete scopes.
- **Restore & Import Authority Overreach:**
  - *Vector:* An archive import or backup restore feature blindly trusts records inside the uploaded file, allowing an attacker to assign data to other tenants or elevate privileges.
  - *Audit Check:* Treat imported archives as untrusted input; re-bind all imported records to the authenticated tenant.
