# AGENTS.md — iOS Swift Application

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Profile: ios-swift | Org: FEMSA Digital
> Runtime: Swift 5.9+ on iOS 15+ (Xcode 15, SPM)

## Identity

- Organization: FEMSA Digital (workspace: digitaldifarma)
- Application type: iOS native app (Swift)
- Runtime: iOS 15+ minimum deployment target
- Build: Xcode 15 + Swift Package Manager (SPM)
- Architecture: MVVM + Coordinator pattern
- UI: SwiftUI (new screens) + UIKit (legacy)
- Networking: URLSession / Alamofire
- Repos: ~3 repos (cruzverde_cliente, ecommerce-app-ios)

## Build

```bash
xcodebuild clean                     # Clean build folder
xcodebuild build -scheme App         # Build project
xcodebuild test -scheme App          # Run unit + UI tests
swift build                          # SPM build (packages)
swift test                           # SPM tests
swiftlint                            # Lint check
swiftformat --lint .                 # Format check
```

## Project Structure

```
Project/
├── App/
│   ├── AppDelegate.swift           # App lifecycle (UIKit)
│   ├── SceneDelegate.swift         # Scene management
│   └── App.swift                   # SwiftUI App entry (if SwiftUI-first)
├── Sources/
│   ├── Core/
│   │   ├── DI/                     # Dependency container
│   │   ├── Extensions/             # Swift extensions
│   │   ├── Networking/             # API client, interceptors
│   │   └── Storage/                # Keychain, UserDefaults wrappers
│   ├── Domain/
│   │   ├── Models/                 # Domain entities
│   │   ├── Repositories/           # Repository protocols
│   │   └── UseCases/               # Business logic
│   ├── Data/
│   │   ├── Repositories/           # Repository implementations
│   │   ├── DataSources/            # Remote (API) + Local (CoreData/Realm)
│   │   └── DTOs/                   # Network response models
│   ├── Presentation/
│   │   ├── Screens/                # Views organized by feature
│   │   │   ├── Home/
│   │   │   │   ├── HomeView.swift
│   │   │   │   ├── HomeViewModel.swift
│   │   │   │   └── HomeCoordinator.swift
│   │   │   └── Orders/
│   │   ├── Components/             # Reusable UI components
│   │   └── Navigation/            # App coordinator
│   └── Resources/
│       ├── Assets.xcassets
│       ├── Localizable.strings
│       └── Info.plist
├── Tests/
│   ├── UnitTests/
│   └── UITests/
├── Package.swift                    # SPM dependencies
└── .swiftlint.yml                  # SwiftLint config
```

## Conventions

### Language (Swift)
- Swift 5.9+ with strict concurrency checking
- Protocol-oriented programming preferred over class inheritance
- Value types (struct) preferred over reference types (class) for data
- `let` over `var` (immutability by default)
- Async/await over Combine for new code (Combine for reactive UI binding)
- Guard-let for early exits (avoid deep nesting)
- No force unwrapping (`!`) — use `guard let`, `if let`, or `??`

### Architecture (MVVM + Coordinator)

**Layer rules:**
```
View (SwiftUI View / UIViewController)
  → ViewModel (state management, UI logic) @Observable / ObservableObject
    → UseCase (business logic)
      → Repository Protocol (domain layer)
        → Repository Impl (data layer) → DataSource
```

**Coordinator handles navigation:**
```swift
protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}
```

- NO business logic in View/ViewController
- NO UIKit imports in domain layer
- ViewModel publishes state via `@Published` / `@Observable`
- Coordinators manage navigation flow (not Views/ViewControllers)
- Repository protocols in Domain, implementations in Data

### Async/Await Patterns
```swift
// Preferred: structured concurrency
func fetchOrders() async throws -> [Order] {
    let response = try await apiClient.request(.getOrders)
    return response.map { $0.toDomain() }
}

// ViewModel
@MainActor
class OrderListViewModel: ObservableObject {
    @Published var state: ViewState<[Order]> = .loading

    func load() {
        Task {
            do {
                let orders = try await getOrdersUseCase.execute()
                state = .loaded(orders)
            } catch {
                state = .error(error.toAppError())
            }
        }
    }
}
```

### Error Handling
```swift
enum AppError: Error, LocalizedError {
    case network(NetworkError)
    case unauthorized
    case notFound(resource: String)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .network(let error): return error.localizedDescription
        case .unauthorized: return NSLocalizedString("error.unauthorized", comment: "")
        case .notFound(let resource): return "Resource not found: \(resource)"
        case .unknown: return NSLocalizedString("error.unknown", comment: "")
        }
    }
}
```

### Memory Management
- `[weak self]` in closures that capture self (prevent retain cycles)
- Use `@MainActor` for ViewModel (no manual DispatchQueue.main)
- Instruments: check for leaks with Leaks and Allocations templates
- Avoid strong reference cycles in delegates (use `weak` keyword)

### Dependencies (SPM)
- Swift Package Manager preferred over CocoaPods
- Pin to exact versions or minor version ranges
- Minimal dependencies — prefer Apple frameworks
- Approved: Alamofire, Kingfisher, SnapKit, Lottie
- NOT approved: RxSwift (use Combine/async-await), large pods with native deps

### Branching & Git
- Format: `type/TICKET-descripcion-corta`
- Types: `feature/`, `fix/`, `hotfix/`, `release/`, `chore/`
- Integration: `develop` | Production: `main`
- Commits: `type(scope): descripción` (Conventional Commits)

### Testing
- Unit tests: XCTest + Quick/Nimble (optional)
- Async testing: use `async` test methods
- Mock: protocol-based mocking (no reflection mocking libraries)
- Coverage target: 70%+ on domain/data layers
- UI tests: XCUITest for critical flows
- Naming: `test_<function>_<scenario>_<expected>`

## Deployment

- Distribution: App Store Connect (TestFlight → App Store)
- Signing: automatic signing with Xcode Cloud or manual via CI
- Build variants: Debug, Staging, Release (schemes + configurations)
- Version: CFBundleShortVersionString (SemVer) + CFBundleVersion (build number)
- CI: Xcode Cloud or Jenkins (with Fastlane)
- Crash reporting: Firebase Crashlytics
- Analytics: Firebase Analytics + FEMSA custom events
- Review: App Store review guidelines compliance

## Constraints

- Do NOT put business logic in View/ViewController
- Do NOT force unwrap (`!`) without absolute certainty and comment
- Do NOT store secrets in UserDefaults (use Keychain)
- Do NOT disable App Transport Security (ATS) without security team approval
- Do NOT commit signing certificates, provisioning profiles, or .p12 files
- Do NOT use deprecated APIs without migration plan
- Do NOT ignore memory warnings
- Do NOT log sensitive data (tokens, PII) even in debug
- Do NOT use third-party analytics SDKs without privacy review

## Agent Autonomy

- Level: supervised
- Allowed: read files, lint (swiftlint), run unit tests, suggest code changes
- Blocked: sign app, submit to App Store, modify entitlements, access certificates
- Approval required: new dependencies (SPM), new permissions/entitlements, architecture changes, API key configuration
- Escalate to: iOS lead (architecture), Security (crypto/certificates), QA (release)
