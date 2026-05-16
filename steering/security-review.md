---
inclusion: auto
---

# Security Review Standards

> Always active. Ensures all code changes are evaluated for security impact.

## Critical Patterns to REJECT

| Pattern | Severity | Action |
|---------|----------|--------|
| Hardcoded secret/token/password | 🔴 Critical | Block immediately |
| SQL string concatenation | 🔴 Critical | Require parameterized query |
| HTTP (no TLS) for external calls | 🟡 Major | Require HTTPS |
| SSL/TLS verification disabled | 🟡 Major | Remove disable flag |
| Input without validation | 🟡 Major | Add validation layer |
| MD5/SHA1 for passwords | 🟡 Major | Use bcrypt/argon2 |
| Sensitive data in logs | 🟡 Major | Mask/redact |
| Unpinned dependencies | 🔵 Minor | Pin to exact version |

## Files That MUST NOT Be Committed

```
.env, .env.*, *.pem, *.key, *.p12, *.jks
credentials.json, service-account.json
terraform.tfstate, *.tfstate.backup
```

## Secrets Management

- Production: HashiCorp Vault or AWS Secrets Manager
- Development: `.env.local` (gitignored)
- CI/CD: Jenkins credentials store
- NEVER: hardcoded, committed, or logged

## Dependency Security

- Pin exact versions (no ranges)
- Run `npm audit` / `pip audit` before merging
- No unknown/untrusted packages
- Verify package name spelling (typosquatting prevention)
- Review transitive dependency changes

## OWASP Agentic Top 10 Awareness

When code involves AI agents:
- ASI-01: Limit agent capabilities (least privilege)
- ASI-02: Sanitize all inputs (prompt injection prevention)
- ASI-04: Validate tool usage patterns
- ASI-06: Proper identity delegation (OAuth 2.1, not static tokens)
- ASI-08: Sanitize agent outputs before display
- ASI-09: Audit all agent actions
