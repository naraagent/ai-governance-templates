# AI Governance Templates — FEMSA Enterprise

> Templates enterprise-grade para gobernanza de agentes AI en repositorios de código.
> Basado en estándares: AGENTS.md (AAIF/Linux Foundation), MCP 2025-06-18, A2A 1.0, Kiro Steering, OpenClaw Governance.

## Estructura

```
ai-governance-templates/
├── profiles/              ← Perfiles completos por tipo de repo
│   ├── generic/           ← Para cualquier repositorio
│   ├── eks-nodejs/        ← Node.js microservices en EKS
│   ├── frontend-react/    ← React/Next.js applications
│   ├── terraform-module/  ← Infrastructure repos
│   └── lambda-python/     ← Python serverless (Lambda)
├── steering/              ← .kiro/steering/ templates
├── skills/                ← .kiro/skills/ templates
├── specs/                 ← .kiro/specs/_template/
├── hooks/                 ← .kiro/hooks/ templates
└── agents-md/             ← AGENTS.md templates
```

## Uso

### Despliegue automático (recomendado)
```bash
# Desde Jenkins pipeline con el Code Governance Agent
curl -s https://raw.githubusercontent.com/naraagent/ai-governance-templates/main/deploy.sh | bash -s -- --profile eks-nodejs --repo <repo-url>
```

### Manual
```bash
# Copiar perfil a tu repositorio
cp -r profiles/eks-nodejs/.kiro /path/to/your/repo/
cp profiles/eks-nodejs/AGENTS.md /path/to/your/repo/
```

## Perfiles disponibles

| Perfil | Target | Repos ejemplo |
|--------|--------|---------------|
| `generic` | Cualquier repo | Repos sin categoría clara |
| `eks-nodejs` | Node.js en EKS | bdi, backend_dummy, backend_totalpack, GCE services |
| `frontend-react` | React/Next.js | SPAs, dashboards, portales |
| `terraform-module` | Terraform/Terragrunt | infra repos, IaC modules |
| `lambda-python` | Python serverless | AWS Lambda functions |

## Estándares incorporados

- **FEMSA Arquitectura**: Node.js, Java, Kotlin, branching, commits, PR, seguridad, testing
- **AGENTS.md**: AAIF/Linux Foundation standard (cross-agent: Codex, Copilot, Cursor, Kiro, OpenClaw)
- **MCP 2025-06-18**: Model Context Protocol (Anthropic/AAIF)
- **A2A 1.0**: Agent-to-Agent protocol (Google/Linux Foundation)
- **Kiro Steering**: AWS Kiro IDE steering files
- **OpenClaw Governance**: Enterprise autonomy controls, RBAC, audit trails
- **OWASP Agentic Top 10**: Security mitigations for AI agents

## Environments

| Cluster | Región | Profile |
|---------|--------|---------|
| femsa-chile-cv-production | us-east-1 | eks-nodejs |
| femsa-colombia-cv-production | us-east-1 | eks-nodejs |
| femsa-fybeca-production | us-east-1 | eks-nodejs |
| femsa-mexico-production | us-east-1 | eks-nodejs |
| femsa-management-production | us-east-1 | generic |
| refill-production | us-east-1 | eks-nodejs |

## Kubernetes

- Version: 1.34
- Access Profile: Eks-Admin-Access-907220922556
- CI/CD: Jenkins (~170 jobs), Helm charts (Capsula pattern)

## Licencia

Uso interno FEMSA. No redistribuir.
