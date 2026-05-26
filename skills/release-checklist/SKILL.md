---
name: release-checklist
description: |
  Use when preparing to deploy, ship, release, or promote code to production.
  Activate when the user says "deploy", "ship", "release", "go live", "promote to prod",
  or is working on CI/CD pipelines, Helm values, or deployment configs. Provides
  pre-deployment verification gates and rollback planning.
license: MIT
compatibility: Kiro, Claude Code, Copilot, Codex, Gemini CLI, Windsurf
metadata:
  author: nara-governance
  category: deployment
  trigger-type: conditional
  stack-match: kubernetes,ecs,eks,docker,helm,mobile
---

# Release Checklist

Pre-deployment verification gates and rollback planning.

## Process

### Step 1: Pre-Release Verification
- [ ] All tests pass (unit + integration + E2E where applicable)
- [ ] Lint passes with zero warnings
- [ ] Build succeeds (production mode, not dev)
- [ ] No new security vulnerabilities (npm audit / pip audit / Snyk)
- [ ] No secrets in codebase (git-secrets scan)
- [ ] Version bumped appropriately (SemVer)

### Step 2: Change Assessment
- [ ] Breaking changes documented and communicated
- [ ] Database migrations tested (forward AND rollback)
- [ ] Feature flags configured for gradual rollout
- [ ] Dependencies pinned to exact versions
- [ ] Backward compatibility maintained (or migration path provided)

### Step 3: Observability Ready
- [ ] Health endpoint returns 200 with dependency status
- [ ] Structured logging includes trace_id
- [ ] Key metrics instrumented (latency, errors, throughput)
- [ ] Alerts configured for error rate spike
- [ ] Dashboard updated with new service/endpoint

### Step 4: Deployment Strategy
- [ ] Deployment type chosen: rolling | blue-green | canary
- [ ] Resource limits set (CPU, memory) for target environment
- [ ] Replicas ≥ 2 for production
- [ ] HPA configured (if applicable)
- [ ] PodDisruptionBudget defined (Kubernetes)

### Step 5: Rollback Plan
- [ ] Previous version identified and tagged
- [ ] Rollback command documented: `helm rollback` / `ecs update-service` / revert commit
- [ ] Database rollback tested (if migration involved)
- [ ] Estimated rollback time: _____ minutes
- [ ] Rollback owner assigned

### Step 6: Post-Deploy Validation
- [ ] Smoke test critical paths after deploy
- [ ] Monitor error rate for 15 minutes post-deploy
- [ ] Verify health endpoints on new instances
- [ ] Check logs for unexpected warnings/errors
- [ ] Confirm metrics flowing to dashboard

## Anti-Rationalization Table

| Excuse | Rebuttal |
|--------|----------|
| "It's a small change, no need for all this" | Small changes cause outages too. The checklist is fast. |
| "We can hotfix if something breaks" | Hotfixes under pressure introduce more bugs. Prevent, don't react. |
| "We don't have time for canary" | Rolling deploy with health checks takes the same time. Use it. |
| "Rollback plan is overkill" | You'll wish you had one at 2am. 5 minutes now saves hours later. |
| "Tests passed in CI, good enough" | CI doesn't test infrastructure, config, or integrations. Smoke test. |

## Red Flags
- Deploying on Friday afternoon
- No rollback plan documented
- "YOLO deploy" (skipping CI, force-pushing to prod)
- Database migration with no rollback path
- First deploy of a new service with zero monitoring
- Deploying multiple unrelated changes together

## Verification
- [ ] All pre-release checks green
- [ ] Rollback plan documented and tested
- [ ] Deployment succeeded without errors
- [ ] Post-deploy smoke tests pass
- [ ] No error rate increase in first 15 minutes
- [ ] Team notified of successful deployment
