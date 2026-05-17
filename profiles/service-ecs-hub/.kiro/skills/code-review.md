---
name: "code-review-ecs-hub"
version: "1.0.0"
description: "Code review for ECS Hub microservices — validates Capsula pattern and microservice boundaries"
triggers:
  - "review"
  - "code review"
  - "revisar código"
  - "PR review"
applies_to:
  languages: ["typescript"]
  categories: ["code-review", "microservice", "capsula"]
---

# Code Review — ECS Hub Service (Capsula Pattern)

You are performing a code review for an ECS Hub microservice following the Capsula pattern and FEMSA standards.

## Critical Checks (BLOCK if violated)

### 1. Microservice Boundaries
- [ ] No direct database access to other service's DB
- [ ] Inter-service communication ONLY via HTTP client or SQS
- [ ] No shared database connections between services
- [ ] Service-to-service calls use correlation ID propagation
- [ ] No importing code from other service repos (use common-resources)

### 2. Contract-First APIs
- [ ] API changes have corresponding OpenAPI spec update
- [ ] Breaking changes flagged and versioned
- [ ] Request/Response DTOs use Zod validation
- [ ] Error responses follow standard format: `{ statusCode, errorCode, message, correlationId }`

### 3. Security
- [ ] No hardcoded secrets, tokens, or endpoints
- [ ] All environment variables documented in README
- [ ] Input validation on every endpoint
- [ ] No SQL injection (parameterized queries only)
- [ ] No sensitive data logged

### 4. Architecture Layers
- [ ] Controllers are thin (< 20 lines, delegate immediately)
- [ ] Business logic lives in services layer ONLY
- [ ] Data access in repositories ONLY
- [ ] No business logic in event handlers (delegate to service)
- [ ] No circular dependencies between modules

### 5. Inter-Service Communication
- [ ] HTTP clients use common-resources base client (retry + circuit breaker)
- [ ] SQS messages have schema validation
- [ ] Timeout configured for all outbound HTTP calls
- [ ] Fallback/degradation strategy for downstream failures
- [ ] Idempotency keys for write operations via SQS

### 6. Common Resources Usage
- [ ] Shared DTOs imported from @femsa/common-resources
- [ ] Error classes extend BaseServiceError
- [ ] Pagination follows standard format
- [ ] No duplicated utilities that exist in common-resources

### 7. Testing
- [ ] New business logic has unit tests
- [ ] Inter-service contracts have integration tests
- [ ] SQS handlers tested with mock messages
- [ ] Coverage >= 70% on changed files

## Output Format

```markdown
## Code Review — ECS Hub Service

**Risk Level**: LOW | MEDIUM | HIGH | CRITICAL
**Recommendation**: APPROVE | REQUEST_CHANGES | BLOCK
**Microservice Boundary Violations**: 0/N

### Findings

| # | Severity | File | Line | Finding | Suggestion |
|---|----------|------|------|---------|------------|

### Microservice Health
- Boundary integrity: ✅/❌
- Contract compliance: ✅/❌
- Common-resources usage: ✅/❌
```
