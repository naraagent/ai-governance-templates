# lambda-python

## Commands
- Install: `pip install -r requirements.txt -r requirements-dev.txt`
- Test: `python -m pytest tests/ -v --cov=src --cov-report=term`
- Lint: `python -m ruff check src/ tests/`
- Type Check: `python -m mypy src/`
- Build: `sam build`

## Testing
- Run tests before marking any task as done
- New handlers and services must have corresponding tests
- Coverage target: 80%+ on handlers and services
- Mock AWS services with moto — never call real AWS in unit tests
- Test event payloads stored in `tests/events/`

## Do Not
- Do not use `print()` — use structured logger (structlog or aws_lambda_powertools)
- Do not hardcode AWS account IDs or ARNs
- Do not set Lambda timeout to 15 minutes without justification
- Do not store state in `/tmp` across invocations
- Do not import unused libraries (increases cold start)
- Do not use `except: pass` or `except Exception: pass`
- Do not hardcode secrets — use SSM Parameter Store or Secrets Manager
