# AGENTS.md — Lambda Python Serverless

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Profile: lambda-python | Org: FEMSA Digital
> Runtime: Python 3.11+ on AWS Lambda

## Identity

- Organization: FEMSA Digital
- Function type: AWS Lambda (Python 3.11+)
- Framework: AWS SAM / Serverless Framework
- Infra: Terraform or SAM templates
- Triggers: API Gateway, SQS, EventBridge, S3

## Build

```bash
pip install -r requirements.txt -r requirements-dev.txt
python -m pytest tests/ -v --cov=src --cov-report=term
python -m ruff check src/ tests/
python -m mypy src/
sam build                # SAM build (if applicable)
```

## Project Structure

```
.
├── src/
│   ├── handlers/        # Lambda handler functions
│   ├── services/        # Business logic
│   ├── models/          # Pydantic models
│   ├── utils/           # Shared utilities
│   └── config.py        # Environment-based config
├── tests/
│   ├── unit/            # Unit tests
│   ├── integration/     # Integration tests
│   └── conftest.py      # Fixtures
├── requirements.txt     # Production dependencies
├── requirements-dev.txt # Dev/test dependencies
├── template.yaml        # SAM template (if applicable)
├── pyproject.toml       # Project config + tool settings
└── Makefile             # Common commands
```

## Conventions

### Language
- Python 3.11+ minimum
- Type hints obligatory on all function signatures
- Pydantic v2 for data validation
- `ruff` for linting + formatting (replaces black + isort + flake8)
- `mypy` strict mode for type checking
- Structured logging via `structlog` or `aws_lambda_powertools`

### Lambda Patterns
- Single responsibility per function
- Handler is thin — delegates to service layer
- Cold start optimization: lazy imports, minimal top-level code
- Use Lambda Powertools for logging, tracing, metrics
- Idempotent operations (DynamoDB conditional writes)
- Timeout set explicitly (never use 15min default without reason)

### Dependencies
- Pinned to exact versions in requirements.txt
- Lambda layers for shared dependencies
- No unnecessary dependencies (minimize package size)
- Approved: boto3, pydantic, structlog, aws-lambda-powertools, httpx

### Error Handling
- Never `except: pass` or `except Exception: pass`
- Always log with context (trace_id, request_id)
- Use custom exceptions with meaningful messages
- Return proper HTTP status codes via API Gateway

### Security
- NEVER hardcode secrets — use SSM Parameter Store or Secrets Manager
- IAM roles with least privilege per function
- Input validation on every event payload
- No sensitive data in CloudWatch logs
- VPC placement only when DB access needed (adds cold start)

### Testing
- Framework: pytest
- Mocking: moto (AWS), unittest.mock
- Coverage target: 80%+ for handlers and services
- Test event payloads stored in `tests/events/`
- Every handler has corresponding test

### Branching & Commits
- Branch: `type/TICKET-descripcion-corta`
- Commits: `type(scope): descripción`

## Constraints

- Do NOT use `print()` — use structured logger
- Do NOT hardcode AWS account IDs or ARNs
- Do NOT set Lambda timeout to 15 minutes without justification
- Do NOT use synchronous invocations for long-running tasks
- Do NOT store state in `/tmp` across invocations
- Do NOT import unused libraries (increases cold start)

## Agent Autonomy

- Level: supervised
- Allowed: read, lint, test, suggest code changes, modify handler logic
- Blocked: deploy, modify IAM roles, change infrastructure
- Approval: new dependencies, infrastructure changes, IAM modifications
