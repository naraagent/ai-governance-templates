# eks-nodejs

## Commands
- Install: `npm ci`
- Build: `npm run build`
- Dev: `npm run dev`
- Test: `npm test`
- Coverage: `npm run test:coverage`
- Lint: `npm run lint`

## Testing
- Run tests before marking any task as done
- New code must have corresponding unit tests
- Coverage target: 70%+ on new code
- External services must be mocked in unit tests

## Do Not
- Do not modify Dockerfile without DevOps review
- Do not add dependencies without explicit justification
- Do not use `any` type — use explicit types or `unknown`
- Do not disable TypeScript strict checks
- Do not commit `.env` files or secrets
- Do not use `console.log` — use structured logger (pino/winston)
- Do not introduce ORM migrations without DBA review
