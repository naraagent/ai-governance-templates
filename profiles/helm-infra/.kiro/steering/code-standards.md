---
inclusion: auto
---

# Code Standards — Helm Infrastructure Charts

## Language: YAML + Go Templates (Helm 3)

- YAML 1.2 compliant
- 2-space indentation (never tabs)
- Quote ambiguous values ("true", "null", "1.0", port numbers)
- Helm template functions: use `include`, `tpl`, `default`, `required`
- Go template whitespace control: `{{-` and `-}}` to trim whitespace

## values.yaml Conventions

### Structure
- Flat where possible (avoid deep nesting > 3 levels)
- Group by resource type (image, resources, probes, service, ingress)
- Document ALL values with inline comments
- Provide sensible defaults (chart works with just `helm install`)
- NEVER put secrets in values files

### Required Fields (Every Service)
```yaml
replicaCount: 2              # ALWAYS >= 2 in prod

image:
  repository: ""             # ECR repository URL
  tag: ""                    # Set by CI (git SHA)
  pullPolicy: IfNotPresent

resources:                   # ALWAYS define limits
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi

livenessProbe:              # ALWAYS configure
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 15
  periodSeconds: 20

readinessProbe:             # ALWAYS configure
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 5
  periodSeconds: 10

podDisruptionBudget:        # Required for prod
  minAvailable: 1

autoscaling:                # HPA configuration
  enabled: false            # true in prod
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilization: 70
```

## Template Helpers (_helpers.tpl)

### Standard Helpers (Required)
```yaml
{{- define "chart.name" -}}
{{- define "chart.fullname" -}}
{{- define "chart.labels" -}}
{{- define "chart.selectorLabels" -}}
{{- define "chart.serviceAccountName" -}}
```

### Best Practices
- Use `include` (not `template`) for pipelines
- `required` for values that MUST be set per environment
- `default` for optional values with safe defaults
- `toYaml | nindent N` for nested YAML blocks
- DRY: shared logic in _helpers.tpl, reused across templates

## Chart Versioning

- Chart.yaml `version`: SemVer, bump on EVERY change
- Chart.yaml `appVersion`: aligns with application version
- CHANGELOG.md: document all version changes
- Dependency versions pinned exactly in Chart.yaml

### Version Bump Rules
| Change Type | Bump | Example |
|-------------|------|---------|
| New required value | MAJOR | `1.0.0 → 2.0.0` |
| New optional template | MINOR | `1.0.0 → 1.1.0` |
| Template bug fix | PATCH | `1.0.0 → 1.0.1` |
| Documentation only | PATCH | `1.0.0 → 1.0.1` |

## Resource Naming

All resources follow:
```yaml
name: {{ include "chart.fullname" . }}
labels: {{- include "chart.labels" . | nindent 4 }}
```

Kubernetes labels (required):
- `app.kubernetes.io/name`
- `app.kubernetes.io/instance`
- `app.kubernetes.io/version`
- `app.kubernetes.io/managed-by`

## Security (NON-NEGOTIABLE)

- `securityContext.runAsNonRoot: true`
- `securityContext.readOnlyRootFilesystem: true` (where possible)
- `securityContext.allowPrivilegeEscalation: false`
- No `hostNetwork: true`
- No `privileged: true`
- Service accounts with minimal RBAC
- Network policies restrict pod-to-pod communication

## Testing

- `helm lint .` passes with no errors
- `helm template .` renders without errors for all value files
- `kubeval` validates generated manifests against K8s API
- CI runs lint + template for all values-{env}.yaml files

## Git

- Branch: `type/TICKET-description`
- Commit: `type(scope): description` (Conventional Commits)
- PR: `TICKET-123 Description`
- Chart version bumped in PR (never merged without version bump)
