---
name: api-design
description: |
  Use when designing new API endpoints, REST routes, GraphQL schemas, or
  modifying API contracts. Activate when the user says "new endpoint",
  "design API", "REST", "contract", "schema", or is creating route handlers.
  Guides contract-first design, versioning, error semantics, and validation.
license: MIT
compatibility: Kiro, Claude Code, Copilot, Codex, Gemini CLI, Windsurf
metadata:
  author: nara-governance
  category: api-design
  trigger-type: conditional
  stack-match: express,fastapi,nestjs,django,flask,hono
---

# API Design

Contract-first API design following enterprise REST/HTTP standards.

## Process

### Step 1: Define the Contract First
- Write the endpoint signature BEFORE implementation
- Define: method, path, request body schema, response schema, error responses
- Use OpenAPI/Swagger for documentation
- Consider: who calls this? What do they need?

### Step 2: Apply REST Conventions

| Operation | Method | Path | Status |
|-----------|--------|------|--------|
| List | GET | /resources | 200 |
| Get one | GET | /resources/:id | 200, 404 |
| Create | POST | /resources | 201, 400 |
| Update (full) | PUT | /resources/:id | 200, 404 |
| Update (partial) | PATCH | /resources/:id | 200, 404 |
| Delete | DELETE | /resources/:id | 204, 404 |

### Step 3: Error Semantics
```json
{
  "error": {
    "code": "VALIDATION_FAILED",
    "message": "Human-readable description",
    "details": [
      {"field": "email", "reason": "Invalid format"}
    ],
    "trace_id": "abc-123"
  }
}
```

Standard error codes:
- 400 — Bad Request (validation failed, malformed input)
- 401 — Unauthorized (no token, expired token)
- 403 — Forbidden (valid token, insufficient permissions)
- 404 — Not Found (resource doesn't exist)
- 409 — Conflict (duplicate, state conflict)
- 422 — Unprocessable Entity (valid syntax, invalid semantics)
- 429 — Too Many Requests (rate limited)
- 500 — Internal Server Error (never expose internals)

### Step 4: Input Validation
- Validate ALL inputs (path params, query params, body, headers)
- Use schema validation (Zod, Pydantic, Joi) — not manual checks
- Reject early, fail fast
- Sanitize for injection (SQL, XSS, command)

### Step 5: Versioning & Breaking Changes
- URL prefix versioning: `/api/v1/resources`
- Breaking change = new major version
- Non-breaking: adding optional fields, new endpoints
- Breaking: removing fields, changing types, renaming paths
- Deprecation: announce 2 sprints before removal

### Step 6: Pagination & Filtering
```
GET /resources?page=1&page_size=20&sort=created_at:desc&filter[status]=active
```
Response:
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "page_size": 20,
    "total": 150,
    "total_pages": 8
  }
}
```

## Anti-Rationalization Table

| Excuse | Rebuttal |
|--------|----------|
| "I'll document the API later" | Contract-first. Document before you code. |
| "We don't need versioning yet" | You will. Add /v1/ now or pay later. |
| "Just return 500 for all errors" | Clients need actionable error codes. Be specific. |
| "Validation is overkill for internal APIs" | Internal APIs get external exposure eventually. Validate now. |
| "GraphQL solves all REST problems" | GraphQL has its own complexity. Choose based on use case, not hype. |

## Red Flags
- Endpoint returns 200 for errors (with error in body)
- No input validation on user-facing endpoint
- Response shape changes between calls (inconsistent)
- Endpoint does too many things (should be split)
- Sensitive data in URL query params (tokens, passwords)
- No pagination on list endpoints

## Verification
- [ ] Contract documented (OpenAPI or equivalent)
- [ ] All inputs validated with schema
- [ ] Error responses follow standard format
- [ ] Appropriate HTTP status codes used
- [ ] Pagination on list endpoints
- [ ] No sensitive data in URLs
- [ ] Idempotent where appropriate (PUT, DELETE)
