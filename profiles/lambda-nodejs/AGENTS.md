# AGENTS.md — Lambda Node.js Function

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Profile: lambda-nodejs | Org: FEMSA Digital
> Runtime: Node.js 20 on AWS Lambda (Serverless/SAM)

## Identity

- Organization: FEMSA Digital (workspace: digitaldifarma)
- Service type: Node.js/TypeScript serverless function
- Runtime: AWS Lambda (Node.js 20.x)
- Deploy: Serverless Framework or AWS SAM
- Triggers: API Gateway, SQS, EventBridge, S3, DynamoDB Streams
- Repos: ~30 repos (service-lambda-request_od_oms, service-lambda-asigna_od, etc.)
- Layers: Shared dependencies via Lambda Layers

## Build

```bash
npm ci                    # Install (CI mode, uses lockfile)
npm run build            # TypeScript compilation + bundling (esbuild/webpack)
npm run lint             # ESLint check
npm test                 # Jest/Vitest unit tests
npm run package          # Bundle for deployment (< 5MB target)
npx serverless package   # Serverless Framework package
# OR
sam build                # SAM build
sam local invoke         # Local testing
```

## Project Structure

```
src/
├── handlers/            # Lambda entry points (thin handlers)
├── services/            # Business logic layer
├── repositories/        # Data access (DynamoDB, RDS, etc.)
├── models/              # TypeScript interfaces & types
├── utils/               # Pure utility functions
├── middleware/          # Middy middleware stack
├── config/              # Environment config + SSM parameters
└── tests/               # Unit and integration tests
layers/
├── common/              # Shared dependencies layer
└── utils/               # Shared utilities layer
serverless.yml           # Serverless Framework config
# OR
template.yaml            # SAM template
package.json
tsconfig.json
```

## Conventions

### Language
- TypeScript obligatorio (strict: true)
- No `any` — explicit types or `unknown` + type guards
- `const`/`let` only, async/await only
- Lambda Powertools for structured logging — NEVER `console.log`

### Handler Pattern (Thin Handler → Service Layer)
```typescript
// ✅ CORRECT: Thin handler delegates to service
export const handler = middy(async (event: APIGatewayProxyEvent) => {
  const input = parseAndValidate(event);
  const result = await orderService.processOrder(input);
  return formatResponse(200, result);
}).use(injectLambdaContext())
  .use(captureLambdaHandler(tracer));

// ❌ WRONG: Business logic in handler
export const handler = async (event) => {
  const items = JSON.parse(event.body);
  const total = items.reduce((sum, i) => sum + i.price * i.qty, 0);
  await db.insert({ items, total });
  return { statusCode: 200 };
};
```

### Cold Start Optimization
- Lazy imports for heavy modules (import at point of use, not top-level)
- Keep handler file imports minimal
- Use Lambda Layers for shared heavy dependencies (aws-sdk, lodash, etc.)
- Prefer lightweight libraries (dayjs over moment, got over axios)
- Connection reuse: initialize DB/HTTP clients outside handler
- Max bundle size target: 5MB (warn at 3MB)

### Environment & Configuration
- Runtime config via environment variables
- Secrets via SSM Parameter Store or Secrets Manager
- Never hardcode ARNs — use CloudFormation references or env vars
- Stage-aware: `process.env.STAGE` (dev, staging, prod)

### Dependencies
- Pinned to exact versions
- Minimal production dependencies (every KB matters)
- Dev dependencies NEVER bundled
- AWS SDK v3 modular imports: `@aws-sdk/client-s3` (not full SDK)
- Tree-shaking enabled in bundler config

### Error Handling
- Custom error classes with proper HTTP status codes
- Always log error with context (requestId, traceId) before throwing
- DLQ configured for async invocations
- Retry logic for transient failures (with exponential backoff)

### Branching & Git
- Format: `type/TICKET-descripcion-corta`
- Types: `feature/`, `fix/`, `hotfix/`, `release/`, `chore/`
- Integration: `develop` | Production: `main`
- Commits: `type(scope): descripción` (Conventional Commits)

### Testing
- Unit tests for service layer (pure functions, no AWS calls)
- Integration tests with localstack or SAM local
- Coverage target: 70%+
- Framework: Jest or Vitest
- Mock AWS services with aws-sdk-client-mock
- Naming: `should <behavior> when <condition>`

## Deployment

- Framework: Serverless Framework (serverless.yml) or SAM (template.yaml)
- Bundling: esbuild (preferred) or webpack for tree-shaking
- Stages: dev → staging → prod (via environment variables)
- CI: Jenkins multibranch pipeline
- IAM: Least privilege per function (separate role per Lambda if needed)
- Layers: shared deps deployed separately, referenced by ARN
- Timeout: function-appropriate (default 30s, max 900s for processing)
- Memory: right-sized per function (start 256MB, tune with Power Tuning)
- Monitoring: CloudWatch Alarms on errors, duration, throttles

## Constraints

- Do NOT exceed 5MB bundle size (uncompressed, excluding layers)
- Do NOT use synchronous invocation between Lambdas (use SQS/EventBridge)
- Do NOT hardcode AWS ARNs — use CloudFormation refs or env vars
- Do NOT put business logic in handler functions
- Do NOT use `*` permissions in IAM policies
- Do NOT commit `.env` files or secrets
- Do NOT use `any` type
- Do NOT import full AWS SDK v2 (use modular v3)
- Do NOT set timeout > 30s without explicit justification

## Agent Autonomy

- Level: supervised
- Allowed: read files, lint, test, suggest code changes, run SAM local
- Blocked: deploy, modify IAM policies, access secrets directly
- Approval required: new dependencies (bundle size impact), IAM changes, timeout increases, new triggers/event sources
- Escalate to: Platform team (IAM/infra), DBA (RDS access), Security (secrets)
