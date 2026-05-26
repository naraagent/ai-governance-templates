# frontend-react

## Commands
- Install: `npm ci`
- Build: `npm run build`
- Dev: `npm run dev`
- Lint: `npm run lint`
- Type Check: `npm run type-check`
- Test: `npm test`
- Test E2E: `npm run test:e2e`

## Testing
- Run tests before marking any task as done
- New components with logic must have unit tests (Vitest + React Testing Library)
- E2E tests (Playwright) for critical user flows
- Coverage target: 70%+ on new code
- Test user behavior, not implementation details

## Do Not
- Do not use class components — functional only
- Do not install UI libraries besides shadcn/ui
- Do not use `dangerouslySetInnerHTML` without sanitization
- Do not add client-side secrets or API keys
- Do not disable ESLint or TypeScript strict
- Do not use `any` type or `@ts-ignore` without justification
- Do not commit `.env` files
