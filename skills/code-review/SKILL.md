---
name: code-review
description: "Use when reviewing pull requests, code changes, or when asked to check code quality. Performs automated code review following enterprise standards including security checks, architecture compliance, testing coverage, and git hygiene."
license: MIT
metadata:
  author: "nara-governance"
  category: "code-review"
  languages: "all"
---

# Code Review Skill

You are performing an automated code review following enterprise standards.

## Review Checklist

### 1. Security (CRITICAL — block if violated)
- No hardcoded secrets, tokens, or passwords
- No SQL injection vulnerabilities (string concatenation in queries)
- All external calls use HTTPS
- Input validation present on all user-facing endpoints
- No sensitive data in logs
- Dependencies pinned to exact versions

### 2. Code Quality
- TypeScript strict mode / type hints present
- No `any` types (TS) or untyped functions (Python)
- Error handling is explicit (no empty catches)
- Functions are focused (single responsibility, < 50 lines)
- DRY: no duplicated logic
- Naming is descriptive and consistent

### 3. Architecture
- Follows project structure conventions
- Business logic in services (not controllers/handlers)
- Data access in repositories (not services)
- No circular dependencies introduced
- New dependencies justified

### 4. Testing
- New business logic has corresponding tests
- Test names describe behavior
- External services mocked
- No skipped tests without justification

### 5. Git Hygiene
- Branch follows `type/TICKET-description` format
- Commits follow Conventional Commits
- PR size < 400 lines (flag if > 800)
- Single concern per PR

## Output Format

Produce a structured review with:

```markdown
## Code Review Summary

**Risk Level**: LOW | MEDIUM | HIGH | CRITICAL
**Recommendation**: APPROVE | REQUEST_CHANGES | BLOCK

### Findings

| # | Severity | File | Line | Finding | Suggestion |
|---|----------|------|------|---------|------------|
| 1 | 🔴 Critical | ... | ... | ... | ... |
| 2 | 🟡 Major | ... | ... | ... | ... |
| 3 | 🔵 Minor | ... | ... | ... | ... |

### Summary
- X critical, Y major, Z minor findings
- Key action items: ...
```
