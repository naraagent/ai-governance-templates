# AGENTS.md — ECS Hub Microservice (Capsula Pattern)

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Profile: service-ecs-hub | Org: FEMSA Digital
> Runtime: Node.js 20 LTS on AWS ECS Fargate (Capsula/Hub)

## Identity

- Organization: FEMSA Digital (workspace: digitaldifarma)
- Service type: Node.js/TypeScript microservice — Capsula Hub pattern
- Runtime: ECS Fargate (Docker containers)
- Deploy: Helm charts (Capsula pattern) orchestrated via Jenkins multibranch
- Registry: AWS ECR
- Secrets: Environment variables injected from AWS Secrets Manager / Vault
- Communication: HTTP REST inter-service + SQS async messaging
- Repos: ~20 repos (service-ecs-hub-backend, service-ecs-hub-history, service-ecs-hub-engine, etc.)

## Build

```bash
npm ci                    # Install (CI mode, uses lockfile)
npm run build            # TypeScript compilation (tsc)
npm run lint             # ESLint + Prettier check
npm test                 # Jest/Vitest unit tests
npm run test:integration # Integration tests (docker-compose up required)
docker build -t ${SERVICE_NAME}:${GIT_SHA} .   # Multi-stage Docker build
helm lint ./helm/        # Validate Helm chart
```

## Project Structure

```
src/
├── controllers/         # Express/NestJS route handlers (thin)
├── services/            # Business logic layer
├── repositories/        # Data access (TypeORM/Prisma)
├── models/              # TypeScript interfaces & DTOs
├── middlewares/         # HTTP middlewares (auth, logging, error)
├── events/              # SQS message handlers & publishers
├── clients/             # HTTP clients for inter-service calls
├── config/              # Environment-based config (12-factor)
├── common/              # Shared utilities from common-resources
└── tests/               # Mirror structure for tests
helm/
├── Chart.yaml           # Capsula parent chart
├── values.yaml          # Default values
├── values-dev.yaml      # Development overrides
├── values-staging.yaml  # Staging overrides
├── values-prod.yaml     # Production overrides
└── templates/           # K8s manifests (deployment, service, ingress, hpa)
Dockerfile               # Multi-stage (build → production)
docker-compose.yml       # Local development environment
Jenkinsfile              # CI/CD pipeline definition
```

## Conventions

### Language
- TypeScript obligatorio (strict: true)
- No `any` — explicit types or `unknown` + type guards
- `const`/`let` only (no `var`)
- Async/await over callbacks and `.then()` chains
- Structured logging with pino — NEVER `console.log`

### Inter-Service Communication
- HTTP clients use shared `common-resources` base client with retry + circuit breaker
- SQS for async operations (order events, notifications, state changes)
- Contract-first APIs: OpenAPI spec in `/docs/api.yaml` before implementation
- Service discovery via environment variables (SERVICE_HUB_HISTORY_URL, etc.)
- Correlation ID propagated via `X-Correlation-Id` header across all calls

### Shared Libraries (common-resources)
- `@femsa/common-resources` — shared DTOs, error classes, middleware, logging
- Import from common-resources for: error types, pagination, response wrappers
- Do NOT duplicate shared logic — extend common-resources if needed
- Version-locked across all hub services

### Dependencies
- Pinned to exact versions (no `^`, no `~`)
- Approved: Express/NestJS, TypeORM/Prisma, Zod, Pino, Jest/Vitest, Axios
- NOT approved: Sequelize, Mocha, request (deprecated), Koa

### Error Handling
- Custom error classes extending `BaseServiceError` from common-resources
- All errors include: statusCode, errorCode, message, correlationId
- Log error with full context before re-throwing
- Never swallow errors silently — no empty catch blocks

### Branching & Git
- Format: `type/TICKET-descripcion-corta`
- Types: `feature/`, `fix/`, `hotfix/`, `release/`, `chore/`
- Integration: `develop` | Production: `main`
- Commits: `type(scope): descripción` (Conventional Commits, max 72 chars)

### Pull Requests
- Title: `TICKET-123 Clear description`
- Max: 400 lines (critical > 800)
- Target: `develop`
- Required: 2 approvals, green CI

### Testing
- Unit tests for all business logic (services layer)
- Integration tests for inter-service contracts
- Coverage target: 70%+ on new code
- Framework: Jest or Vitest
- External services mocked in unit tests
- Naming: `should <behavior> when <condition>`

## Deployment

- Container: Multi-stage Dockerfile (node:20-alpine → distroless or alpine production)
- Non-root user in production image (USER node)
- Orchestration: Helm chart (Capsula pattern — parent chart with subcharts per service)
- CI: Jenkins multibranch pipeline (checkout → install → lint → test → build → push → deploy)
- Environments: develop → staging → production (promotion via Jenkins approval gate)
- Health: `/health` endpoint required (readiness + liveness probes)
- Config: 12-factor — all config via environment variables
- Scaling: HPA configured (CPU 70% target, min 2, max 10 replicas)
- Resources: CPU/memory limits always set in values-{env}.yaml

## Constraints

- Do NOT modify `Dockerfile` without DevOps review
- Do NOT add dependencies without explicit justification and security review
- Do NOT use `any` type
- Do NOT disable TypeScript strict checks
- Do NOT commit `.env` files or secrets
- Do NOT access other service's database directly — use HTTP/SQS
- Do NOT introduce ORM migrations without DBA review
- Do NOT modify Helm chart structure without Platform team approval
- Do NOT use synchronous I/O in request handlers

## Agent Autonomy

- Level: supervised
- Allowed: read files, lint, test, suggest code changes, analyze logs
- Blocked: deploy, modify Helm/Jenkins, access secrets directly, modify docker-compose.yml
- Approval required: new dependencies, DB schema changes, API contract changes, inter-service contract modifications
- Escalate to: Platform team (Helm/infra), DBA (migrations), Security (auth changes)
