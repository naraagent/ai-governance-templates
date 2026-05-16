---
name: "security-scan"
version: "1.0.0"
description: "Security vulnerability scanning aligned with OWASP and FEMSA standards"
triggers:
  - "security scan"
  - "vulnerability"
  - "secret scan"
  - "owasp"
  - "seguridad"
applies_to:
  languages: ["*"]
  categories: ["security", "owasp", "scanning"]
---

# Security Scan Skill

You are performing a security scan on code following OWASP Top 10, OWASP Agentic Top 10, and FEMSA security standards.

## Scan Categories

### 1. Secrets Detection (CRITICAL)
Scan for patterns:
- API keys: `sk-`, `ak_`, `AKIA`, `ghp_`, `ghs_`, `glpat-`
- Passwords: `password\s*=\s*["']`, `passwd`, `secret\s*=`
- Tokens: `token\s*=\s*["']`, `bearer\s+[a-z0-9]`
- Connection strings: `postgres://`, `mysql://`, `mongodb://` with credentials
- Private keys: `-----BEGIN.*PRIVATE KEY-----`

### 2. Injection Vulnerabilities (CRITICAL)
- SQL injection: string interpolation in queries
- Command injection: unsanitized input in shell commands
- XSS: unescaped user input in HTML output
- Template injection: user input in template engines

### 3. Authentication & Authorization
- Hardcoded credentials
- Missing auth checks on endpoints
- Static tokens for external clients (should be OAuth 2.1)
- Missing token expiration
- Overly permissive CORS

### 4. Data Exposure
- Sensitive data in logs (PII, credentials, tokens)
- Verbose error messages in production
- Debug endpoints enabled
- Sensitive data in URL parameters

### 5. Dependency Risks
- Known CVEs in dependencies
- Unpinned versions
- Suspicious package names (typosquatting)
- Deprecated packages

### 6. Agent-Specific (OWASP Agentic Top 10)
- ASI-01: Excessive agent permissions
- ASI-02: Prompt injection vectors
- ASI-04: Tool misuse potential
- ASI-06: Weak identity delegation
- ASI-08: Unsanitized agent output
- ASI-09: Missing audit trails

## Output Format

```markdown
## Security Scan Report

**Overall Risk**: LOW | MEDIUM | HIGH | CRITICAL
**Scan Date**: YYYY-MM-DD
**Files Scanned**: N

### Critical Findings (Immediate Action Required)

| # | Type | File | Line | Description | Remediation |
|---|------|------|------|-------------|-------------|

### High Findings

| # | Type | File | Line | Description | Remediation |
|---|------|------|------|-------------|-------------|

### Medium Findings

| # | Type | File | Line | Description | Remediation |
|---|------|------|------|-------------|-------------|

### Recommendations
1. ...
```
