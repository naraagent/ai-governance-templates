# lambda-nodejs

## Commands
- Install: `npm ci`
- Build: `npm run build`
- Lint: `npm run lint`
- Test: `npm test`
- Package: `npm run package`
- SAM Build: `sam build`
- Local Invoke: `sam local invoke`

## Testing
- Run tests before marking any task as done
- New code must have corresponding unit tests
- Coverage target: 70%+ on new code
- Mock AWS services with aws-sdk-client-mock
- Test service layer (pure functions), not handlers directly

## Do Not
- Do not exceed 5MB bundle size (excluding layers)
- Do not put business logic in handler functions — delegate to service layer
- Do not use synchronous invocation between Lambdas (use SQS/EventBridge)
- Do not hardcode AWS ARNs — use CloudFormation refs or env vars
- Do not use `any` type
- Do not import full AWS SDK v2 — use modular v3 (`@aws-sdk/client-*`)
- Do not use `console.log` — use Lambda Powertools logger
- Do not commit `.env` files or secrets
