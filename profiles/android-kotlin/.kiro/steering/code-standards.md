---
inclusion: auto
---

# Code Standards — Android Kotlin

## Language: Kotlin

- Kotlin 1.9+ with Android SDK (min API 24, target API 34)
- `val` over `var` (immutability by default)
- Sealed classes for state and error handling
- Data classes for DTOs and value objects
- Extension functions for utility logic
- Coroutines for all async operations — NEVER raw Thread/AsyncTask
- Avoid `!!` — use safe calls, elvis, or explicit null checks

## Architecture: MVVM + Clean Architecture

### Layer Rules (STRICT)
```
UI Layer (Composable/Activity/Fragment)
  ↓ observes StateFlow
ViewModel (UI logic, state management)
  ↓ calls
UseCase (business logic, single responsibility)
  ↓ calls
Repository Interface (domain layer, abstracts data)
  ↓ implemented by
Repository Impl (data layer) → DataSource (API/DB)
```

### Violations (BLOCK)
- ❌ Business logic in Activity/Fragment/Composable
- ❌ Android imports in domain layer (domain is pure Kotlin)
- ❌ ViewModel calling DataSource directly (bypass Repository)
- ❌ UI layer importing from data layer directly

## Dependency Injection (Hilt)

- `@HiltAndroidApp` on Application class
- `@AndroidEntryPoint` on Activities/Fragments
- `@HiltViewModel` on ViewModels
- Modules organized: NetworkModule, DatabaseModule, RepositoryModule
- Scopes: `@Singleton` for app-wide, `@ViewModelScoped` for VM-scoped

## Coroutines & Flow

```kotlin
// ViewModel exposes StateFlow
private val _state = MutableStateFlow<UiState>(UiState.Loading)
val state: StateFlow<UiState> = _state.asStateFlow()

// UseCase returns Flow
class GetOrdersUseCase @Inject constructor(
    private val repository: OrderRepository
) {
    operator fun invoke(userId: String): Flow<List<Order>> =
        repository.getOrders(userId)
}
```

### Rules
- `viewModelScope` for ViewModel coroutines
- `flowOn(Dispatchers.IO)` for I/O operations
- NEVER use `GlobalScope`
- NEVER block main thread
- Cancel coroutines properly (structured concurrency)
- Use `Turbine` for testing Flows

## Compose Patterns

```kotlin
// Stateless composable (state hoisting)
@Composable
fun OrderCard(
    order: Order,
    onOrderClick: (String) -> Unit,
    modifier: Modifier = Modifier
) { ... }

// Preview
@Preview(showBackground = true)
@Composable
private fun OrderCardPreview() {
    FEMSATheme { OrderCard(sampleOrder, {}) }
}
```

### Rules
- Composables are stateless (state hoisted to ViewModel)
- Side effects in `LaunchedEffect`, `SideEffect`, `DisposableEffect`
- Material 3 theming (FEMSATheme)
- Navigation: type-safe routes with Compose Navigation
- Accessibility: contentDescription on images, semantic properties

## Error Handling

```kotlin
sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val exception: DomainException) : Result<Nothing>()
    object Loading : Result<Nothing>()
}
```

- Sealed class Result pattern for all repository returns
- Network errors → DomainException mapping in repository
- User-facing messages via `strings.xml` (localized)
- Never swallow exceptions — log and propagate

## Security (NON-NEGOTIABLE)

- Secrets: EncryptedSharedPreferences or Android Keystore
- NEVER store tokens/keys in plain SharedPreferences
- Certificate pinning for API calls (OkHttp CertificatePinner)
- No exported components without permission declarations
- WebView: JavaScript disabled unless explicitly required
- No sensitive data in logs (filter in release builds)

## Testing

- JUnit5 + MockK + Turbine (Flow testing)
- Coverage 70%+ on domain and data layers
- NO testing Android framework directly
- Name: `should [behavior] when [condition]`

## Git

- Branch: `type/TICKET-description`
- Commit: `type(scope): description` (Conventional Commits)
- PR: `TICKET-123 Description`, max 400 lines
