---
inclusion: fileMatch
fileMatchPattern: "**/Chart.yaml,**/values*.yaml,**/Chart.lock"
---

# Versioning — Helm Infrastructure

## Chart Version Strategy

### SemVer (Strict)
```yaml
# Chart.yaml
apiVersion: v2
name: capsula-services
version: 1.2.3        # Chart version — bump on EVERY change
appVersion: "2024.01" # Application version — aligns with release cycle
```

### When to Bump

| Action | Version Bump | Example |
|--------|-------------|---------|
| New required value in values.yaml | **MAJOR** | Adding required `ingress.host` |
| Remove template or value | **MAJOR** | Removing `configmap.yaml` |
| New optional feature/template | **MINOR** | Adding `pdb.yaml` template |
| New optional value with default | **MINOR** | Adding `autoscaling.enabled: false` |
| Fix template bug | **PATCH** | Fix `nindent` alignment |
| Update documentation | **PATCH** | README, NOTES.txt changes |
| Dependency version update | **MINOR** | Subchart version bump |

### appVersion Alignment
- `appVersion` tracks the deployed application version
- Updated when the application (not chart) releases
- Format: SemVer matching the Docker image tag
- Chart version and appVersion bump independently

## Dependency Management

### Chart.yaml Dependencies
```yaml
dependencies:
  - name: hub-backend
    version: "1.3.2"       # Pin EXACTLY
    repository: "file://./charts/hub-backend"
  - name: hub-history
    version: "1.1.0"       # Pin EXACTLY
    repository: "file://./charts/hub-history"
  - name: redis
    version: "18.3.2"      # External chart — pin exactly
    repository: "https://charts.bitnami.com/bitnami"
    condition: redis.enabled
```

### Chart.lock
- ALWAYS committed to repository (reproducible builds)
- Regenerated via `helm dependency update`
- CI validates Chart.lock matches Chart.yaml
- Never manually edit Chart.lock

### Subchart Versioning
- Each subchart has its own `Chart.yaml` with independent version
- Parent chart pins subcharts to exact versions
- Subchart version bump requires parent Chart.yaml update
- Dependency update workflow:
  1. Bump subchart version
  2. Update parent Chart.yaml dependency version
  3. Run `helm dependency update`
  4. Commit Chart.lock change
  5. Bump parent chart version (MINOR)

## Release Process

### Feature Branch → Develop
1. Make template/values changes
2. Bump chart version in Chart.yaml (MINOR or PATCH)
3. Update CHANGELOG.md
4. PR → develop (helm lint must pass)

### Develop → Staging
1. Create release branch: `release/vX.Y.Z`
2. Test with `values-staging.yaml`
3. Tag: `vX.Y.Z-rc.1`

### Staging → Production
1. Merge release branch → main
2. Tag: `vX.Y.Z`
3. Package chart: `helm package .`
4. Push to chart repository (ChartMuseum / OCI)

## Rollback Strategy

```bash
# List release history
helm history <release-name> -n <namespace>

# Rollback to previous revision
helm rollback <release-name> <revision> -n <namespace>

# Verify rollback
kubectl rollout status deployment/<app> -n <namespace>
```

### Rollback Rules
- Production: always have previous 5 revisions available
- Automated rollback if health check fails post-deploy
- Chart version does NOT decrement on rollback
- Document rollback in incident report

## Environment Value Overrides

### Promotion Pattern
```
values.yaml         → Base defaults (works for local/CI)
values-dev.yaml     → Development (relaxed limits, debug enabled)
values-staging.yaml → Staging (prod-like resources, less replicas)
values-prod.yaml    → Production (full resources, HA, HPA enabled)
```

### Override Rules
- Each environment file ONLY contains overrides (not full copy)
- Production values reviewed by Platform team
- Never copy-paste full values.yaml into environment files
- Use `--values` flag order: base loaded first, env overrides second
