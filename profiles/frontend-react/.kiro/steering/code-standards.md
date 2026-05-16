---
inclusion: auto
---

# Code Standards — Frontend React/Next.js

## Framework

- Next.js 14+ App Router, TypeScript strict
- Functional components only, Server Components by default
- `"use client"` only when interactivity needed
- Zustand for global state, React state for local

## Components

- One component per file, named export = filename
- Props interface explicitly typed
- WCAG 2.1 AA: aria labels, semantic HTML, keyboard nav
- Mobile-first responsive with Tailwind

## Styling

- Tailwind CSS utility classes only
- shadcn/ui for base components (no other UI libs)
- CSS variables for design tokens
- No inline styles, no CSS modules

## Security

- No API keys in client code
- Server API routes for sensitive operations
- Sanitize user input (XSS prevention)
- CSRF on mutations

## Testing

- Vitest + React Testing Library (unit)
- Playwright (E2E)
- Test behavior, not implementation
- Accessible queries: `getByRole`, `getByLabelText`

## Git

- Branch: `type/TICKET-description`
- Commit: `type(scope): description`
- PR: `TICKET-123 Description`, max 400 lines
