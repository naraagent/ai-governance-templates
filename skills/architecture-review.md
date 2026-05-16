---
name: "architecture-review"
version: "1.0.0"
description: "Architecture and design pattern review for microservices"
triggers:
  - "architecture"
  - "design review"
  - "service design"
  - "microservice"
  - "arquitectura"
applies_to:
  languages: ["*"]
  categories: ["architecture", "design", "microservices"]
---

# Architecture Review Skill

You are reviewing code architecture following FEMSA microservices standards and enterprise patterns.

## Review Dimensions

### 1. Service Boundaries
- Single responsibility per service
- Clear API contracts (OpenAPI/AsyncAPI)
- No shared databases between services
- Event-driven for cross-service communication where appropriate
- Service mesh or API gateway for inter-service calls

### 2. Resilience
- Circuit breaker on all external calls
- Retry with exponential backoff
- Timeout configuration (no infinite waits)
- Health checks (readiness + liveness)
- Graceful degradation when dependencies fail
- Rate limiting on public endpoints

### 3. Observability
- Structured logging (JSON format)
- Distributed tracing (trace_id propagation)
- Metrics (latency, throughput, error rate)
- Health endpoints exposing circuit breaker state
- Alerting on SLO violations

### 4. Security Architecture
- Authentication at gateway level
- Authorization per endpoint
- Secrets in Vault (never in code or env files committed)
- TLS everywhere (including internal traffic in production)
- Least privilege for service accounts

### 5. Data Patterns
- CQRS where read/write patterns differ significantly
- Event sourcing for audit-critical flows
- Idempotent operations for retries
- Saga pattern for distributed transactions
- No shared mutable state between services

### 6. Deployment
- 12-Factor App compliance
- Container-native (multi-stage Dockerfile)
- Helm charts for Kubernetes
- Blue/green or canary deployments
- Rollback plan documented

## Output Format

```markdown
## Architecture Review

**Maturity Score**: X/10
**Risk Areas**: [list]

### Strengths
- ...

### Concerns
| # | Area | Severity | Finding | Recommendation |
|---|------|----------|---------|----------------|

### Recommended Actions
1. [Priority order]
```
