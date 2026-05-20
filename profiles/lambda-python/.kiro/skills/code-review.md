---
name: "code-review-lambda-python"
version: "1.0.0"
description: "Code review for Python Lambda functions following FEMSA and AWS serverless standards"
triggers:
  - "review"
  - "code review"
  - "revisar"
  - "PR review"
applies_to:
  languages: ["python"]
  categories: ["code-review", "serverless"]
inclusion: auto
---

# Code Review — Lambda Python

## Context
Activates when reviewing Python Lambda function code changes.

## Architecture Checks
- [ ] Handler function is thin (orchestration only, no business logic)
- [ ] Business logic in service layer (separate modules)
- [ ] No circular imports
- [ ] Layers used for shared dependencies

## Python Standards
- [ ] Type hints on all function signatures
- [ ] Pydantic v2 for input/output validation
- [ ] structlog for logging (not print() or logging.info without structure)
- [ ] async def where I/O bound (if using async runtime)
- [ ] No mutable default arguments

## Lambda-Specific
- [ ] Connection reuse outside handler (DB, HTTP clients)
- [ ] Environment variables for configuration (no hardcoded values)
- [ ] Handler returns proper API Gateway response format
- [ ] Cold start path is minimal (lazy imports for heavy deps)
- [ ] Timeout configured appropriately (not default 3s for complex ops)
- [ ] Memory sized to workload (128MB–3008MB range considered)

## Security
- [ ] No secrets in environment variables (use Secrets Manager/SSM)
- [ ] Input validation on all event fields
- [ ] IAM role follows least privilege
- [ ] No `eval()` or `exec()` on user input
- [ ] Dependencies pinned in requirements.txt

## Testing
- [ ] Unit tests for service layer
- [ ] Handler tested with mocked event/context
- [ ] External services mocked (boto3, HTTP calls)
- [ ] Coverage ≥70% for new code

## Output
```markdown
## Code Review: Lambda Python

**Risk**: LOW | MEDIUM | HIGH
**Recommendation**: APPROVE | REQUEST_CHANGES

| # | Severity | File | Finding | Suggestion |
|---|----------|------|---------|------------|
```
