---
inclusion: auto
---

# Code Standards — Generic Profile

## Security (CRITICAL)

- NEVER hardcode secrets, tokens, passwords, or API keys
- NEVER commit .env, credentials, or key files
- HTTPS only for external communication
- Input validation on all user-facing interfaces
- Parameterized queries (no SQL string concatenation)
- Dependencies pinned to exact versions

## Code Quality

- Explicit error handling (no silent catches)
- Structured logging (no print/console.log in production)
- Single responsibility per function
- Descriptive naming
- DRY: extract shared logic

## Git Workflow

- Branch: `type/TICKET-description`
- Commit: `type(scope): description` (Conventional Commits)
- PR: `TICKET-123 Description`, target `develop`
- Max PR size: 400 lines

## Testing

- New business logic requires tests
- Coverage target: 70%+
- Tests independent, external services mocked
- Descriptive test names (behavior-focused)
