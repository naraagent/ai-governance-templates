---
inclusion: fileMatch
fileMatchPattern: "**/*.kt,**/build.gradle.kts"
---

# Kotlin Patterns — Android

## Hilt Dependency Injection

### Module Organization
```kotlin
@Module
@InstallIn(SingletonComponent::class)
object NetworkModule {
    @Provides
    @Singleton
    fun provideOkHttpClient(
        certificatePinner: CertificatePinner,
        authInterceptor: AuthInterceptor
    ): OkHttpClient = OkHttpClient.Builder()
        .certificatePinner(certificatePinner)
        .addInterceptor(authInterceptor)
        .connectTimeout(30, TimeUnit.SECONDS)
        .build()

    @Provides
    @Singleton
    fun provideRetrofit(okHttpClient: OkHttpClient): Retrofit =
        Retrofit.Builder()
            .baseUrl(BuildConfig.API_BASE_URL)
            .client(okHttpClient)
            .addConverterFactory(MoshiConverterFactory.create())
            .build()
}

@Module
@InstallIn(SingletonComponent::class)
abstract class RepositoryModule {
    @Binds
    abstract fun bindOrderRepository(impl: OrderRepositoryImpl): OrderRepository
}
```

### ViewModel Injection
```kotlin
@HiltViewModel
class OrderListViewModel @Inject constructor(
    private val getOrdersUseCase: GetOrdersUseCase,
    private val savedStateHandle: SavedStateHandle
) : ViewModel() { ... }
```

## Flow & StateFlow Patterns

### ViewModel State Management
```kotlin
@HiltViewModel
class OrderDetailViewModel @Inject constructor(
    private val getOrderUseCase: GetOrderUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow<OrderDetailState>(OrderDetailState.Loading)
    val uiState: StateFlow<OrderDetailState> = _uiState.asStateFlow()

    private val _events = MutableSharedFlow<OrderDetailEvent>()
    val events: SharedFlow<OrderDetailEvent> = _events.asSharedFlow()

    fun loadOrder(orderId: String) {
        viewModelScope.launch {
            getOrderUseCase(orderId)
                .onStart { _uiState.value = OrderDetailState.Loading }
                .catch { e -> _uiState.value = OrderDetailState.Error(e.toDomainError()) }
                .collect { order -> _uiState.value = OrderDetailState.Success(order) }
        }
    }
}
```

### State Sealed Classes
```kotlin
sealed interface OrderDetailState {
    object Loading : OrderDetailState
    data class Success(val order: Order) : OrderDetailState
    data class Error(val error: DomainError) : OrderDetailState
}

sealed interface OrderDetailEvent {
    data class ShowSnackbar(val message: StringResource) : OrderDetailEvent
    object NavigateBack : OrderDetailEvent
}
```

## Sealed Class Error Handling

```kotlin
sealed class DomainError {
    data class Network(val code: Int, val message: String) : DomainError()
    data class Timeout(val operation: String) : DomainError()
    data class NotFound(val resourceId: String) : DomainError()
    data class Unauthorized(val reason: String) : DomainError()
    data class Unknown(val throwable: Throwable) : DomainError()
}

// Mapping in repository
fun Throwable.toDomainError(): DomainError = when (this) {
    is HttpException -> when (code()) {
        401 -> DomainError.Unauthorized("Session expired")
        404 -> DomainError.NotFound("")
        else -> DomainError.Network(code(), message())
    }
    is SocketTimeoutException -> DomainError.Timeout("API call")
    else -> DomainError.Unknown(this)
}
```

## Compose Theming (FEMSA)

```kotlin
@Composable
fun FEMSATheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colorScheme = if (darkTheme) DarkColorScheme else LightColorScheme
    MaterialTheme(
        colorScheme = colorScheme,
        typography = FEMSATypography,
        content = content
    )
}

// Usage in screens
@Composable
fun OrderListScreen(
    viewModel: OrderListViewModel = hiltViewModel(),
    onOrderClick: (String) -> Unit
) {
    val state by viewModel.uiState.collectAsStateWithLifecycle()

    when (val current = state) {
        is OrderListState.Loading -> LoadingIndicator()
        is OrderListState.Success -> OrderList(current.orders, onOrderClick)
        is OrderListState.Error -> ErrorMessage(current.error)
    }
}
```

## Build Configuration (Kotlin DSL)

```kotlin
// app/build.gradle.kts
android {
    namespace = "com.femsa.app"
    compileSdk = 34

    defaultConfig {
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }

    buildFeatures {
        compose = true
        buildConfig = true
    }

    buildTypes {
        debug {
            buildConfigField("String", "API_BASE_URL", "\"https://dev-api.femsa.com/\"")
        }
        release {
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            buildConfigField("String", "API_BASE_URL", "\"https://api.femsa.com/\"")
        }
    }
}
```

## Testing Patterns

```kotlin
@Test
fun `should emit Success state when orders loaded`() = runTest {
    // Given
    val orders = listOf(Order(id = "1", status = "delivered"))
    coEvery { getOrdersUseCase() } returns flowOf(orders)

    // When
    viewModel.loadOrders()

    // Then
    viewModel.uiState.test {
        assertThat(awaitItem()).isEqualTo(OrderListState.Loading)
        assertThat(awaitItem()).isEqualTo(OrderListState.Success(orders))
    }
}
```
