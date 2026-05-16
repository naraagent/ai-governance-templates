---
inclusion: fileMatch
fileMatchPattern: "**/Dockerfile*,**/helm/**,**/Jenkinsfile,**/*.yaml"
---

# Deployment — EKS Node.js

## Docker

- Multi-stage build: `node:20-alpine`
- Non-root user in production image
- `.dockerignore` must exclude: node_modules, .env, .git, tests
- Health check: `HEALTHCHECK CMD curl -f http://localhost:${PORT}/health`

## Helm (Capsula Pattern)

- Values per environment: `values-dev.yaml`, `values-staging.yaml`, `values-prod.yaml`
- Resource limits always set (CPU + memory)
- Liveness/readiness probes configured
- Pod disruption budget for production

## Jenkins Pipeline

- Stages: checkout → install → lint → test → build → push → deploy
- No `terraform apply` or `helm upgrade --install` without approval gate
- Artifacts: Docker image tagged with git SHA + branch

## Health Endpoint

Every service MUST expose:
```
GET /health → { status: "ok", version: "x.y.z", uptime: N }
```

Used for:
- Kubernetes readiness probe
- Kubernetes liveness probe
- Load balancer health check
