# Tasks: [Feature Name]

> Design: #[[file:design.md]]
> Requirements: #[[file:requirements.md]]

## Implementation Tasks

### Phase 1: Foundation
- [ ] Task 1.1: [Create data models / DB migration]
  - Files: `src/models/...`
  - Acceptance: Migration runs cleanly, tests pass
- [ ] Task 1.2: [Create service layer]
  - Files: `src/services/...`
  - Acceptance: Unit tests pass with 80%+ coverage
- [ ] Task 1.3: [Create repository layer]
  - Files: `src/repositories/...`
  - Acceptance: Integration tests pass

### Phase 2: API
- [ ] Task 2.1: [Create API endpoints]
  - Files: `src/controllers/...`
  - Acceptance: All endpoints respond correctly, validation works
- [ ] Task 2.2: [Add authentication/authorization]
  - Files: `src/middlewares/...`
  - Acceptance: Unauthorized requests blocked
- [ ] Task 2.3: [Add input validation]
  - Files: `src/validators/...`
  - Acceptance: Invalid input returns 422 with error details

### Phase 3: Integration
- [ ] Task 3.1: [Integrate with external service X]
  - Files: `src/clients/...`
  - Acceptance: Circuit breaker triggers on failure
- [ ] Task 3.2: [Add observability]
  - Files: `src/middleware/logging.ts`, `src/metrics/...`
  - Acceptance: Structured logs, traces propagated

### Phase 4: Testing & Deploy
- [ ] Task 4.1: [E2E tests]
  - Files: `tests/e2e/...`
  - Acceptance: Happy path + error scenarios covered
- [ ] Task 4.2: [Performance testing]
  - Acceptance: Meets p95 latency requirement
- [ ] Task 4.3: [Deploy to staging]
  - Acceptance: Health check passes, smoke tests green
- [ ] Task 4.4: [Deploy to production]
  - Acceptance: Canary metrics normal, no error spike

## Definition of Done

- [ ] All tasks completed
- [ ] Code review approved
- [ ] Tests pass (unit + integration + e2e)
- [ ] Security scan clean
- [ ] Documentation updated
- [ ] Deployed to production
- [ ] Monitoring/alerts configured
