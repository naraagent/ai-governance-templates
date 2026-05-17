# Skill: Security Scan — Frontend React/Next.js

## Trigger
When files are created or modified that could introduce security vulnerabilities.

## Checks

### Client-Side Security
- No secrets or API keys in `NEXT_PUBLIC_*` variables
- No sensitive data in localStorage (use httpOnly cookies)
- No `eval()` or dynamic script injection
- Content Security Policy headers configured
- No open redirects in navigation logic

### XSS Prevention
- No `dangerouslySetInnerHTML` without DOMPurify sanitization
- User input escaped in rendered output
- URL parameters validated before use
- No inline event handlers with user data

### Authentication
- Cognito JWT validated server-side in middleware.ts
- Session tokens not exposed to client JavaScript
- Logout properly revokes tokens
- Protected routes redirect unauthenticated users

### Dependencies
- All dependencies pinned to exact versions
- No known vulnerabilities (npm audit)
- No deprecated packages
- shadcn/ui only for UI components (no unapproved UI libraries)

### Data Handling
- Form data validated with Zod before submission
- File uploads validated (type, size, content)
- PII not logged or stored in client state
- API responses typed with Zod schemas
