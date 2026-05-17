# AGENTS.md — Helm Infrastructure Chart

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Profile: helm-infra | Org: FEMSA Digital
> Runtime: Helm 3 on Kubernetes 1.34 (Capsula Chart Pattern)

## Identity

- Organization: FEMSA Digital (workspace: digitaldifarma)
- Resource type: Helm chart infrastructure (Kubernetes manifests)
- Runtime: Kubernetes 1.34 (EKS)
- Tooling: Helm 3, kubectl, helmfile
- Pattern: Capsula chart structure (parent chart + subcharts per service)
- Environments: develop, staging, production (values per env)
- Repos: ~2 repos (capsula-infra, capsula-charts)

## Build

```bash
helm lint .                           # Validate chart syntax
helm template . -f values.yaml        # Render templates locally
helm template . -f values-dev.yaml    # Render with dev values
helm dependency update                # Update subchart dependencies
helm package .                        # Package chart for distribution
helm unittest .                       # Run helm-unittest (if configured)
kubeval <(helm template .)            # Validate K8s manifests
```

## Project Structure

```
capsula-charts/
├── Chart.yaml                    # Parent chart metadata
├── Chart.lock                    # Dependency lock file
├── values.yaml                   # Default values (base)
├── values-dev.yaml              # Development overrides
├── values-staging.yaml          # Staging overrides
├── values-prod.yaml             # Production overrides
├── templates/
│   ├── _helpers.tpl             # Template helper functions
│   ├── NOTES.txt                # Post-install notes
│   └── tests/                   # Helm test manifests
├── charts/                       # Subcharts (per service)
│   ├── hub-backend/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/
│   │       ├── deployment.yaml
│   │       ├── service.yaml
│   │       ├── hpa.yaml
│   │       ├── pdb.yaml
│   │       └── ingress.yaml
│   ├── hub-history/
│   │   └── ...
│   └── hub-engine/
│       └── ...
├── ci/                           # CI test values
│   ├── test-values.yaml
│   └── lint-values.yaml
└── README.md                     # Chart documentation
```

## Conventions

### YAML Formatting
- 2-space indentation (never tabs)
- Quoted strings for values that could be misinterpreted (e.g., "true", "null", "1.0")
- Comments for non-obvious values
- One blank line between top-level sections
- No trailing whitespace

### values.yaml Conventions
```yaml
# Flat structure with clear naming
replicaCount: 2
image:
  repository: 123456789.dkr.ecr.us-east-1.amazonaws.com/service-name
  tag: "latest"  # Overridden by CI
  pullPolicy: IfNotPresent

# Resources always defined
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi

# Probes always configured
livenessProbe:
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 15
  periodSeconds: 20

readinessProbe:
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 5
  periodSeconds: 10
```

### Template Helpers (_helpers.tpl)
```yaml
{{- define "app.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "app.labels" -}}
helm.sh/chart: {{ include "app.chart" . }}
app.kubernetes.io/name: {{ include "app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
```

### Chart Versioning (SemVer)
- `version` in Chart.yaml: chart version (bump on template changes)
- `appVersion` in Chart.yaml: application version (image tag)
- MAJOR: breaking changes (new required values, removed templates)
- MINOR: new features (new optional values, new templates)
- PATCH: bug fixes (template fixes, documentation)

### Resource Naming
- All resources use `{{ include "app.fullname" . }}` for naming
- Labels follow K8s best practices (app.kubernetes.io/*)
- Annotations for metadata (prometheus scraping, ingress class, etc.)
- Consistent naming across all environments

### Dependency Lock
- `Chart.lock` committed to repo (reproducible builds)
- `helm dependency update` when adding/updating subcharts
- Pin subchart versions exactly (`version: "1.2.3"`, not `~1.2.0`)

### Branching & Git
- Format: `type/TICKET-descripcion-corta`
- Types: `feature/`, `fix/`, `hotfix/`, `release/`, `chore/`
- Integration: `develop` | Production: `main`
- Commits: `type(scope): descripción` (Conventional Commits)
- Chart version bumped in EVERY commit

## Deployment

- Method: Helm upgrade/install via Jenkins pipeline
- Strategy: Rolling update (maxSurge: 1, maxUnavailable: 0)
- Environments: dev → staging → prod (values override per env)
- Approval: production deployments require manual approval gate
- Rollback: `helm rollback <release> <revision>` on failure
- Canary: supported via Argo Rollouts (optional, advanced)
- Monitoring: post-deploy health check (wait for all pods ready)

## Constraints

- Do NOT hardcode values in templates (always reference `.Values`)
- Do NOT deploy without resource limits defined
- Do NOT omit liveness/readiness probes in production
- Do NOT use `latest` tag in production values
- Do NOT set replicas < 2 in production
- Do NOT expose services without ingress auth or network policy
- Do NOT modify Chart.yaml version without corresponding CHANGELOG entry
- Do NOT commit values with real secrets (use sealed-secrets or external-secrets)
- Do NOT use privileged containers or hostNetwork
- Do NOT skip PodDisruptionBudget for production services

## Agent Autonomy

- Level: supervised
- Allowed: read charts, lint (helm lint), template render, suggest changes
- Blocked: helm upgrade/install (deploy), modify production values, create namespaces
- Approval required: chart version bump, new subchart, resource limit changes, security context modifications
- Escalate to: Platform team (infra changes), Security (RBAC/network policies), SRE (production deploys)
