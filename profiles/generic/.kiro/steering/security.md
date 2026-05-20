---
inclusion: always
---

# Security Policy

## Unbreakable Rules

- Never hardcode secrets, tokens, or passwords in source code
- Never commit .env files (ensure .gitignore has .env*)
- Never disable security controls or audit logging
- Never silently swallow errors (`except: pass`, empty catch blocks)
- Validate all inputs at system boundaries
- Use parameterized queries (never SQL string concatenation)
- Log security-relevant events (access, auth failures, data changes)
- Pin dependency versions (no floating ^, ~, or latest)

## Secrets Management

- Use environment variables for non-sensitive configuration
- Use a secrets manager (Vault, AWS Secrets Manager, SSM) for credentials
- Rotate credentials periodically
- Never log secret values

## HTTPS & Communication

- All external HTTP calls must use HTTPS
- Never disable TLS/SSL verification
- Validate certificates in production
