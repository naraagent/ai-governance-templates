# ios-swift

## Commands
- Build: `xcodebuild build -scheme App`
- Test: `xcodebuild test -scheme App`
- SPM Build: `swift build`
- SPM Test: `swift test`
- Lint: `swiftlint`
- Format Check: `swiftformat --lint .`

## Testing
- Run tests before marking any task as done
- New code must have corresponding unit tests (XCTest)
- Coverage target: 70%+ on domain and data layers
- Use protocol-based mocking (no reflection mocking libraries)
- UI tests (XCUITest) for critical user flows

## Do Not
- Do not put business logic in View/ViewController
- Do not force unwrap (`!`) without absolute certainty and comment
- Do not store secrets in UserDefaults — use Keychain
- Do not disable App Transport Security without security team approval
- Do not commit signing certificates, provisioning profiles, or .p12 files
- Do not use deprecated APIs without migration plan
- Do not log sensitive data (tokens, PII) even in debug
- Do not use third-party analytics SDKs without privacy review
