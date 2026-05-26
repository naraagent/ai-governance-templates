---
name: test-strategy
description: |
  Use when adding tests, deciding what to test, choosing test frameworks,
  or when the user asks "what should I test", "add tests", "improve coverage",
  or "write tests for this". Guides test pyramid decisions, coverage strategy,
  and framework selection. Activate for any testing-related task beyond trivial
  single-assertion additions.
license: MIT
compatibility: Kiro, Claude Code, Copilot, Codex, Gemini CLI, Windsurf
metadata:
  author: nara-governance
  category: testing
  trigger-type: universal
---

# Test Strategy

Guides what to test, how much, and which framework patterns to use.

## Process

### Step 1: Classify the Change
- **Pure logic** (calculations, transformations, validators) → unit test
- **Integration point** (DB, API, external service) → integration test with mocks
- **User flow** (multi-step interaction, full page) → E2E test (only critical paths)
- **Configuration** (env vars, feature flags) → validation test

### Step 2: Apply the Test Pyramid (80/15/5)
```
        ╱╲
       ╱E2E╲         5% — Critical happy paths only
      ╱──────╲
     ╱Integration╲   15% — Service boundaries, API contracts
    ╱──────────────╲
   ╱   Unit Tests    ╲  80% — Fast, isolated, deterministic
  ╱════════════════════╲
```

### Step 3: Decide What to Test
**ALWAYS test:**
- Business rules and domain logic
- Edge cases (null, empty, overflow, boundary values)
- Error paths (what happens when it fails?)
- Security-sensitive operations (auth, permissions, input validation)

**SKIP testing:**
- Framework boilerplate (constructors, getters/setters)
- Third-party library internals
- Implementation details (private methods, internal state)
- Trivial pass-through functions

### Step 4: Write Tests That Describe Behavior
- Name: `should <behavior> when <condition>`
- Arrange → Act → Assert (one assertion per behavior)
- Test the WHAT, not the HOW
- If a refactor breaks the test but not the behavior → bad test

### Step 5: Framework Selection (by stack)

| Stack | Unit | Integration | E2E |
|-------|------|-------------|-----|
| Node/TS | Vitest or Jest | supertest + testcontainers | Playwright |
| Python | pytest | pytest + moto/testcontainers | pytest + httpx |
| React/Next | Vitest + RTL | MSW (mock service worker) | Playwright |
| Android | JUnit5 + MockK | Espresso | — |
| iOS | XCTest | XCUITest | — |
| Terraform | `terraform validate` | Terratest (Go) | — |

### Step 6: Coverage Approach
- Target: 70-80% on NEW code (not retroactive blanket coverage)
- Focus coverage on: domain logic, error paths, security
- Low-value coverage: UI styling, framework glue, config loading
- Use coverage as a signal, not a goal — 100% coverage ≠ good tests

## Anti-Rationalization Table

| Excuse | Rebuttal |
|--------|----------|
| "I'll add tests later" | Tests written after are less effective. Write them with the code. |
| "It's too simple to test" | Simple functions are the easiest to test. Do it now. |
| "Mocking is too complex" | If mocking is hard, your design has too many dependencies. Refactor. |
| "E2E tests are enough" | E2E tests are slow, flaky, and don't pinpoint failures. Unit first. |
| "The code is just a wrapper" | Wrappers break too. Test the contract, not the implementation. |
| "100% coverage required" | Coverage is a signal, not a target. Test behavior, not lines. |

## Red Flags
- Test name is "test1", "testFunction", or describes implementation
- Test has no assertions
- Test depends on execution order of other tests
- Test calls real external services (DB, API, S3)
- Test takes > 5 seconds to run
- Multiple tests break when one unrelated thing changes (fragile tests)

## Verification
- [ ] Tests cover the behavior described in requirements
- [ ] Tests run in < 10 seconds (unit) or < 60 seconds (integration)
- [ ] Tests are independent (can run in any order)
- [ ] Tests have descriptive names (behavior + condition)
- [ ] No real external calls in unit tests
- [ ] Coverage increased for the changed code
