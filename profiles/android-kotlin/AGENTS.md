# AGENTS.md — Android Kotlin Application

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Profile: android-kotlin | Org: FEMSA Digital
> Runtime: Kotlin on Android (min API 24, target API 34)

## Identity

- Organization: FEMSA Digital (workspace: digitaldifarma)
- Application type: Android native app (Kotlin)
- Runtime: Android (min SDK 24 / Android 7.0, target SDK 34)
- Build: Gradle (Kotlin DSL)
- Architecture: MVVM + Clean Architecture
- UI: Jetpack Compose (new screens) + View System (legacy)
- DI: Hilt (Dagger under the hood)
- Repos: ~10 repos (omniapp, picker-app-lite, maicao-lite, cruzverde)

## Build

```bash
./gradlew clean                    # Clean build
./gradlew assembleDebug           # Debug APK
./gradlew assembleRelease         # Release APK (signed)
./gradlew ktlintCheck             # Kotlin lint check
./gradlew ktlintFormat            # Auto-format
./gradlew testDebugUnitTest       # Unit tests
./gradlew connectedDebugAndroidTest  # Instrumented tests
./gradlew lint                    # Android lint
./gradlew detekt                  # Static analysis
```

## Project Structure

```
app/
├── src/
│   ├── main/
│   │   ├── kotlin/com/femsa/{app}/
│   │   │   ├── di/              # Hilt modules
│   │   │   ├── data/            # Repositories impl, DataSources
│   │   │   │   ├── remote/      # API services (Retrofit)
│   │   │   │   ├── local/       # Room DB, SharedPrefs
│   │   │   │   └── repository/  # Repository implementations
│   │   │   ├── domain/          # Use cases, entities, repository interfaces
│   │   │   │   ├── model/       # Domain entities
│   │   │   │   ├── repository/  # Repository interfaces
│   │   │   │   └── usecase/     # Use cases
│   │   │   ├── presentation/    # UI layer
│   │   │   │   ├── screens/     # Compose screens
│   │   │   │   ├── viewmodels/  # ViewModels
│   │   │   │   ├── components/  # Reusable composables
│   │   │   │   └── navigation/  # Nav graph
│   │   │   └── core/            # Extensions, constants, utils
│   │   ├── res/                 # Resources (layouts, strings, drawables)
│   │   └── AndroidManifest.xml
│   ├── test/                    # Unit tests
│   └── androidTest/             # Instrumented tests
├── build.gradle.kts             # App module config
├── proguard-rules.pro           # ProGuard/R8 rules
build.gradle.kts                 # Root project config
settings.gradle.kts              # Module settings
gradle.properties                # Gradle/JVM properties
```

## Conventions

### Language (Kotlin)
- Kotlin 1.9+ with explicit API mode for library modules
- `val` over `var` (immutability by default)
- Sealed classes for exhaustive state handling
- Data classes for DTOs and value objects
- Extension functions for utility logic
- Coroutines for all async operations — NEVER raw Thread or AsyncTask
- Nullability: leverage Kotlin null-safety, avoid `!!` operator

### Architecture (MVVM + Clean Architecture)

**Layer rules:**
```
UI (Composable/Activity/Fragment)
  → ViewModel (state management, UI logic)
    → UseCase (business logic, single responsibility)
      → Repository interface (domain layer)
        → Repository impl (data layer) → DataSource (remote/local)
```

- NO business logic in Activity/Fragment/Composable
- NO Android framework imports in domain layer
- ViewModels expose StateFlow (not LiveData for new code)
- UseCases are single-responsibility (`invoke` operator)
- Repositories hide data source implementation details

### Dependency Injection (Hilt)
```kotlin
@HiltAndroidApp class App : Application()
@AndroidEntryPoint class MainActivity : ComponentActivity()

@Module @InstallIn(SingletonComponent::class)
object NetworkModule {
    @Provides @Singleton
    fun provideRetrofit(): Retrofit = ...
}
```

### Coroutines & Flow
- `viewModelScope` for ViewModel coroutines
- `StateFlow` for UI state, `SharedFlow` for events
- `flowOn(Dispatchers.IO)` for data operations
- NEVER use `GlobalScope`
- NEVER block main thread (suspend functions for I/O)

### Compose UI
- Stateless composables (state hoisting)
- Preview annotations for all custom composables
- Material 3 theming system
- No side effects without `LaunchedEffect` / `SideEffect`
- Navigation: Compose Navigation (type-safe routes)

### Error Handling
- Sealed class for Result: `Success<T>`, `Error(exception)`, `Loading`
- Never swallow exceptions (log + propagate)
- Network errors wrapped in domain exceptions
- User-facing errors localized (strings.xml)

### Branching & Git
- Format: `type/TICKET-descripcion-corta`
- Types: `feature/`, `fix/`, `hotfix/`, `release/`, `chore/`
- Integration: `develop` | Production: `main`
- Commits: `type(scope): descripción` (Conventional Commits)

### Testing
- Unit tests: JUnit5 + MockK + Turbine (Flow testing)
- UI tests: Compose Testing + Espresso (legacy views)
- Coverage target: 70%+ on domain/data layers
- Naming: `should <behavior> when <condition>`
- NEVER test Android framework (test ViewModels, UseCases, Repositories)

## Deployment

- Distribution: Google Play Store (internal track → alpha → beta → production)
- Signing: Keystore in CI secrets (NEVER in repo)
- Build variants: debug, staging, release
- ProGuard/R8: enabled for release builds
- Version: `versionCode` auto-incremented in CI, `versionName` follows SemVer
- CI: Jenkins (or Bitrise/GitHub Actions) — lint → test → build → distribute
- Crash reporting: Firebase Crashlytics
- Analytics: Firebase Analytics + FEMSA custom events

## Constraints

- Do NOT put business logic in Activity/Fragment/Composable
- Do NOT use `!!` (non-null assertion) without absolute certainty
- Do NOT block main thread (no synchronous I/O on Dispatchers.Main)
- Do NOT store secrets in SharedPreferences (use EncryptedSharedPreferences or Keystore)
- Do NOT commit signing keystores or google-services.json
- Do NOT use deprecated APIs without migration plan
- Do NOT add permissions without privacy review
- Do NOT use `GlobalScope` for coroutines
- Do NOT expose MutableStateFlow outside ViewModel

## Agent Autonomy

- Level: supervised
- Allowed: read files, lint (ktlint/detekt), run unit tests, suggest code changes
- Blocked: sign APK, publish to Play Store, modify ProGuard rules, access Firebase console
- Approval required: new permissions, new dependencies, architecture layer violations, API key configuration
- Escalate to: Mobile lead (architecture), Security (permissions/crypto), QA (release)
