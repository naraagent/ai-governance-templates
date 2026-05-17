---
inclusion: auto
---

# Code Standards — Lambda Node.js

## Language: TypeScript (Strict)

- Node.js 20.x Lambda runtime, TypeScript strict mode
- No `any` — explicit types or `unknown` + type guards
- `const`/`let` only, async/await only
- Lambda Powertools for logging/tracing — NEVER `console.log`

## Handler Pattern

Every Lambda handler follows the thin-handler pattern:

```typescript
// Handler: parse → validate → delegate → format response
export const handler = middy(async (event: SQSEvent) => {
  const messages = event.Records.map(parseMessage);
  await batchProcessor.process(messages);
  return { batchItemFailures: [] };
})
  .use(injectLambdaContext(logger))
  .use(captureLambdaHandler(tracer));
```

### Rules
- Handler files: MAX 30 lines (parse + delegate + return)
- Business logic: ALWAYS in `services/` directory
- Data access: ALWAYS in `repositories/` directory
- NO raw event parsing in service layer (handler normalizes input)

## Cold Start Optimization

### Lazy Imports
```typescript
// ✅ Lazy import — only loaded when needed
let dynamoClient: DynamoDBClient;
function getDynamoClient() {
  if (!dynamoClient) {
    dynamoClient = new DynamoDBClient({});
  }
  return dynamoClient;
}

// ❌ Top-level import of heavy module
import { createComplexThing } from './heavy-module';
```

### Connection Reuse
- Initialize clients OUTSIDE handler (reuse across invocations)
- Set `AWS_NODEJS_CONNECTION_REUSE_ENABLED=1`
- HTTP keep-alive enabled by default

### Bundle Size Control
- Target: < 5MB uncompressed (warn at 3MB)
- AWS SDK v3 modular: `@aws-sdk/client-dynamodb` (never full SDK)
- Tree-shaking with esbuild
- No unnecessary dev dependencies in bundle
- Heavy shared deps → Lambda Layer

## Environment & Configuration

- All config via `process.env` (injected by serverless.yml / template.yaml)
- Secrets: SSM Parameter Store (cached with middy SSM middleware)
- NEVER hardcode ARNs, account IDs, or region
- Stage-aware: `process.env.STAGE` determines behavior

## Logging (Lambda Powertools)

```typescript
import { Logger } from '@aws-lambda-powertools/logger';
const logger = new Logger({ serviceName: 'order-processor' });

logger.info('Processing order', { orderId, items: items.length });
logger.error('Failed to process', { orderId, error: err.message });
```

## Error Handling

- Custom errors with status codes: `BadRequestError`, `NotFoundError`
- SQS: partial batch failure reporting (batchItemFailures)
- DLQ configured for ALL async-invoked functions
- Retry with exponential backoff for transient failures
- Circuit breaker for downstream service calls

## Security (NON-NEGOTIABLE)

- IAM: least privilege per function (no `Resource: "*"`)
- No hardcoded secrets — SSM/Secrets Manager only
- Input validation on every handler (Zod schema)
- No `eval()`, `new Function()`, or dynamic code execution
- Pin all dependencies to exact versions
- VPC: only if accessing RDS/ElastiCache (avoid for performance if possible)

## Testing

- Jest/Vitest, coverage 70%+
- Mock AWS services with `@aws-sdk/client-mock`
- Test handlers with realistic event payloads
- Name: `should [behavior] when [condition]`

## Git

- Branch: `type/TICKET-description`
- Commit: `type(scope): description` (Conventional Commits)
- PR: `TICKET-123 Description`, max 400 lines
