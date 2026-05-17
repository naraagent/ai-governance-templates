---
name: "security-scan-android"
version: "1.0.0"
description: "Security scanning for Android Kotlin apps — storage, network, components, and WebView"
triggers:
  - "security scan"
  - "vulnerability"
  - "android security"
  - "seguridad"
applies_to:
  languages: ["kotlin", "xml"]
  categories: ["security", "android", "mobile"]
---

# Security Scan — Android Kotlin

You are performing a security scan on an Android Kotlin application following OWASP Mobile Top 10 and FEMSA security standards.

## Scan Categories

### 1. Insecure Data Storage (CRITICAL)
- [ ] No secrets in plain SharedPreferences
- [ ] Sensitive data uses EncryptedSharedPreferences or Android Keystore
- [ ] No sensitive data in external storage (SD card)
- [ ] Room database encrypted for sensitive data
- [ ] No credentials in BuildConfig (use secure storage)
- [ ] Backup disabled for sensitive apps (`android:allowBackup="false"`)
- [ ] No sensitive data in app logs (release builds)

### 2. Network Security (CRITICAL)
- [ ] Certificate pinning configured (OkHttp CertificatePinner)
- [ ] No cleartext traffic allowed (`android:usesCleartextTraffic="false"`)
- [ ] Network security config present (`res/xml/network_security_config.xml`)
- [ ] No custom TrustManagers that accept all certificates
- [ ] No disabled SSL verification
- [ ] API base URLs not hardcoded (use BuildConfig per variant)

### 3. Exported Components
- [ ] Activities: no exported without `android:permission`
- [ ] Services: not exported unless intentional (with permission)
- [ ] BroadcastReceivers: use `android:exported="false"` unless needed
- [ ] ContentProviders: proper permissions, no SQL injection in URIs
- [ ] Deep links validated (no open redirect via intent-filter)

### 4. WebView Security
- [ ] JavaScript disabled by default (`setJavaScriptEnabled(false)`)
- [ ] No `addJavascriptInterface` without API 17+ `@JavascriptInterface`
- [ ] File access disabled (`setAllowFileAccess(false)`)
- [ ] Universal access from file URLs disabled
- [ ] Input validated before loading in WebView
- [ ] SSL errors NOT ignored in WebViewClient

### 5. Cryptography
- [ ] No hardcoded encryption keys
- [ ] No deprecated algorithms (MD5, SHA1 for security, DES, RC4)
- [ ] Keys stored in Android Keystore (not in code or SharedPrefs)
- [ ] Random numbers from `SecureRandom` (not `Random`)
- [ ] IV not reused for AES encryption

### 6. Code Security
- [ ] No hardcoded API keys, tokens, or passwords
- [ ] ProGuard/R8 enabled for release builds (code obfuscation)
- [ ] No debug logging in release builds (Timber with release tree)
- [ ] No `android:debuggable="true"` in release manifest
- [ ] Intent data validated before use
- [ ] No eval-like dynamic code loading

### 7. Permissions
- [ ] Only necessary permissions declared
- [ ] Dangerous permissions requested at runtime (not just manifest)
- [ ] No over-privileged permissions (e.g., READ_PHONE_STATE without need)
- [ ] Camera/Location permissions justified with privacy explanation

## Output Format

```markdown
## Security Scan Report — Android Kotlin

**Overall Risk**: LOW | MEDIUM | HIGH | CRITICAL
**OWASP Mobile Compliance**: PASS | FAIL
**Exported Components (unprotected)**: 0

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
