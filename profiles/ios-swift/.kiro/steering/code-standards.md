---
inclusion: auto
---

# Code Standards — iOS Swift

## Language: Swift 5.9+

- iOS 15+ minimum deployment target
- Strict concurrency checking enabled
- Protocol-oriented programming preferred
- Value types (struct) over reference types (class) for data
- `let` over `var` (immutability by default)
- Async/await preferred over Combine for new code
- Guard-let for early exits — avoid deep nesting
- No force unwrapping (`!`) — use `guard let`, `if let`, or `??`

## Architecture: MVVM + Coordinator

### Layer Rules (STRICT)
```
View (SwiftUI View / UIViewController)
  ↓ observes @Published / @Observable
ViewModel (@MainActor, ObservableObject)
  ↓ calls
UseCase (business logic, protocol-based)
  ↓ calls
Repository Protocol (domain layer)
  ↓ implemented by
Repository Impl (data layer) → DataSource (API/LocalDB)
```

### Coordinator (Navigation)
```swift
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    func start()
}
```

### Violations (BLOCK)
- ❌ Business logic in View/ViewController
- ❌ UIKit imports in domain layer
- ❌ Navigation in Views/ViewModels (Coordinator handles it)
- ❌ ViewModel calling DataSource directly

## Async/Await

```swift
// Preferred pattern
@MainActor
class OrderViewModel: ObservableObject {
    @Published var state: ViewState<[Order]> = .idle

    func loadOrders() {
        state = .loading
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

### Rules
- `@MainActor` on ViewModels (no manual DispatchQueue.main)
- `Task` for launching async work from synchronous context
- `TaskGroup` for concurrent operations
- Proper cancellation handling (check `Task.isCancelled`)

## Memory Management (ARC)

- `[weak self]` in ALL closures that capture self
- `weak` for delegate properties
- Use Instruments Leaks template to verify
- Avoid retain cycles: parent owns child strongly, child references parent weakly

## Protocol-Oriented Programming

```swift
// Define behavior as protocols
protocol OrderRepository {
    func getOrders() async throws -> [Order]
    func getOrder(id: String) async throws -> Order
}

// Implementations in data layer
final class RemoteOrderRepository: OrderRepository {
    private let apiClient: APIClient
    func getOrders() async throws -> [Order] { ... }
}
```

## Error Handling

```swift
enum AppError: Error, LocalizedError {
    case network(NetworkError)
    case unauthorized
    case notFound(resource: String)
    case validation(field: String, reason: String)
    case unknown(Error)
}
```

- Typed errors (enum) over generic Error
- Localized descriptions via `LocalizedError` protocol
- Never silently catch errors — log and handle

## Security (NON-NEGOTIABLE)

- Keychain for tokens, passwords, certificates — NEVER UserDefaults
- App Transport Security (ATS) enabled (no exceptions without approval)
- Certificate pinning for API endpoints
- No NSLog/print of sensitive data
- Biometric auth (Face ID/Touch ID) for sensitive operations
- No sensitive data in app screenshots (use `applicationWillResignActive`)

## Testing

- XCTest, coverage 70%+ on domain/data
- Protocol-based mocks (no reflection mocking)
- Async test methods for async code
- Name: `test_<function>_<scenario>_<expected>`

## Git

- Branch: `type/TICKET-description`
- Commit: `type(scope): description` (Conventional Commits)
- PR: `TICKET-123 Description`, max 400 lines
