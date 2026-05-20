---
name: "security-scan-lambda-python"
version: "1.0.0"
description: "Security scanning for Python Lambda functions — OWASP + serverless-specific threats"
triggers:
  - "security"
  - "vulnerability"
  - "seguridad"
  - "scan"
applies_to:
  languages: ["python"]
  categories: ["security", "serverless"]
inclusion: auto
---

# Security Scan — Lambda Python

## Context
Scans Python Lambda function code for security vulnerabilities.

## Secrets Detection (CRITICAL)
- [ ] No API keys in source: `sk-`, `AKIA`, `ghp_`, `aws_secret`
- [ ] No passwords: `password\s*=\s*["']`
- [ ] No connection strings with credentials embedded
- [ ] No private keys in repo
- [ ] boto3 clients don't use hardcoded credentials

## Injection Vulnerabilities
- [ ] No SQL string concatenation (use parameterized queries)
- [ ] No `os.system()` or `subprocess` with unsanitized input
- [ ] No `eval()` / `exec()` on user-provided data
- [ ] No SSRF: validate URLs before making requests
- [ ] DynamoDB expressions use ExpressionAttributeValues (no string interpolation)

## Lambda-Specific Threats
- [ ] Event data treated as untrusted (validate before use)
- [ ] No overly permissive IAM (`Action: *` or `Resource: *`)
- [ ] Temporary file usage in /tmp is cleaned up
- [ ] No sensitive data in Lambda response bodies beyond what's needed
- [ ] Layers from trusted sources only

## Dependency Security
- [ ] No known CVEs in requirements.txt (check with `pip-audit`)
- [ ] Dependencies pinned to exact versions
- [ ] No suspicious package names (typosquatting)
- [ ] boto3/botocore versions are recent

## Data Exposure
- [ ] No PII in CloudWatch logs
- [ ] Error responses don't leak stack traces in production
- [ ] X-Ray traces don't contain sensitive data
- [ ] Environment variables don't contain secrets (use SSM/Secrets Manager)

## Output
```markdown
## Security Scan: Lambda Python

**Risk**: LOW | MEDIUM | HIGH | CRITICAL
**Files Scanned**: N

| # | Severity | Type | File | Line | Remediation |
|---|----------|------|------|------|-------------|
```
