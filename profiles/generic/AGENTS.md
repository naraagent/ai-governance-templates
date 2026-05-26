# generic

## Commands
- Install: `npm install`
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

## Testing
- Run tests before marking any task as done
- New business logic must have corresponding unit tests
- Coverage target: 70%+ on new code
- Tests must be independent (no execution order dependency)
- External services always mocked in unit tests

## Do Not
- Do not modify files in `vendor/`, `node_modules/`, or generated directories
- Do not introduce new dependencies without justification
- Do not disable ESLint/linting rules without comment explanation
- Do not use `console.log` in production code — use structured logger
- Do not catch exceptions silently — always log and handle
- Do not commit `.env` files or secrets
- Do not hardcode credentials, tokens, or API keys
