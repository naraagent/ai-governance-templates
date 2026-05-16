# AGENTS.md — Frontend React/Next.js (Full Template)

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Compatible: Codex, Copilot, Cursor, Kiro, OpenClaw, Devin, Amp
> Profile: frontend-react | Org: FEMSA Digital

## Identity

- Organization: FEMSA Digital
- App: {{APP_NAME}}
- Framework: Next.js 14 (App Router) + TypeScript
- State: Zustand
- UI: Tailwind CSS + shadcn/ui
- Auth: AWS Cognito (NextAuth.js)
- i18n: next-intl

## Build

```bash
npm ci
npm run build
npm run lint
npm run type-check
```

## Test

```bash
npm test                 # Vitest unit tests
npm run test:e2e         # Playwright E2E
npm run test:coverage    # Coverage (target: 70%+)
```

## Structure

```
src/
├── app/              # App Router (pages, layouts, API routes)
├── components/
│   ├── ui/           # shadcn/ui primitives
│   └── features/     # Feature-specific components
├── hooks/            # Custom React hooks
├── lib/              # API client, utilities
├── stores/           # Zustand stores
├── types/            # TypeScript definitions
└── themes/           # Theme/design tokens
```

## Conventions

### Components
- Functional components only (no class components)
- Server Components by default, `"use client"` only when interactivity needed
- Props interface typed explicitly
- One component per file, named export matching filename
- Accessibility: WCAG 2.1 AA (aria labels, semantic HTML, keyboard navigation)

### State
- Zustand for global client state
- React state for local component state
- Server Components + fetch for server state
- No prop drilling > 2 levels

### Styling
- Tailwind CSS utility classes
- shadcn/ui base components (no other UI libraries)
- CSS variables for design tokens
- Mobile-first responsive

### Security
- No API keys/secrets in client-side code
- Server-side API routes for sensitive operations
- Sanitize user input (XSS prevention)
- CSRF protection on mutations
- CSP headers configured

### Git
- Branch: `type/TICKET-description`
- Commit: `type(scope): description`
- PR: `TICKET-123 Description`

## Constraints

- No class components
- No UI libraries besides shadcn/ui
- No `dangerouslySetInnerHTML` without sanitization
- No client-side secrets
- No `@ts-ignore` without justification
- No `useEffect` for data fetching in new code

## Agent Governance

- Mode: supervised
- Allowed: read, lint, test, create/modify components and pages
- Blocked: modify auth config, change deployment, access secrets
- Approval: new dependencies, auth changes, API contract changes
