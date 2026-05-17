---
name: "security-scan-ecs-hub"
version: "1.0.0"
description: "Security scanning for ECS Hub containerized microservices"
triggers:
  - "security scan"
  - "vulnerability"
  - "container security"
  - "seguridad"
applies_to:
  languages: ["typescript", "dockerfile", "yaml"]
  categories: ["security", "container", "ecs"]
---

# Security Scan — ECS Hub Service

You are performing a security scan on an ECS Hub containerized microservice following OWASP, container security best practices, and FEMSA standards.

## Scan Categories

### 1. Container Security (CRITICAL)
- [ ] Dockerfile does NOT run as root (USER instruction present)
- [ ] Base image is pinned (no `latest` tag)
- [ ] Multi-stage build used (build artifacts not in production image)
- [ ] No secrets in Dockerfile (no ENV with actual secrets)
- [ ] .dockerignore excludes: .env, .git, node_modules, tests
- [ ] HEALTHCHECK instruction present
- [ ] No unnecessary packages installed in production stage

### 2. Secrets Detection (CRITICAL)
Scan for patterns:
- API keys: `sk-`, `ak_`, `AKIA`, `ghp_`
- Passwords: `password\s*=\s*["']`
- Connection strings with credentials
- AWS credentials in code
- Private keys in repository

### 3. Network Security
- [ ] No hardcoded service URLs (use env vars)
- [ ] HTTPS enforced for all external calls
- [ ] Internal service communication via private subnets
- [ ] No exposed debug ports in production (docker-compose.yml vs Helm)
- [ ] Security groups/network policies restrict access

### 4. Environment Variable Security
- [ ] Secrets referenced from AWS Secrets Manager (not plaintext in task def)
- [ ] No secrets in docker-compose.yml committed to repo
- [ ] .env files in .gitignore
- [ ] ECS task definition secrets use `valueFrom` (ARN reference)

### 5. Dependency Security
- [ ] All dependencies pinned to exact versions
- [ ] No known CVEs in production dependencies
- [ ] `npm audit` passes with no critical/high vulnerabilities
- [ ] No deprecated packages

### 6. Application Security
- [ ] Input validation (Zod/Joi) on all endpoints
- [ ] Parameterized queries only (no string interpolation in SQL)
- [ ] No `console.log` in production code
- [ ] Error responses don't expose stack traces
- [ ] CORS properly configured (not wildcard in production)
- [ ] Rate limiting configured for public endpoints

### 7. SQS/Messaging Security
- [ ] Message validation before processing
- [ ] Dead letter queue configured
- [ ] No sensitive data in message attributes (use references)
- [ ] Encryption at rest enabled on queues

## Output Format

```markdown
## Security Scan Report — ECS Hub Service

**Overall Risk**: LOW | MEDIUM | HIGH | CRITICAL
**Container Security**: PASS | FAIL
**Secrets Detected**: 0

### Critical Findings

| # | Category | File | Line | Description | Remediation |
|---|----------|------|------|-------------|-------------|

### Container-Specific Issues

| # | Issue | File | Remediation |
|---|-------|------|-------------|

### Recommendations
1. ...
```
