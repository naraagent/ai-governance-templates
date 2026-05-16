---
inclusion: fileMatch
fileMatchPattern: "**/*.py,**/requirements*.txt,**/pyproject.toml"
---

# Python Patterns

> Activates when working with Python files.

## Required

- Python 3.11+ minimum
- Type hints on ALL function signatures
- Pydantic v2 for data validation
- `ruff` for linting + formatting
- `mypy` strict mode for type checking
- Structured logging (`structlog` or `aws_lambda_powertools`)

## Patterns

```python
# ✅ Typed, validated, structured
from pydantic import BaseModel
import structlog

logger = structlog.get_logger()

class OrderRequest(BaseModel):
    order_id: str
    quantity: int
    product_sku: str

async def process_order(request: OrderRequest) -> OrderResponse:
    """Process a new order with validation."""
    try:
        result = await order_service.create(request)
        logger.info("order_created", order_id=result.id)
        return OrderResponse(id=result.id, status="created")
    except ValidationError as e:
        logger.warning("order_validation_failed", errors=e.errors())
        raise HTTPException(status_code=422, detail=e.errors())
    except Exception as e:
        logger.error("order_creation_failed", error=str(e))
        raise
```

## Anti-patterns (NEVER)

```python
# ❌ No type hints
def process(data):
    pass

# ❌ Silent exception swallowing
try:
    do_something()
except:
    pass

# ❌ print instead of logger
print(f"Processing {order_id}")

# ❌ Mutable default arguments
def add_item(items: list = []):
    pass

# ❌ String formatting in SQL
query = f"SELECT * FROM users WHERE id = '{user_id}'"
```

## Dependencies

- Pin exact versions in `requirements.txt`
- Use `pyproject.toml` for project metadata
- Approved: fastapi, pydantic, structlog, boto3, httpx, pytest, ruff, mypy
- Lambda: aws-lambda-powertools for logging/tracing/metrics

## Testing

- Framework: pytest
- Mocking: moto (AWS services), unittest.mock
- Coverage: 80%+ for new code
- Fixtures in `conftest.py`
- Async tests with `pytest-asyncio`
