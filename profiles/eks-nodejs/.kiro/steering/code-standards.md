---
inclusion: auto
---

# Code Standards — EKS Node.js Service

## Language: TypeScript (Strict)

- Node.js 20 LTS, TypeScript strict mode
- No `any` — explicit types or `unknown` + type guards
- `const`/`let` only, async/await only
- Structured logger (pino/winston) — NEVER `console.log`

## Architecture

- Controllers: thin, delegate to services
- Services: business logic, testable, no I/O
- Repositories: data access layer
- Config: environment-based (12-factor)

## Security (NON-NEGOTIABLE)

- No hardcoded secrets — env vars from Vault
- HTTPS only for external calls
- Zod/Joi validation on every endpoint
- Parameterized DB queries only
- Pin all dependencies to exact versions

## Testing

- Jest/Vitest, coverage 70%+
- Mock external services
- Name: `should [behavior] when [condition]`

## Git

- Branch: `type/TICKET-description`
- Commit: `type(scope): description` (Conventional Commits)
- PR: `TICKET-123 Description`, max 400 lines
