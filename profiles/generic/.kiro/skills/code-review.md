---
name: "code-review-generic"
version: "1.0.0"
description: "Baseline code review following enterprise standards — applicable to any language/framework"
triggers:
  - "review"
  - "code review"
  - "revisar"
  - "PR"
applies_to:
  languages: ["*"]
  categories: ["code-review", "quality"]
inclusion: auto
---

# Code Review — Generic

## Context
Universal code review checklist applicable to any repository.

## Security (CRITICAL — block if violated)
- [ ] No hardcoded secrets, tokens, or passwords
- [ ] No SQL injection patterns
- [ ] All external calls use HTTPS
- [ ] Input validation present on user-facing interfaces
- [ ] No sensitive data in logs
- [ ] Dependencies pinned (no floating versions)

## Code Quality
- [ ] Functions are focused (single responsibility)
- [ ] Error handling is explicit (no silent failures)
- [ ] Naming is descriptive and consistent
- [ ] No duplicated logic (DRY principle)
- [ ] Comments explain "why", not "what"

## Architecture
- [ ] Changes follow existing project structure
- [ ] No circular dependencies introduced
- [ ] New dependencies are justified
- [ ] Separation of concerns maintained

## Testing
- [ ] New logic has corresponding tests
- [ ] Tests are deterministic (no flaky tests)
- [ ] External services mocked in unit tests

## Git Hygiene
- [ ] Branch follows team naming convention
- [ ] Commits are atomic and descriptive
- [ ] PR is focused on a single concern
- [ ] No unrelated changes bundled

## Output
```markdown
## Code Review Summary

**Risk**: LOW | MEDIUM | HIGH
**Recommendation**: APPROVE | REQUEST_CHANGES

| # | Severity | File | Finding | Suggestion |
|---|----------|------|---------|------------|
```
