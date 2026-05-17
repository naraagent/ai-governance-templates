---
name: "code-review-ios"
version: "1.0.0"
description: "Code review for iOS Swift apps — validates MVVM + Coordinator architecture and Swift conventions"
triggers:
  - "review"
  - "code review"
  - "revisar código"
  - "PR review"
applies_to:
  languages: ["swift"]
  categories: ["code-review", "ios", "architecture"]
---

# Code Review — iOS Swift

You are performing a code review for an iOS Swift application following MVVM + Coordinator and FEMSA standards.

## Critical Checks (BLOCK if violated)

### 1. Architecture Layers
- [ ] NO business logic in View/ViewController
- [ ] NO UIKit/SwiftUI imports in domain layer
- [ ] NO navigation logic in Views or ViewModels (Coordinator handles it)
- [ ] NO ViewModel calling DataSource directly (must go through Repository)
- [ ] Repository protocols in domain layer, implementations in data layer
- [ ] UseCases have single responsibility

### 2. Memory Management (ARC)
- [ ] `[weak self]` in closures that capture self
- [ ] `weak` on delegate properties
- [ ] No retain cycles (parent → strong → child, child → weak → parent)
- [ ] No strong reference to ViewController in non-UI objects
- [ ] Proper cancellation of Tasks/subscriptions on dealloc

### 3. Concurrency
- [ ] `@MainActor` on ViewModels (no manual DispatchQueue.main)
- [ ] Heavy work on background (not blocking main thread)
- [ ] Proper Task cancellation handling
- [ ] No data races (actor isolation or synchronization)
- [ ] Sendable conformance where needed

### 4. Security
- [ ] No secrets in UserDefaults (use Keychain)
- [ ] No hardcoded API keys in source
- [ ] Certificate pinning configured for network calls
- [ ] No NSLog/print with sensitive data
- [ ] ATS not disabled without security approval
- [ ] No force-unwrapping of user input

### 5. Swift Conventions
- [ ] `let` preferred over `var`
- [ ] No force unwrapping (`!`) without comment justification
- [ ] Guard-let for early returns
- [ ] Enum/sealed types for finite states
- [ ] Protocol-oriented design (dependency inversion)
- [ ] Proper access control (internal by default, expose minimally)

### 6. Navigation (Coordinator)
- [ ] New screens launched via Coordinator
- [ ] Deep links handled through Coordinator chain
- [ ] No programmatic push/present in ViewControllers directly
- [ ] Coordinator properly manages child coordinators

### 7. Testing
- [ ] New business logic has unit tests
- [ ] Protocol-based mocks (no mirror/reflection mocking)
- [ ] Async tests use `async` test methods
- [ ] Coverage >= 70% on domain/data layers

## Output Format

```markdown
## Code Review — iOS Swift

**Risk Level**: LOW | MEDIUM | HIGH | CRITICAL
**Recommendation**: APPROVE | REQUEST_CHANGES | BLOCK
**Architecture Violations**: 0/N

### Findings

| # | Severity | File | Line | Finding | Suggestion |
|---|----------|------|------|---------|------------|

### Architecture Health
- MVVM compliance: ✅/❌
- Memory safety: ✅/❌
- Navigation (Coordinator): ✅/❌
- Swift idioms: ✅/❌
```
