# android-kotlin

## Commands
- Clean: `./gradlew clean`
- Build Debug: `./gradlew assembleDebug`
- Build Release: `./gradlew assembleRelease`
- Lint: `./gradlew ktlintCheck`
- Format: `./gradlew ktlintFormat`
- Test: `./gradlew testDebugUnitTest`
- Instrumented Test: `./gradlew connectedDebugAndroidTest`
- Static Analysis: `./gradlew detekt`

## Testing
- Run tests before marking any task as done
- New code must have corresponding unit tests (JUnit5 + MockK)
- Coverage target: 70%+ on domain and data layers
- Never test Android framework directly — test ViewModels, UseCases, Repositories
- Use Turbine for Flow testing

## Do Not
- Do not put business logic in Activity/Fragment/Composable
- Do not use `!!` (non-null assertion) without absolute certainty
- Do not block main thread (no synchronous I/O on Dispatchers.Main)
- Do not store secrets in SharedPreferences — use EncryptedSharedPreferences or Keystore
- Do not commit signing keystores or google-services.json
- Do not use `GlobalScope` for coroutines
- Do not expose MutableStateFlow outside ViewModel
- Do not add permissions without privacy review
