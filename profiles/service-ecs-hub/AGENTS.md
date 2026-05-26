# service-ecs-hub

## Commands
- Install: `npm ci`
- Build: `npm run build`
- Lint: `npm run lint`
- Test: `npm test`
- Test Integration: `npm run test:integration`
- Docker Build: `docker build -t ${SERVICE_NAME}:${GIT_SHA} .`
- Helm Lint: `helm lint ./helm/`

## Testing
- Run tests before marking any task as done
- New business logic must have unit tests (services layer)
- Integration tests for inter-service contracts
- Coverage target: 70%+ on new code
- External services mocked in unit tests

## Do Not
- Do not modify Dockerfile without DevOps review
- Do not add dependencies without justification and security review
- Do not use `any` type
- Do not disable TypeScript strict checks
- Do not commit `.env` files or secrets
- Do not access other service's database directly — use HTTP/SQS
- Do not introduce ORM migrations without DBA review
- Do not modify Helm chart structure without Platform team approval
- Do not use `console.log` — use structured logger (pino)
