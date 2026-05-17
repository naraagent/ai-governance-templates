# Skill: Security Scan — EKS Node.js

## Trigger
When files are created or modified that could introduce security vulnerabilities.

## Checks

### Dependency Security
- Run `npm audit` — no high/critical vulnerabilities
- All dependencies pinned to exact versions (no ^ or ~)
- No deprecated packages (check npm registry)
- No known vulnerable packages in production dependencies

### Container Security
- Dockerfile runs as non-root user
- Base image is official and version-pinned (node:20-alpine)
- No secrets in Docker build args or layers
- .dockerignore excludes: node_modules, .env, .git, tests

### Code Security
- No `eval()`, `Function()`, or dynamic code execution
- No SQL injection vectors (parameterized queries only)
- No XSS vectors in response construction
- No path traversal in file operations
- No SSRF vectors in external HTTP calls

### Secrets Management
- No hardcoded tokens, passwords, API keys
- Secrets loaded from Vault or Secrets Manager
- .env files in .gitignore
- No secrets in logs or error messages

### Network Security
- HTTPS only for external calls
- TLS verification not disabled
- No wildcard CORS origins in production
- Rate limiting configured on public endpoints
