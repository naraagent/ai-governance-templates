# AGENTS.md — Frontend React/Next.js

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Profile: frontend-react | Org: FEMSA Digital
> Framework: Next.js 14 + TypeScript + React

## Identity

- Organization: FEMSA Digital
- App type: React/Next.js frontend application
- Framework: Next.js 14 (App Router)
- State: Zustand
- Styling: Tailwind CSS + shadcn/ui
- Auth: AWS Cognito (NextAuth.js adapter)
- i18n: next-intl

## Build

```bash
npm ci
npm run build            # Next.js production build
npm run lint             # ESLint check
npm run type-check       # TypeScript strict check
npm test                 # Vitest unit tests
npm run test:e2e         # Playwright E2E tests
```

## Project Structure

```
src/
├── app/              # Next.js App Router pages
│   ├── (auth)/       # Auth-gated routes
│   ├── dashboard/    # Dashboard pages
│   └── api/          # API routes (if needed)
├── components/       # Reusable UI components
│   ├── ui/           # Primitives (shadcn/ui)
│   └── features/     # Feature-specific components
├── hooks/            # Custom React hooks
├── lib/              # Utilities, API client
├── stores/           # Zustand stores
├── types/            # TypeScript type definitions
└── themes/           # Theme configuration
```

## Conventions

### Language
- TypeScript strict mode obligatorio
- No `any` — explicit types or `unknown`
- Functional components only (no class components)
- Custom hooks for shared logic
- Server Components by default, `"use client"` only when needed

### Components
- One component per file
- Props interface explicitly typed
- Use `React.FC` or explicit return types
- Accessibility: WCAG 2.1 AA compliance (aria labels, semantic HTML, keyboard nav)
- Responsive: mobile-first approach

### State Management
- Zustand for global state
- React state for local component state
- No prop drilling beyond 2 levels — use context or store
- Server state via React Query/SWR patterns

### Styling
- Tailwind CSS utility classes
- shadcn/ui for base components
- No inline styles
- No CSS modules (use Tailwind)
- Design tokens via CSS variables in theme

### Security
- NEVER expose API keys in client-side code
- Use server-side API routes for sensitive operations
- Sanitize user input before rendering (XSS prevention)
- CSRF protection on mutations
- Content Security Policy headers

### Testing
- Unit: Vitest + React Testing Library
- E2E: Playwright
- Coverage: 70%+ for new components with logic
- Test user behavior, not implementation details

### Branching & Commits
- Branch: `type/TICKET-descripcion-corta`
- Commits: `type(scope): descripción` (Conventional Commits)
- PR title: `TICKET-123 Description`

## Constraints

- Do NOT use class components
- Do NOT install UI libraries besides shadcn/ui (no Material UI, Ant Design, Chakra)
- Do NOT use `dangerouslySetInnerHTML` without sanitization
- Do NOT add client-side secrets/API keys
- Do NOT disable ESLint or TypeScript strict
- Do NOT use `@ts-ignore` without justification comment

## Agent Autonomy

- Level: supervised
- Allowed: read, lint, test, create/modify components, add pages
- Blocked: modify auth config, change deployment, access env secrets
- Approval: new dependencies, auth flow changes, API contract changes
