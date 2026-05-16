---
inclusion: auto
---

# Code Standards — FEMSA Enterprise

> This steering file is always active. It provides baseline coding standards for all interactions.

## Security (CRITICAL — never override)

1. NEVER hardcode secrets, tokens, passwords, or API keys in source code
2. NEVER commit `.env`, `credentials.json`, keystores, or PEM files
3. All external communication via HTTPS only
4. All user input must be validated before processing
5. SQL queries must use parameterized statements (no string concatenation)
6. No weak hashing (MD5/SHA1) for passwords — use bcrypt/argon2/scrypt
7. Dependencies pinned to exact versions
8. Logs must not contain PII or credentials (mask sensitive data)

## Error Handling

- NEVER use empty catch blocks — always log with context
- NEVER use `except: pass` (Python) or `catch(e) {}` (JS/TS)
- Custom error classes with meaningful messages and HTTP status codes
- Structured logging with trace context

## Code Quality

- Prefer immutability (`const` over `let`, `val` over `var`)
- Single responsibility per function/class
- Descriptive names — no abbreviations without domain context
- Max function length: 50 lines (recommend < 30)
- Max file length: 500 lines (recommend splitting if larger)
- DRY: extract repeated logic into shared utilities

## Git Workflow

- Branch: `type/TICKET-descripcion-corta`
- Commits: `type(scope): descripción` (Conventional Commits, max 72 chars)
- PR title: `TICKET-123 Description of change`
- PR max size: 400 lines (split if > 800)
- Target: `develop` (never direct to `main` except hotfix)
