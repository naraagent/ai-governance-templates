# Skill: Code Review — EKS Node.js

## Trigger
When reviewing pull requests or code changes in Node.js/TypeScript microservices.

## Checks

### Architecture
- Controllers are thin (no business logic)
- Services contain business logic, no direct I/O
- Repositories handle data access
- No circular dependencies between layers

### FEMSA Conventions
- Service naming follows `{service}-{country}` pattern
- Environment variables documented in README
- Health endpoint `/health` exists and returns version
- Structured logging (pino/winston), no console.log

### Security
- No hardcoded secrets or credentials
- Input validation with Zod/Joi on all endpoints
- Parameterized queries only
- Dependencies pinned to exact versions
- No `any` types in TypeScript

### Testing
- New business logic has unit tests
- Coverage does not decrease
- Tests follow `should <behavior> when <condition>` naming

### Deployment
- Dockerfile uses multi-stage build with node:20-alpine
- No modifications to Helm charts without DevOps approval
- Jenkins pipeline stages are not modified without CI team review
