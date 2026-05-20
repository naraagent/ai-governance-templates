---
inclusion: auto
---

# Serverless Patterns — Lambda Python

## Handler Pattern

```python
# handler.py — thin orchestration
import structlog
from services.my_service import MyService

logger = structlog.get_logger()
service = MyService()  # Initialize OUTSIDE handler for connection reuse

def handler(event, context):
    """Lambda handler — validate, delegate, respond."""
    logger.info("handler_invoked", function=context.function_name)
    try:
        validated = validate_event(event)
        result = service.process(validated)
        return {"statusCode": 200, "body": json.dumps(result)}
    except ValidationError as e:
        return {"statusCode": 400, "body": json.dumps({"error": str(e)})}
    except Exception as e:
        logger.exception("handler_error", error=str(e))
        return {"statusCode": 500, "body": json.dumps({"error": "Internal error"})}
```

## Cold Start Optimization

- Heavy imports (pandas, numpy, boto3 clients) at module level
- Lazy load rarely-used modules inside functions
- Keep deployment package < 50MB (use layers for large deps)
- Use provisioned concurrency for latency-sensitive functions

## Environment Variables

- Configuration via env vars (12-factor)
- Secrets via AWS Secrets Manager or SSM Parameter Store
- Never hardcode credentials
- Use `os.environ.get("VAR", "default")` with sensible defaults

## Dependency Management

- `requirements.txt` with pinned versions (no `>=`)
- Separate `requirements-dev.txt` for test dependencies
- Use Lambda Layers for shared dependencies across functions
- `pip-audit` in CI for vulnerability scanning

## Testing

- Unit tests: pytest with mocked boto3 (moto library)
- Integration tests: localstack or real AWS (staging account)
- Handler tests: pass sample event JSON, assert response structure

## Observability

- structlog JSON for all logging
- AWS X-Ray tracing enabled via `aws_xray_sdk`
- Custom metrics via CloudWatch EMF (Embedded Metrics Format)
- Correlation ID propagated in all log entries
