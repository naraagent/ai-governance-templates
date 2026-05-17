---
name: "security-scan-ios"
version: "1.0.0"
description: "Security scanning for iOS Swift apps — Keychain, ATS, certificate pinning, data protection"
triggers:
  - "security scan"
  - "vulnerability"
  - "ios security"
  - "seguridad"
applies_to:
  languages: ["swift"]
  categories: ["security", "ios", "mobile"]
---

# Security Scan — iOS Swift

You are performing a security scan on an iOS Swift application following OWASP Mobile Top 10 and FEMSA security standards.

## Scan Categories

### 1. Sensitive Data Storage (CRITICAL)
- [ ] Secrets stored in Keychain (NOT UserDefaults)
- [ ] Keychain items have appropriate access control (kSecAttrAccessibleWhenUnlockedThisDeviceOnly)
- [ ] No sensitive data in NSUserDefaults/UserDefaults
- [ ] CoreData/SQLite encrypted for sensitive data
- [ ] No sensitive data in pasteboard (UIPasteboard)
- [ ] App snapshot protection (hide content on app switch)
- [ ] Backup exclusion for sensitive files (`isExcludedFromBackup`)

### 2. Network Security (CRITICAL)
- [ ] App Transport Security (ATS) enabled (no NSAllowsArbitraryLoads)
- [ ] Certificate pinning implemented (public key or certificate)
- [ ] No custom URLSession delegate that disables SSL validation
- [ ] No `ServerTrustPolicy.disableEvaluation` usage
- [ ] API endpoints use HTTPS exclusively
- [ ] No sensitive data in URL parameters (use POST body)

### 3. Authentication & Session
- [ ] Tokens stored in Keychain (not UserDefaults)
- [ ] Token refresh logic handles expiration gracefully
- [ ] Biometric auth (Face ID/Touch ID) for sensitive operations
- [ ] Session invalidation on logout (clear Keychain items)
- [ ] No authentication bypass in debug builds

### 4. Code Security
- [ ] No hardcoded secrets, API keys, or credentials
- [ ] No sensitive data in NSLog/print statements
- [ ] ProGuard equivalent: no debug symbols in release
- [ ] No dynamic library loading from untrusted sources
- [ ] Jailbreak detection for sensitive apps (optional)

### 5. Data Protection
- [ ] Files with sensitive data use NSFileProtectionComplete
- [ ] Keychain: proper kSecAttrAccessible values
- [ ] No sensitive data in application logs
- [ ] Camera/photo access doesn't persist sensitive images without encryption
- [ ] Clipboard cleared after use for sensitive data

### 6. WebView (if used)
- [ ] WKWebView over UIWebView (deprecated)
- [ ] JavaScript disabled unless explicitly needed
- [ ] No universal links without proper validation
- [ ] Content Security Policy headers respected
- [ ] No loading of arbitrary URLs from user input

### 7. Third-Party SDKs
- [ ] Analytics SDK doesn't collect PII without consent
- [ ] Push notification payloads don't contain sensitive data
- [ ] Third-party SDKs reviewed for data collection
- [ ] No tracking without user opt-in (ATT framework)

## Output Format

```markdown
## Security Scan Report — iOS Swift

**Overall Risk**: LOW | MEDIUM | HIGH | CRITICAL
**ATS Compliance**: PASS | FAIL
**Keychain Usage**: PASS | FAIL

### Critical Findings

| # | Category | File | Line | Description | Remediation |
|---|----------|------|------|-------------|-------------|

### Storage Issues

| # | Issue | File | Fix |
|---|-------|------|-----|

### Network Issues

| # | Issue | File | Fix |
|---|-------|------|-----|

### Recommendations
1. ...
```
