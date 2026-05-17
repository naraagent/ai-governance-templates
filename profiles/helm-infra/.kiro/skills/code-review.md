---
name: "code-review-helm"
version: "1.0.0"
description: "Code review for Helm charts — validates best practices, resource limits, probes, and security"
triggers:
  - "review"
  - "code review"
  - "helm review"
  - "chart review"
applies_to:
  languages: ["yaml", "tpl"]
  categories: ["code-review", "helm", "kubernetes"]
---

# Code Review — Helm Infrastructure

You are performing a code review for a Helm chart following Kubernetes best practices and FEMSA standards.

## Critical Checks (BLOCK if violated)

### 1. Resource Limits (MANDATORY)
- [ ] CPU requests and limits defined for ALL containers
- [ ] Memory requests and limits defined for ALL containers
- [ ] Requests ≤ limits (requests can equal limits for guaranteed QoS)
- [ ] Init containers also have resource limits
- [ ] No wildcard/unlimited resources in production values

### 2. Health Probes (MANDATORY)
- [ ] Liveness probe configured (detects hung processes)
- [ ] Readiness probe configured (prevents traffic to unready pods)
- [ ] Startup probe for slow-starting apps (optional but recommended)
- [ ] Probe paths return meaningful health status
- [ ] initialDelaySeconds appropriate for application boot time

### 3. Pod Disruption Budget
- [ ] PDB configured for production (minAvailable or maxUnavailable)
- [ ] PDB allows at least 1 pod to be evicted (avoid blocking cluster operations)
- [ ] replicas >= 2 when PDB is configured

### 4. Horizontal Pod Autoscaler
- [ ] HPA enabled for production services
- [ ] minReplicas >= 2 for production
- [ ] maxReplicas has sensible ceiling
- [ ] Target metric appropriate (CPU usually 70%)
- [ ] Does NOT conflict with replicas field in deployment

### 5. Security
- [ ] `securityContext.runAsNonRoot: true`
- [ ] `securityContext.readOnlyRootFilesystem: true` where possible
- [ ] `securityContext.allowPrivilegeEscalation: false`
- [ ] No `hostNetwork: true` without explicit approval
- [ ] No `privileged: true`
- [ ] ServiceAccount created with minimal RBAC
- [ ] No secrets in values files (use sealed-secrets or external-secrets)

### 6. Template Quality
- [ ] All templates use `{{ include "chart.fullname" . }}` for naming
- [ ] Standard labels applied (app.kubernetes.io/*)
- [ ] No hardcoded values in templates (reference .Values)
- [ ] `required` used for mandatory per-environment values
- [ ] Whitespace control (`{{-` / `-}}`) used correctly

### 7. Values Conventions
- [ ] values.yaml has sensible defaults (chart installs without overrides)
- [ ] All values documented with comments
- [ ] No secrets or credentials in any values file
- [ ] Environment-specific values only in values-{env}.yaml
- [ ] Image tag not hardcoded to "latest" in production values

### 8. Versioning
- [ ] Chart version bumped in Chart.yaml
- [ ] appVersion updated if application version changed
- [ ] Chart.lock updated if dependencies changed
- [ ] CHANGELOG entry added

## Output Format

```markdown
## Code Review — Helm Chart

**Risk Level**: LOW | MEDIUM | HIGH | CRITICAL
**Recommendation**: APPROVE | REQUEST_CHANGES | BLOCK
**Security Compliance**: PASS | FAIL

### Findings

| # | Severity | File | Line | Finding | Suggestion |
|---|----------|------|------|---------|------------|

### Kubernetes Best Practices
- Resource limits: ✅/❌
- Health probes: ✅/❌
- PDB configured: ✅/❌
- Security context: ✅/❌
- HPA (production): ✅/❌
```
