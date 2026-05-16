# AI Agent Governance Framework — FEMSA Enterprise

> Version: 1.0.0 | Date: 2026-05-15
> Standards: AAIF AGENTS.md, MCP 2025-06-18, A2A 1.0, OpenClaw Governance, OWASP Agentic Top 10

## Overview

This framework defines how AI coding agents operate within FEMSA Digital repositories.
It implements enterprise-grade controls across autonomy, identity, access, and audit dimensions.

## Governance Principles

### 1. Supervised Autonomy
AI agents operate in **supervised mode** by default. All changes require human review before merge.
Infrastructure changes require **restricted mode** (even more limited).

| Mode | Description | Use Case |
|------|-------------|----------|
| Supervised | Agent proposes, human approves | Application code |
| Restricted | Agent reads/plans only, human executes | Infrastructure, security |
| Autopilot | Agent executes autonomously | Linting, formatting only |

### 2. Least Privilege
Agents receive only the permissions necessary for their task:
- Read: always allowed
- Lint/Test: always allowed
- Write code: allowed with review
- Deploy: NEVER without human approval
- Access secrets: NEVER directly
- Modify CI/CD: NEVER without approval

### 3. Audit Trail
Every agent action is logged:
- What was changed
- Why (linked to ticket/requirement)
- Who approved
- When it was deployed

### 4. Defense in Depth (OWASP Agentic Top 10)

| Risk | Control | Implementation |
|------|---------|----------------|
| ASI-01 Excessive Agency | RBAC per-tool | `allowed_roles` in tool definitions |
| ASI-02 Prompt Injection | Input sanitization | Validation hooks on all inputs |
| ASI-03 Supply Chain | Internal tools only | Gateway filtering, approved deps list |
| ASI-04 Tool Misuse | Governance layer | Pre-execution policy checks |
| ASI-05 Memory Poisoning | Session isolation | Per-session memory, no cross-contamination |
| ASI-06 Identity Delegation | OAuth 2.1 | Bearer JWT, no static tokens for external |
| ASI-07 Cascading Failures | Circuit breaker | Resilient clients, rate limiting |
| ASI-08 Insecure Output | Output sanitization | PII filter, content sanitizer |
| ASI-09 Missing Audit | Governance events | Every action logged with trace |
| ASI-10 Multi-Agent Trust | A2A auth | Bearer auth between agents, registration |

## Implementation Layers

### Layer 1: Repository (AGENTS.md + .kiro/)
- `AGENTS.md`: Cross-agent standard (works with all AI tools)
- `.kiro/steering/`: Kiro-specific persistent context
- `.kiro/hooks/`: Automated quality gates
- `.kiro/skills/`: On-demand specialized behaviors

### Layer 2: CI/CD (Jenkins)
- Pre-commit: lint + security scan
- PR gate: tests + coverage + security audit
- Deploy gate: human approval required
- Post-deploy: smoke tests + monitoring

### Layer 3: Runtime (MCP + A2A)
- MCP Gateway: tool filtering per agent
- RBAC: per-tool role enforcement
- Rate limiting: per-agent sliding window
- Kill switch: terminate rogue agents

### Layer 4: Observability
- Structured logging (JSON, trace_id)
- Distributed tracing (OpenTelemetry)
- Metrics (latency, errors, tool usage)
- Alerting on policy violations

## Deployment Strategy

```bash
# 1. Select profile for repository type
PROFILE=eks-nodejs  # or: frontend-react, terraform-module, lambda-python, generic

# 2. Deploy governance templates
./deploy.sh --profile $PROFILE --repo /path/to/repo

# 3. Customize AGENTS.md with service-specific details
# 4. Commit and push
git add AGENTS.md .kiro/
git commit -m "chore: add AI governance framework"
git push origin develop
```

## Rollout Plan (170 Jenkins Jobs)

| Phase | Repos | Profile | Timeline |
|-------|-------|---------|----------|
| 1 | 5 pilot repos (GCE services) | eks-nodejs | Week 1 |
| 2 | All Node.js microservices (~120) | eks-nodejs | Week 2-3 |
| 3 | Frontend repos (~20) | frontend-react | Week 3-4 |
| 4 | Terraform/infra repos (~15) | terraform-module | Week 4 |
| 5 | Lambda/Python repos (~15) | lambda-python | Week 4-5 |

## Compliance Matrix

| Standard | Status | Implementation |
|----------|--------|----------------|
| AAIF AGENTS.md | ✅ Implemented | Per-profile AGENTS.md |
| MCP 2025-06-18 | ✅ Implemented | Tool annotations, structured output |
| A2A 1.0 | ✅ Implemented | Agent cards, task lifecycle |
| OAuth 2.1 | ✅ Implemented | Bearer JWT, DCR |
| OWASP Agentic Top 10 | ✅ Implemented | All 10 risks mitigated |
| Conventional Commits | ✅ Enforced | Hooks + steering |
| FEMSA Standards | ✅ Enforced | All 8 standards incorporated |

## Ownership

- **Architecture Team**: Template maintenance, standard updates
- **DevOps Team**: CI/CD integration, deployment automation
- **Security Team**: Security scanning rules, vulnerability policies
- **Development Teams**: Profile customization per service
