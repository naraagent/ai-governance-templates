---
inclusion: fileMatch
fileMatchPattern: "**/Package.swift,**/Podfile,**/Cartfile,**/*.xcodeproj/**"
---

# Dependency Management — iOS Swift

## Package Manager: SPM (Preferred)

### Rules
- Swift Package Manager is the PRIMARY dependency manager
- CocoaPods only for legacy dependencies without SPM support
- Carthage: NOT approved (discontinued)
- Pin dependencies to exact or minor version ranges

### Package.swift Best Practices
```swift
// Pin to exact version for stability
.package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.8.1"),

// OR pin to minor version (allows patch updates)
.package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.0"),

// NEVER use branch-based dependencies in production
// .package(url: "...", branch: "main")  ❌
```

### Adding a New Dependency — Checklist
1. Is there a first-party Apple framework? (Use it instead)
2. Is the library actively maintained? (commits in last 6 months)
3. Does it support SPM? (reject if CocoaPods-only without good reason)
4. What's the binary size impact?
5. Does it have known security issues?
6. Is it minimal (no massive transitive dependency tree)?
7. Does the license allow commercial use?

## Approved Dependencies

| Category | Package | Version | Notes |
|----------|---------|---------|-------|
| Networking | Alamofire | 5.8+ | Or URLSession for simple cases |
| Images | Kingfisher | 7.x | Async image loading + cache |
| Layout | SnapKit | 5.7+ | UIKit constraints (legacy) |
| Animation | Lottie | 4.x | After Effects animations |
| Analytics | Firebase | 10.x | Crashlytics + Analytics |
| Keychain | KeychainAccess | 4.2+ | Keychain wrapper |
| Lint | SwiftLint | 0.54+ | Via SPM plugin or Homebrew |

## Banned Dependencies

| Package | Reason | Alternative |
|---------|--------|-------------|
| RxSwift | Heavy, Combine exists | Combine or async/await |
| PromiseKit | Deprecated pattern | async/await |
| SwiftyJSON | Unnecessary with Codable | Codable protocol |
| Realm | Complex, heavy | CoreData or SwiftData |
| ObjectMapper | Deprecated | Codable |

## CocoaPods (Legacy Only)

If a dependency MUST use CocoaPods:
```ruby
# Podfile
platform :ios, '15.0'
use_frameworks!

target 'App' do
  pod 'SomeLegacySDK', '~> 2.0'  # Pin to minor
end
```

### Migration Plan
- All new dependencies MUST be SPM
- Existing CocoaPods dependencies: migrate to SPM when package supports it
- Track migration progress in tech-debt backlog

## Dependency Updates

- Review dependencies monthly for security patches
- `swift package update` in CI to check for available updates
- Critical CVEs: update within 48 hours
- Major version bumps: require mobile lead approval + QA cycle
- Never update dependencies before a release freeze

## Build Size Monitoring

- Track IPA size on each PR (CI step)
- Alert if binary grows > 2MB in a single PR
- Use `swift package show-dependencies` to audit tree
- Remove unused dependencies aggressively
