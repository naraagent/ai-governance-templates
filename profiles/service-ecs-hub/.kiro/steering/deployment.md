---
inclusion: fileMatch
fileMatchPattern: "**/Dockerfile*,**/helm/**,**/Jenkinsfile,**/docker-compose*"
---

# Deployment — ECS Hub Service (Capsula Pattern)

## Docker (Multi-Stage Build)

```dockerfile
# Stage 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:20-alpine AS production
RUN addgroup -g 1001 -S nodejs && adduser -S nodejs -u 1001
WORKDIR /app
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/package.json ./
USER nodejs
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "dist/main.js"]
```

### Docker Rules
- ALWAYS use multi-stage builds (build → production)
- NEVER run as root in production image
- `.dockerignore` must exclude: node_modules, .env, .git, tests, docs
- Use alpine or distroless for production stage
- Pin base image to specific digest when possible
- HEALTHCHECK instruction required

## Helm Chart (Capsula Pattern)

### Chart Structure
```
helm/
├── Chart.yaml              # Chart metadata, version, appVersion
├── values.yaml             # Default values (lowest environment)
├── values-dev.yaml         # Development overrides
├── values-staging.yaml     # Staging overrides
├── values-prod.yaml        # Production overrides
├── templates/
│   ├── _helpers.tpl        # Template helpers (fullname, labels, etc.)
│   ├── deployment.yaml     # Main deployment spec
│   ├── service.yaml        # ClusterIP service
│   ├── ingress.yaml        # Ingress rules (if external)
│   ├── hpa.yaml            # Horizontal Pod Autoscaler
│   ├── pdb.yaml            # Pod Disruption Budget
│   ├── configmap.yaml      # Non-sensitive config
│   ├── serviceaccount.yaml # Service account
│   └── NOTES.txt           # Post-install notes
└── charts/                 # Subcharts (if parent Capsula chart)
```

### Values Conventions
- All resource limits defined (CPU + memory)
- Probes: readiness (5s initial, 10s period) + liveness (15s initial, 20s period)
- replicas: min 2 for staging/prod (never 1 in prod)
- Environment variables via configmap or secret references
- Image tag: `{{ .Values.image.tag | default .Chart.AppVersion }}`

### Environment Promotion
```
values-dev.yaml     → replicas: 1, resources: 256Mi/0.25CPU
values-staging.yaml → replicas: 2, resources: 512Mi/0.5CPU
values-prod.yaml    → replicas: 3-10, resources: 1Gi/1CPU, HPA enabled
```

## ECS Task Definition

- Task CPU/Memory aligned with Helm values per environment
- Logging: awslogs driver → CloudWatch log group `/ecs/{service-name}/{env}`
- Secrets: reference AWS Secrets Manager ARNs, never plaintext
- Network mode: awsvpc (each task gets ENI)
- Service discovery: AWS Cloud Map (optional, prefer env vars)

## Jenkins Pipeline

### Standard Stages
```groovy
pipeline {
    agent any
    stages {
        stage('Checkout') { ... }
        stage('Install') { steps { sh 'npm ci' } }
        stage('Lint') { steps { sh 'npm run lint' } }
        stage('Test') { steps { sh 'npm test' } }
        stage('Build') { steps { sh 'npm run build' } }
        stage('Docker Build & Push') {
            steps {
                sh "docker build -t ${ECR_REPO}:${GIT_SHA} ."
                sh "docker push ${ECR_REPO}:${GIT_SHA}"
            }
        }
        stage('Deploy Dev') {
            when { branch 'develop' }
            steps { sh "helm upgrade --install ${SERVICE} ./helm -f helm/values-dev.yaml --set image.tag=${GIT_SHA}" }
        }
        stage('Deploy Staging') {
            when { branch 'release/*' }
            steps { sh "helm upgrade --install ${SERVICE} ./helm -f helm/values-staging.yaml --set image.tag=${GIT_SHA}" }
        }
        stage('Deploy Prod') {
            when { branch 'main' }
            input { message 'Deploy to production?' }
            steps { sh "helm upgrade --install ${SERVICE} ./helm -f helm/values-prod.yaml --set image.tag=${GIT_SHA}" }
        }
    }
}
```

### Jenkins Rules
- Approval gate required for production deployment
- Docker images tagged with git SHA + branch
- Helm chart version bumped on every deployment
- Post-deploy: smoke test hitting /health endpoint
- Rollback: `helm rollback ${SERVICE} 1` if smoke test fails

## Health Endpoint

Every service MUST expose:
```json
GET /health → {
  "status": "ok",
  "version": "1.2.3",
  "uptime": 12345,
  "dependencies": {
    "database": "ok",
    "redis": "ok",
    "sqs": "ok"
  }
}
```

Used for:
- ECS task health check
- Kubernetes readiness/liveness probes
- Load balancer health check
- Jenkins post-deploy smoke test
