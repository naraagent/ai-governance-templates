# Skill: Code Review — Frontend React/Next.js

## Trigger
When reviewing pull requests or code changes in React/Next.js applications.

## Checks

### Architecture
- Server Components by default, `"use client"` only when needed
- One component per file, named export matches filename
- No prop drilling beyond 2 levels (use Zustand or context)
- Route groups used for layout separation

### FEMSA Conventions
- Zustand stores: one per domain, immer middleware
- i18n: all user-facing strings use next-intl
- Auth: Cognito session check in protected routes
- Styling: Tailwind only, no inline styles

### Accessibility (WCAG 2.1 AA)
- Semantic HTML elements used correctly
- aria-label on interactive elements without visible text
- Keyboard navigation works for all interactive elements
- Color contrast meets AA ratio (4.5:1 text, 3:1 large text)
- Focus indicators visible

### Performance
- Images use `next/image` with proper sizing
- Dynamic imports for heavy components
- No unnecessary client-side rendering
- Bundle size monitored (no large dependencies without justification)

### Security
- No API keys in client-side code
- User input sanitized before rendering
- CSRF protection on mutations
- No `dangerouslySetInnerHTML` without sanitization
