# AGENTS.md — EKS Node.js Microservice (Full Template)

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Compatible: Codex, Copilot, Cursor, Kiro, OpenClaw, Devin, Amp
> Profile: eks-nodejs | Org: FEMSA Digital

## Identity

- Organization: FEMSA Digital (Salud / Proximidad)
- Service: {{SERVICE_NAME}}
- Runtime: Node.js 20 LTS on AWS EKS (K8s 1.34)
- Language: TypeScript (strict mode)
- Deploy: Jenkins → ECR → Helm (Capsula) → EKS
- Secrets: HashiCorp Vault
- Monitoring: Datadog / CloudWatch

## Build

```bash
npm ci
npm run build
npm run lint
npm test
```

## Test

```bash
npm test                    # Unit tests (Jest/Vitest)
npm run test:integration    # Integration tests
npm run test:coverage       # Coverage report (target: 70%+)
```

## Lint

```bash
npm run lint                # ESLint + Prettier
npm run type-check          # TypeScript strict check
```

## Structure

```
src/
├── controllers/     # Route handlers
├── services/        # Business logic (testable, no I/O)
├── repositories/    # Data access (DB, external APIs)
├── models/          # TypeScript interfaces & types
├── middlewares/     # Express/Fastify middleware
├── utils/           # Pure utility functions
├── config/          # Environment-based configuration
└── tests/           # Mirror of src/ structure
```

## Conventions

### TypeScript
- `strict: true` mandatory
- No `any` — use explicit types or `unknown` + type guards
- `const`/`let` only — no `var`
- Async/await — no callbacks, no raw `.then()`
- Export explicit types for all public APIs

### Dependencies
- Pinned to exact versions (no `^`, no `~`)
- Approved: Express/Fastify, Prisma/TypeORM, Zod/Joi, Pino/Winston, Jest/Vitest
- Prohibited: Sequelize, Mocha, request, Koa, Hapi, console.log

### Error Handling
- Custom error classes extending base `AppError`
- Always log with context: `{ error, requestId, userId }`
- Never empty catches — minimum: log + rethrow
- Structured errors: `{ code, message, details, requestId }`

### Security (NON-NEGOTIABLE)
- NEVER hardcode secrets — use env vars sourced from Vault
- HTTPS only for all external communication
- Zod/Joi validation on EVERY endpoint input
- Parameterized DB queries only (no string interpolation)
- No sensitive data in logs (mask PII, tokens, passwords)
- Pin ALL dependencies to exact versions

### Git
- Branch: `type/TICKET-description` (e.g., `feature/OSS-700-refill-status`)
- Commit: `type(scope): description` (Conventional Commits)
- PR: `TICKET-123 Description of change`
- Target: `develop` (never direct to `main`)

### Testing
- Every service/controller requires unit tests
- Test naming: `should [behavior] when [condition]`
- External services: always mocked
- Coverage: 70%+ for new code

## Deployment

- Dockerfile: multi-stage, node:20-alpine base
- Health: `GET /health` (readiness + liveness probes)
- Config: environment variables (12-factor app)
- Scaling: HPA based on CPU/memory
- Secrets: mounted from Vault via sidecar/init container

## Constraints

- Do NOT modify Dockerfile without DevOps approval
- Do NOT add dependencies without justification in PR
- Do NOT use `any` type
- Do NOT commit `.env` or secret files
- Do NOT introduce DB migrations without DBA review
- Do NOT disable linting rules without comment justification
- Do NOT use `console.log` — use structured logger

## Agent Governance

### Autonomy Level
- **Mode**: supervised (all changes require human review)
- **Allowed**: read all files, run lint/test, suggest changes, create branches
- **Blocked**: deploy, modify CI/CD, access Vault/secrets, push to main/develop
- **Approval Required**: new dependencies, DB schema changes, API contract changes, security config

### MCP Integration
- Protocol: MCP 2025-06-18 (JSON-RPC 2.0 + Streamable HTTP)
- Tool annotations: readOnlyHint, destructiveHint, idempotentHint required
- RBAC: tools have `allowed_roles` field

### A2A Protocol
- Agent Card: `/.well-known/agent.json` if this service exposes agent capabilities
- Task lifecycle: submitted → working → completed | failed
- Auth: Bearer JWT between agents

### Observability
- Structured logging: JSON format with trace context
- Trace ID: propagated via headers on all inter-service calls
- Circuit breaker state: reported in health endpoint
