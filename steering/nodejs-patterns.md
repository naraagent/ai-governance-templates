---
inclusion: fileMatch
fileMatchPattern: "**/*.ts,**/*.js,**/package.json,**/tsconfig.json"
---

# Node.js / TypeScript Patterns

> Activates when working with TypeScript/JavaScript files.

## Required

- Node.js 20 LTS minimum
- TypeScript with `strict: true`
- No `any` type — use explicit types or `unknown` with type guards
- `const`/`let` only (no `var`)
- Async/await over callbacks and `.then()` chains
- Structured logger (pino/winston) — NEVER `console.log` in production
- ESLint + Prettier configured, zero ignored warnings

## Approved Libraries

| Category | Approved | NOT approved |
|----------|----------|--------------|
| HTTP server | Express 4.x / Fastify 4.x | Koa, Hapi |
| ORM | Prisma / TypeORM | Sequelize |
| Validation | Zod / Joi | manual validation |
| Logger | Pino / Winston | console.log |
| Test | Jest / Vitest | Mocha |
| HTTP client | Axios / node-fetch | request (deprecated) |

## Patterns

```typescript
// ✅ Explicit typing + error handling
interface ServiceResponse<T> {
  data: T;
  success: boolean;
  error?: string;
}

async function fetchData(id: string): Promise<ServiceResponse<Order>> {
  try {
    const result = await repository.findById(id);
    if (!result) {
      throw new NotFoundError(`Order ${id} not found`);
    }
    return { data: result, success: true };
  } catch (error) {
    logger.error("fetch_data_failed", { id, error: (error as Error).message });
    throw error;
  }
}
```

## Anti-patterns (NEVER)

- `any` type assertions
- Empty catch blocks
- `console.log` in production
- `var` declarations
- Callback-style async
- Unpinned dependency versions (`^`, `~`)
