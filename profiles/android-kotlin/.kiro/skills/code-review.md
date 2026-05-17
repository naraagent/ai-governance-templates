---
name: "code-review-android"
version: "1.0.0"
description: "Code review for Android Kotlin apps — validates MVVM architecture layers and Kotlin conventions"
triggers:
  - "review"
  - "code review"
  - "revisar código"
  - "PR review"
applies_to:
  languages: ["kotlin"]
  categories: ["code-review", "android", "architecture"]
---

# Code Review — Android Kotlin

You are performing a code review for an Android Kotlin application following MVVM + Clean Architecture and FEMSA standards.

## Critical Checks (BLOCK if violated)

### 1. Architecture Layers
- [ ] NO business logic in Activity/Fragment/Composable (UI layer)
- [ ] NO Android framework imports in domain layer (pure Kotlin)
- [ ] NO ViewModel calling DataSource directly (must go through Repository)
- [ ] NO UI layer importing directly from data layer
- [ ] UseCases have single responsibility (one public `invoke` method)
- [ ] Repository implementations in data layer, interfaces in domain layer

### 2. Thread Safety
- [ ] NO blocking calls on Main/UI thread
- [ ] Coroutines use appropriate dispatchers (IO for network/disk)
- [ ] NO GlobalScope usage
- [ ] StateFlow/SharedFlow properly scoped to ViewModel lifecycle
- [ ] Background work cancels with lifecycle (structured concurrency)

### 3. Dependency Injection
- [ ] All dependencies injected via Hilt (no manual instantiation of services)
- [ ] Correct Hilt scopes (@Singleton, @ViewModelScoped, @ActivityScoped)
- [ ] Modules properly organized (Network, Database, Repository)
- [ ] No circular dependencies

### 4. Security
- [ ] No secrets in SharedPreferences (use EncryptedSharedPreferences/Keystore)
- [ ] No hardcoded API keys in source code
- [ ] Certificate pinning configured for Retrofit/OkHttp
- [ ] No exported components without permission requirements
- [ ] WebView: JavaScript disabled unless required + validated
- [ ] No sensitive data in Android logs (release builds)

### 5. Kotlin Conventions
- [ ] `val` preferred over `var`
- [ ] No `!!` without explicit justification
- [ ] Sealed classes for exhaustive when expressions
- [ ] Data classes for DTOs/value objects
- [ ] Extension functions where appropriate
- [ ] Coroutines over callbacks

### 6. Compose (if applicable)
- [ ] Composables are stateless (state hoisted to ViewModel)
- [ ] No side effects without proper Effect handlers
- [ ] Preview annotations on custom composables
- [ ] Accessibility: contentDescription on images/icons
- [ ] Proper use of remember/rememberSaveable

### 7. Testing
- [ ] New business logic has unit tests
- [ ] ViewModels tested with Turbine for Flow assertions
- [ ] MockK for mocking (not Mockito)
- [ ] No Android framework in unit tests (pure Kotlin)
- [ ] Coverage >= 70% on changed domain/data code

## Output Format

```markdown
## Code Review — Android Kotlin

**Risk Level**: LOW | MEDIUM | HIGH | CRITICAL
**Recommendation**: APPROVE | REQUEST_CHANGES | BLOCK
**Architecture Violations**: 0/N

### Findings

| # | Severity | File | Line | Finding | Suggestion |
|---|----------|------|------|---------|------------|

### Architecture Health
- Layer compliance: ✅/❌
- Thread safety: ✅/❌
- DI correctness: ✅/❌
- Kotlin idioms: ✅/❌
```
