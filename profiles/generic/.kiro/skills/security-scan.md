---
name: "security-scan-generic"
version: "1.0.0"
description: "Baseline security scanning for any repository — OWASP Top 10 + secrets detection"
triggers:
  - "security"
  - "vulnerability"
  - "secrets"
  - "seguridad"
applies_to:
  languages: ["*"]
  categories: ["security", "scanning"]
inclusion: auto
---

# Security Scan — Generic

## Context
Universal security scan applicable to any language and platform.

## Secrets Detection (CRITICAL)
- API keys: patterns starting with `sk-`, `ak_`, `AKIA`, `ghp_`, `ghs_`, `glpat-`
- Passwords: `password\s*=\s*["']`, `passwd`, `secret\s*=`
- Tokens: `token\s*=\s*["']`, `bearer\s+[a-z0-9]`
- Connection strings with embedded credentials
- Private keys: `-----BEGIN.*PRIVATE KEY-----`

## Common Vulnerabilities
- [ ] No string interpolation in database queries
- [ ] No unsanitized user input in shell commands
- [ ] No disabled security features (SSL verification, CSRF)
- [ ] No debug/development modes enabled in production paths
- [ ] No overly permissive file/directory permissions

## Data Exposure
- [ ] Sensitive data not logged (PII, credentials, tokens)
- [ ] Error messages don't reveal internal details
- [ ] No sensitive data in URL parameters or query strings
- [ ] .env files listed in .gitignore

## Dependency Risks
- [ ] No known CVEs in dependencies
- [ ] No unpinned dependency versions
- [ ] No suspicious/unfamiliar packages

## Output
```markdown
## Security Scan Report

**Overall Risk**: LOW | MEDIUM | HIGH | CRITICAL

| # | Severity | Type | File | Line | Remediation |
|---|----------|------|------|------|-------------|
```
