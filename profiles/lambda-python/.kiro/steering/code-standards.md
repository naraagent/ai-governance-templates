---
inclusion: auto
---

# Code Standards — Lambda Python

## Language

- Python 3.11+, type hints on ALL functions
- Pydantic v2 for data validation
- ruff for lint/format, mypy strict for types
- structlog or aws-lambda-powertools for logging

## Architecture

- Handlers: thin entry points, delegate to services
- Services: business logic, testable
- Models: Pydantic for input/output validation
- Config: environment-based, never hardcoded

## Lambda Patterns

- Single responsibility per function
- Cold start optimized: lazy imports, minimal top-level
- Idempotent operations (DynamoDB conditional writes)
- Explicit timeout (never default 15min without reason)
- Lambda Powertools for logging, tracing, metrics

## Security

- Secrets from SSM Parameter Store / Secrets Manager
- IAM least privilege per function
- Validate ALL event payloads
- No sensitive data in CloudWatch logs
- Pin all dependencies to exact versions

## Testing

- pytest, moto for AWS mocking
- Coverage: 80%+ for handlers and services
- Event payloads in tests/events/
- conftest.py for shared fixtures

## Git

- Branch: `type/TICKET-description`
- Commit: `type(scope): description`
- PR: `TICKET-123 Description`
