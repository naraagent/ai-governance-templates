# helm-infra

## Commands
- Lint: `helm lint .`
- Template: `helm template . -f values.yaml`
- Template Dev: `helm template . -f values-dev.yaml`
- Dependency Update: `helm dependency update`
- Package: `helm package .`
- Unit Test: `helm unittest .`
- Validate: `kubeval <(helm template .)`

## Testing
- Run `helm lint` before marking any task as done
- Template render must succeed with all environment values files
- Validate K8s manifests with kubeval
- Chart version must be bumped in every change

## Do Not
- Do not hardcode values in templates — always reference `.Values`
- Do not deploy without resource limits defined
- Do not omit liveness/readiness probes in production
- Do not use `latest` tag in production values
- Do not set replicas < 2 in production
- Do not commit values with real secrets — use sealed-secrets or external-secrets
- Do not use privileged containers or hostNetwork
- Do not modify Chart.yaml version without CHANGELOG entry
