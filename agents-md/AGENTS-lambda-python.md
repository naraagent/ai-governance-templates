# AGENTS.md — Lambda Python Serverless (Full Template)

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Compatible: Codex, Copilot, Cursor, Kiro, OpenClaw, Devin, Amp
> Profile: lambda-python | Org: FEMSA Digital

## Identity

- Organization: FEMSA Digital
- Function: {{FUNCTION_NAME}}
- Runtime: Python 3.11+ on AWS Lambda
- Framework: AWS SAM / Serverless Framework
- Infra: Terraform

## Build

```bash
pip install -r requirements.txt -r requirements-dev.txt
python -m ruff check src/ tests/
python -m mypy src/
```

## Test

```bash
python -m pytest tests/ -v --cov=src --cov-report=term
```

## Structure

```
src/
├── handlers/        # Lambda entry points (thin)
├── services/        # Business logic
├── models/          # Pydantic v2 models
├── utils/           # Shared utilities
└── config.py        # Env-based configuration
tests/
├── unit/
├── integration/
├── events/          # Sample event payloads
└── conftest.py
```

## Conventions

- Type hints on ALL functions
- Pydantic v2 for validation
- ruff for lint/format, mypy strict for types
- structlog or aws-lambda-powertools for logging
- Thin handlers delegating to services
- Idempotent operations
- Cold start optimized (lazy imports)

## Security

- No hardcoded secrets — SSM Parameter Store / Secrets Manager
- IAM least privilege per function
- Input validation on every event
- No sensitive data in CloudWatch logs

## Constraints

- No `print()` — structured logger only
- No hardcoded account IDs or ARNs
- No 15min timeout without justification
- No mutable default arguments
- No `except: pass`

## Agent Governance

- Mode: supervised
- Allowed: read, lint, test, modify handler/service logic
- Blocked: deploy, modify IAM, change infra
- Approval: new dependencies, IAM changes, infra modifications
