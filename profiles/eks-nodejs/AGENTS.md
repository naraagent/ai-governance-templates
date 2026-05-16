# AGENTS.md — EKS Node.js Microservice

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Profile: eks-nodejs | Org: FEMSA Digital
> Runtime: Node.js 20 LTS on AWS EKS (K8s 1.34)

## Identity

- Organization: FEMSA Digital
- Service type: Node.js/TypeScript microservice
- Runtime: EKS (Kubernetes 1.34)
- Deploy: Helm charts (Capsula pattern) via Jenkins
- Registry: AWS ECR
- Secrets: HashiCorp Vault

## Build

```bash
npm ci                    # Install (CI mode, uses lockfile)
npm run build            # TypeScript compilation
npm run lint             # ESLint + Prettier check
npm test                 # Jest/Vitest tests
npm run test:coverage    # With coverage report
```

## Project Structure

```
src/
├── controllers/     # Route handlers (Express/Fastify)
├── services/        # Business logic
├── repositories/    # Data access layer
├── models/          # Types/interfaces
├── middlewares/     # HTTP middlewares
├── utils/           # Pure helpers
├── config/          # Configuration (env-based)
└── tests/           # Tests (mirror of src/)
```

## Conventions

### Language
- TypeScript obligatorio (no JavaScript plano)
- `strict: true` en tsconfig.json
- No `any` — usar tipos explícitos o `unknown` con type guards
- `const`/`let` only (no `var`)
- Async/await over callbacks and `.then()` chains
- Structured logger (pino/winston) — NEVER `console.log`

### Dependencies
- Pinned to exact versions (no `^`, no `~`)
- Approved: Express/Fastify, Prisma/TypeORM, Zod/Joi, Pino/Winston, Jest/Vitest, Axios
- NOT approved: Koa, Hapi, Sequelize, Mocha, request (deprecated)

### Error Handling
- Explicit error handling — no empty catches
- Always log error with context before rethrowing
- Use custom error classes with HTTP status codes
- Never swallow errors silently

### Branching
- Format: `type/TICKET-descripcion-corta`
- Types: `feature/`, `fix/`, `bugfix/`, `hotfix/`, `release/`, `chore/`
- Integration: `develop` | Production: `main`

### Commits
- Format: `type(scope): descripción`
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`
- Max 72 chars, lowercase, imperative

### Pull Requests
- Title: `TICKET-123 Clear description`
- Max: 400 lines (critical > 800)
- Target: `develop`

### Security
- NEVER hardcode secrets — use env vars + Vault
- HTTPS only for external calls
- Input validation with Zod/Joi on every endpoint
- Parameterized queries only
- Dependencies pinned, no `latest`
- No SSL verification disable

### Testing
- All business logic requires unit tests
- Coverage target: 70%+ new code
- Framework: Jest or Vitest
- External services mocked (never real in unit tests)
- Naming: `should <behavior> when <condition>`

## Deployment

- Container: Multi-stage Dockerfile (node:20-alpine)
- Orchestration: Helm chart (Capsula pattern)
- CI: Jenkins pipeline
- Health: `/health` endpoint required (readiness + liveness)
- Env: config via environment variables (12-factor)

## Constraints

- Do NOT modify `Dockerfile` without DevOps review
- Do NOT add dependencies without explicit justification
- Do NOT use `any` type
- Do NOT disable TypeScript strict checks
- Do NOT commit `.env` files
- Do NOT introduce ORM migrations without DBA review

## Agent Autonomy

- Level: supervised
- Allowed: read, lint, test, suggest code changes
- Blocked: deploy, modify Helm/Jenkins, access Vault directly
- Approval: new dependencies, DB schema changes, API contract changes
