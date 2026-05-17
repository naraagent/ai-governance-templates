---
name: "security-scan-lambda"
version: "1.0.0"
description: "Security scanning for Lambda Node.js functions — IAM, secrets, and serverless-specific vulnerabilities"
triggers:
  - "security scan"
  - "vulnerability"
  - "iam review"
  - "seguridad"
applies_to:
  languages: ["typescript", "yaml"]
  categories: ["security", "lambda", "iam"]
---

# Security Scan — Lambda Node.js

You are performing a security scan on a Lambda Node.js function following AWS Lambda security best practices and FEMSA standards.

## Scan Categories

### 1. IAM Least Privilege (CRITICAL)
- [ ] No `Resource: "*"` in IAM statements
- [ ] No `Action: "*"` or overly broad actions
- [ ] Each function has its own role (not shared)
- [ ] Permissions scoped to specific resources (ARNs with account/region)
- [ ] No `iam:*`, `s3:*`, `dynamodb:*` wildcards
- [ ] Custom policies over AWS managed policies when possible

### 2. Secrets Management (CRITICAL)
- [ ] No hardcoded API keys, tokens, passwords in code
- [ ] No secrets in serverless.yml environment variables (use SSM refs)
- [ ] Secrets loaded from SSM Parameter Store or Secrets Manager
- [ ] No AWS credentials in code (use execution role)
- [ ] No hardcoded account IDs or ARNs

### 3. Input Validation
- [ ] All handler inputs validated with schema (Zod/Joi)
- [ ] Event source mapping properly typed
- [ ] No eval() or dynamic code execution
- [ ] JSON.parse wrapped in try/catch
- [ ] SQL injection protection (parameterized queries)

### 4. Configuration Security
- [ ] Function timeout appropriate (not 900s for API functions)
- [ ] Memory sized correctly (not over-provisioned)
- [ ] VPC configured only if accessing private resources
- [ ] Reserved concurrency set for critical functions
- [ ] DLQ configured for async invocations

### 5. Dependency Security
- [ ] All dependencies pinned to exact versions
- [ ] No known CVEs (npm audit)
- [ ] No deprecated packages
- [ ] Minimal production dependencies
- [ ] No unnecessary AWS SDK modules bundled

### 6. Serverless-Specific
- [ ] No synchronous Lambda-to-Lambda invocation (use SQS/EventBridge)
- [ ] API Gateway: authorization configured (IAM, Cognito, or Lambda authorizer)
- [ ] No public endpoints without auth
- [ ] Proper error responses (no stack traces in 5xx)
- [ ] CloudWatch logs: no sensitive data logged
- [ ] Timeout < API Gateway timeout (29s) for REST APIs

## Output Format

```markdown
## Security Scan Report — Lambda Node.js

**Overall Risk**: LOW | MEDIUM | HIGH | CRITICAL
**IAM Compliance**: PASS | FAIL
**Secrets Detected**: 0

### Critical Findings

| # | Category | File | Line | Description | Remediation |
|---|----------|------|------|-------------|-------------|

### IAM Policy Issues

| # | Resource | Issue | Recommended Fix |
|---|----------|-------|-----------------|

### Recommendations
1. ...
```
