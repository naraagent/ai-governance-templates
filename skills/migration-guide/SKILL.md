---
name: migration-guide
description: |
  Use when migrating databases, deprecating APIs, refactoring across modules,
  upgrading major dependencies, or making breaking changes. Activate when the
  user says "migrate", "deprecate", "upgrade", "breaking change", "schema change",
  "move to new version", or is working with Alembic, Prisma migrate, Flyway,
  or Terraform state operations.
license: MIT
compatibility: Kiro, Claude Code, Copilot, Codex, Gemini CLI, Windsurf
metadata:
  author: nara-governance
  category: migration
  trigger-type: conditional
  stack-match: terraform,alembic,prisma,flyway,typeorm,sequelize
---

# Migration Guide

Systematic approach to database migrations, API deprecations, and breaking changes.

## Process

### Step 1: Impact Assessment
- What breaks if this migration fails?
- What services depend on the old schema/API/behavior?
- Can we do this without downtime? (expand-contract pattern)
- Is there a rollback path?

### Step 2: Choose Migration Strategy

| Strategy | When to Use | Risk |
|----------|------------|------|
| **Expand-Contract** | Zero-downtime DB changes | Low |
| **Blue-Green** | Service replacement | Medium |
| **Feature Flag** | Gradual behavior change | Low |
| **Big Bang** | Breaking change, no compatibility needed | High |

**Expand-Contract (preferred for DB):**
```
Phase 1 (Expand): Add new column/table, keep old working
Phase 2 (Migrate): Backfill data, dual-write
Phase 3 (Contract): Remove old column/table after verification
```

### Step 3: Write the Migration
- Migration MUST be reversible (up + down)
- Test migration on a copy of production data
- Separate schema changes from data migrations
- Never mix business logic with migration code
- Keep migrations small (one concern per migration)

### Step 4: Deprecation Protocol (for APIs)
```
Sprint N:     Add deprecation header + log warning
Sprint N+1:   Document alternative, notify consumers
Sprint N+2:   Return 410 Gone (or remove)
```

Deprecation response header:
```
Deprecation: true
Sunset: Sat, 01 Mar 2026 00:00:00 GMT
Link: <https://docs.example.com/migration>; rel="successor-version"
```

### Step 5: Validate Before and After
- [ ] Run migration on staging with production-like data
- [ ] Verify all dependent services still work
- [ ] Check query performance (EXPLAIN ANALYZE)
- [ ] Verify rollback works: `alembic downgrade -1` / `prisma migrate reset`
- [ ] Run full test suite after migration

### Step 6: Communicate
- [ ] Changelog entry added
- [ ] Breaking change documented in PR description
- [ ] Dependent teams notified (Slack, email, ticket)
- [ ] Runbook updated if operational procedures changed

## Anti-Rationalization Table

| Excuse | Rebuttal |
|--------|----------|
| "We'll just run it in a maintenance window" | Zero-downtime is possible with expand-contract. Plan for it. |
| "Nobody uses the old API anymore" | Verify with logs/metrics. "Nobody" often means "someone you forgot." |
| "The migration is simple, no need for staging test" | Simple migrations corrupt data in production. Always test. |
| "We can fix data manually if something goes wrong" | Manual fixes at scale = hours of downtime. Automate rollback. |
| "Breaking changes are fine, it's internal" | Internal APIs become external. Deprecate properly. |

## Red Flags
- Migration has no `down` / rollback function
- Data migration mixed with schema migration in same file
- No staging test before production
- Removing a column/table without verifying zero usage
- Migration takes > 30 seconds on production data volume
- No communication to dependent teams

## Verification
- [ ] Migration runs successfully on staging
- [ ] Rollback tested and works
- [ ] Dependent services verified
- [ ] Performance acceptable (query time)
- [ ] Communication sent to affected teams
- [ ] Monitoring in place for migration-related errors
