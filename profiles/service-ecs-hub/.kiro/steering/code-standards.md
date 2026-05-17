---
inclusion: auto
---

# Code Standards — ECS Hub Service (Capsula Pattern)

## Language: TypeScript (Strict)

- Node.js 20 LTS, TypeScript strict mode
- No `any` — explicit types or `unknown` + type guards
- `const`/`let` only, async/await only
- Structured logger (pino) — NEVER `console.log`
- ESLint + Prettier enforced

## Architecture (Capsula Hub)

- Controllers: thin, delegate to services immediately
- Services: business logic, testable, no direct I/O
- Repositories: data access layer (TypeORM/Prisma)
- Events: SQS handlers for async operations
- Clients: HTTP clients for inter-service communication
- Config: environment-based (12-factor)

## Inter-Service Communication

- HTTP REST for synchronous request/response
- SQS for async events (order.created, inventory.updated, etc.)
- Contract-first: define OpenAPI spec before implementing
- Always propagate `X-Correlation-Id` in all outbound calls
- Use common-resources base HTTP client (retry, circuit breaker, timeout)
- Service URLs via environment variables — NEVER hardcode endpoints

## Shared Library: @femsa/common-resources

- Import shared DTOs, error classes, middleware from common-resources
- Standard error format: `{ statusCode, errorCode, message, correlationId }`
- Standard pagination: `{ data, meta: { page, limit, total, totalPages } }`
- Standard response wrapper: `{ success, data, error, meta }`
- If functionality is needed across >2 hub services → extract to common-resources

## NestJS / Express Patterns

### NestJS (preferred for new services)
- Module-based organization
- DTOs with class-validator decorators
- Guards for authentication/authorization
- Interceptors for logging and transformation
- Exception filters for error normalization

### Express (legacy services)
- Router → Controller → Service → Repository
- Middleware chain: cors → helmet → requestId → auth → routes → errorHandler
- No business logic in route handlers

## Logging (Pino)

```typescript
// Always use structured logging
logger.info({ orderId, action: 'order.created', duration }, 'Order processed');
logger.error({ err, orderId, correlationId }, 'Failed to process order');

// NEVER
console.log('Processing order...');
```

## Security (NON-NEGOTIABLE)

- No hardcoded secrets — env vars from Secrets Manager
- HTTPS only for external calls
- Zod validation on every endpoint input
- Parameterized DB queries only
- Pin all dependencies to exact versions
- No cross-service direct DB access

## Testing

- Jest/Vitest, coverage 70%+
- Mock external services and SQS
- Integration tests validate inter-service contracts
- Name: `should [behavior] when [condition]`

## Git

- Branch: `type/TICKET-description`
- Commit: `type(scope): description` (Conventional Commits)
- PR: `TICKET-123 Description`, max 400 lines
