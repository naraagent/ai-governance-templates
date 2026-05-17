---
name: "security-scan-helm"
version: "1.0.0"
description: "Security scanning for Helm charts — Kubernetes security context, RBAC, network policies"
triggers:
  - "security scan"
  - "vulnerability"
  - "k8s security"
  - "seguridad"
applies_to:
  languages: ["yaml", "tpl"]
  categories: ["security", "kubernetes", "helm"]
---

# Security Scan — Helm Infrastructure

You are performing a security scan on a Helm chart following Kubernetes security best practices, CIS Benchmarks, and FEMSA standards.

## Scan Categories

### 1. Container Security Context (CRITICAL)
- [ ] `runAsNonRoot: true` — never run containers as root
- [ ] `readOnlyRootFilesystem: true` — prevent runtime file modification
- [ ] `allowPrivilegeEscalation: false` — block privilege escalation
- [ ] `capabilities.drop: ["ALL"]` — drop all Linux capabilities
- [ ] Only add specific capabilities if absolutely needed
- [ ] `runAsUser` set to non-zero value (explicit non-root UID)
- [ ] `runAsGroup` set appropriately

### 2. Privileged Mode (CRITICAL — BLOCK)
- [ ] NO `privileged: true` in any container
- [ ] NO `hostNetwork: true` (exposes host network stack)
- [ ] NO `hostPID: true` (access to host processes)
- [ ] NO `hostIPC: true` (access to host IPC)
- [ ] NO `hostPath` volumes (except for specific infra pods with approval)

### 3. RBAC (Role-Based Access Control)
- [ ] ServiceAccount created per service (not default)
- [ ] Role/ClusterRole has minimal permissions
- [ ] No `*` verbs on resources (use specific: get, list, watch)
- [ ] No `*` on resource types (specify exact resources)
- [ ] Prefer Role over ClusterRole (namespace-scoped)
- [ ] RoleBinding scoped to specific namespace

### 4. Network Policies
- [ ] NetworkPolicy defined (default deny ingress/egress recommended)
- [ ] Pods can only communicate with required services
- [ ] Egress restricted to required endpoints
- [ ] No policy allowing all traffic (`{}` podSelector with no rules)

### 5. Secrets Management
- [ ] NO secrets in values.yaml or values-*.yaml files
- [ ] Secrets use sealed-secrets, external-secrets, or CSI driver
- [ ] `envFrom` references Kubernetes Secret (not ConfigMap for sensitive data)
- [ ] Secret names follow naming convention
- [ ] No base64-encoded secrets directly in templates

### 6. Image Security
- [ ] Image pulled from approved registry (ECR)
- [ ] No `latest` tag in production
- [ ] `imagePullPolicy: IfNotPresent` or `Always` for mutable tags
- [ ] Image digest pinning for critical production services (optional)

### 7. Resource Safety
- [ ] Resource limits prevent noisy neighbor (CPU + memory)
- [ ] No unbounded resource usage
- [ ] Ephemeral storage limits set if applicable
- [ ] PriorityClass set for critical services

## Output Format

```markdown
## Security Scan Report — Helm Chart

**Overall Risk**: LOW | MEDIUM | HIGH | CRITICAL
**CIS Benchmark Compliance**: X/Y checks passing
**Security Context**: PASS | FAIL

### Critical Findings

| # | Category | File | Line | Description | Remediation |
|---|----------|------|------|-------------|-------------|

### Privileged Containers

| # | Container | Issue | Required Action |
|---|-----------|-------|-----------------|

### RBAC Issues

| # | Resource | Issue | Recommended Fix |
|---|----------|-------|-----------------|

### Recommendations
1. ...
```
