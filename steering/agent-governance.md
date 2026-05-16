---
inclusion: auto
---

# Agent Governance — Enterprise Controls

> Applies to all AI agent interactions in FEMSA repositories.

## Autonomy Controls

### What agents CAN do (without approval)
- Read any file in the repository
- Run linters and formatters
- Run test suites
- Suggest code changes (for review)
- Create feature branches
- Generate documentation

### What agents NEED approval for
- Adding new dependencies
- Modifying database schemas
- Changing API contracts
- Altering authentication/authorization
- Modifying CI/CD pipelines

### What agents MUST NEVER do
- Deploy to any environment
- Access secrets or credentials directly
- Push to main/develop branches
- Run `terraform apply` or `terraform destroy`
- Modify production databases
- Disable security controls

## MCP Protocol Compliance (2025-06-18)

When implementing or modifying MCP tools:
- Include all 4 annotations: readOnlyHint, destructiveHint, idempotentHint, openWorldHint
- Define input_schema with Pydantic/JSON Schema
- Include allowed_roles for RBAC
- Log every execution as GovernanceAuditEvent
- Use ResilientClient for HTTP (never raw httpx)

## A2A Protocol Compliance (1.0)

When implementing agent-to-agent communication:
- Expose Agent Card at /.well-known/agent.json
- Follow task lifecycle: submitted → working → completed | failed
- Use Bearer JWT for inter-agent auth
- Support kill switch for session termination

## Observability Requirements

- All actions logged as structured JSON
- Trace ID propagated in all inter-service calls
- Circuit breaker state exposed in health endpoint
- Metrics: latency, error rate, tool usage per agent
- Never log secrets, PII, or token values
