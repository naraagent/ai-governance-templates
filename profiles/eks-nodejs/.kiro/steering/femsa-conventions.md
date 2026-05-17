---
inclusion: auto
---

# FEMSA Conventions — EKS Node.js

## Service Naming

- Pattern: `{service}-{country}` suffix
- Countries: cl (Chile), co (Colombia), ec (Ecuador), mx (Mexico)
- Examples: `customer-service-cl`, `payment-service-cl`, `inventory-service-mx`
- Docker image tag: `{service}-{country}:{git-sha}`

## Environment Promotion

- develop → staging (auto on merge) → production (requires approval)
- Branch mapping:
  - `develop` → dev environment
  - `staging` / `*staging*` → staging environment
  - `main` → production environment
- Feature branches: `dev/{country}/feature-name` or `fix/ticket-description`

## Approved AWS Services

- Compute: EKS, ECS Fargate
- Container: ECR (private registry)
- Load Balancing: ALB (Application Load Balancer)
- Messaging: SQS (standard and FIFO queues)
- Storage: S3 (artifacts, logs)
- Observability: CloudWatch (logs, metrics, alarms)
- Secrets: Secrets Manager + HashiCorp Vault

## Jenkins Pipeline

- Server: cicd.socoomni.com
- Trigger: BitBucketMultibranchTrigger
- Shared library: `@Library('femsa-pipeline-lib')`
- Stages: checkout → install → lint → test → sonar → build-image → push-ecr → deploy
- Approval gate: required before production deploy
- Notifications: Slack channel per team

## Bitbucket Configuration

- Workspace: digitaldifarma
- Branch protection: `main` and `staging` branches
- Allowed branch patterns: `(.*staging.*|chore/deps-update|.*main.*|dev/{country}/.*|fix/.*|hotfix/.*)`
- PR reviewers: minimum 2 approvals for production branches
