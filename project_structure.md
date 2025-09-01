# 🏗️ Project Structure & Architecture

## Overview

HumsafarConnect follows a **Clean Architecture** approach with **MVVM pattern**, ensuring maintainable, testable, and scalable code. The architecture promotes separation of concerns and loose coupling between components.

## 📁 Directory Structure

```
HumsafarConnect/
├── 📱 App/
│   ├── HumsafarConnectApp.swift          # App entry point
│   └── Info.plist                        # App configuration
│
├── 📊 Models/
│   ├── Profile.swift                     # User profile data model
│   ├── SwipeAction.swift                 # Swipe action model
│   └── SwipeDirection.swift              # Swipe direction enum
│
├── 🎨 Views/
│   ├── ContentView.swift                 # Main app view
│   ├── ProfileDetailView.swift           # Profile detail screen
│   ├── Components/
│   │   ├── ProfileCard.swift             # Swipeable profile card
│   │   ├── ActionButton.swift            # Reusable action button
│   │   ├── LoadingView.swift             # Loading spinner
│   │   ├── SwipeLimitView.swift          # Swipe limit overlay
│   │   ├── MyProfileView.swift           # User's own profile
│   │   └── PurchasePopupView.swift       # Premium upgrade popup
│
├── 🔄 ViewModels/
│   └── ProfileViewModel.swift            # Profile business logic
│
├── 🧠 Business Logic/
│   ├── UseCases/
│   │   ├── ProfileUseCaseProtocol.swift  # Profile use case interface
│   │   ├── ProfileUseCase.swift          # Profile business logic
│   │   ├── SwipeUseCaseProtocol.swift    # Swipe use case interface
│   │   └── SwipeUseCase.swift            # Swipe business logic
│   │
│   └── Repositories/
│       ├── ProfileRepositoryProtocol.swift # Repository interface
│       └── ProfileRepository.swift        # Data access layer
│
├── 🌐 Infrastructure/
│   └── MockDataService.swift            # Mock data provider
│
├── 🏛️ Core/
│   ├── AppState/
│   │   └── AppStateManager.swift         # Global app state
│   │
│   └── Design/
│       └── DesignSystem.swift            # Design tokens & styles
│
└── 📦 Resources/
    ├── MockProfiles.json                # Sample profile data
    └── Assets.xcassets                  # App assets
```

## 🏛️ Architecture Layers

### 1. Presentation Layer (Views & ViewModels)

**Responsibility**: User interface and user interaction handling

#### Views
- **ContentView**: Main swipe interface coordinator
- **ProfileDetailView**: Detailed profile information display
- **Component Views**: Reusable UI components

#### ViewModels
- **ProfileViewModel**: Manages profile-related UI state
- Implements `@MainActor` for thread-safe UI updates
- Uses `@Published` properties for reactive UI binding

```swift
@MainActor
final class ProfileViewModel: ObservableObject {
    @Published private(set) var profiles: [Profile] = []
    @Published private(set) var isLoading = false
    // ...
}
```

### 2. Business Logic Layer (Use Cases)

**Responsibility**: Application-specific business rules

#### Use Cases
- **ProfileUseCase**: Profile-related business logic
- **SwipeUseCase**: Swipe functionality business rules
- Protocol-based design for testability

```swift
protocol ProfileUseCaseProtocol {
    func loadProfiles() async throws -> [Profile]
    func loadMoreProfiles() async throws -> [Profile]
}
```

### 3. Data Layer (Repositories)

**Responsibility**: Data access and management

#### Repository Pattern
- **ProfileRepository**: Abstracts data source details
- **MockDataService**: Provides mock data for development
- Protocol-based for easy testing and future API integration

```swift
protocol ProfileRepositoryProtocol {
    func fetchProfiles() async throws -> [Profile]
    func fetchMoreProfiles(offset: Int) async throws -> [Profile]
}
```

### 4. Core Layer

**Responsibility**: Shared utilities and configurations

#### Components
- **AppStateManager**: Global application state management
- **DesignSystem**: Consistent design tokens and styling
- **Extensions**: Utility extensions for common operations

## 🔄 Data Flow

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│                 │    │                  │    │                 │
│     View        │───▶│   ViewModel      │───▶│   Use Case      │
│  (SwiftUI)      │    │  (@MainActor)    │    │ (Business Logic)│
│                 │    │                  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         ▲                        ▲                        │
         │                        │                        ▼
         │              ┌──────────────────┐    ┌─────────────────┐
         │              │                  │    │                 │
         └──────────────│  @Published      │    │   Repository    │
                        │   Properties     │◀───│  (Data Access)  │
                        │                  │    │                 │
                        └──────────────────┘    └─────────────────┘
```

### Flow Description:

1. **User Interaction**: User interacts with SwiftUI Views
2. **Action Dispatch**: View calls ViewModel methods
3. **Business Logic**: ViewModel delegates to Use Cases
4. **Data Access**: Use Cases interact with Repositories
5. **State Update**: Repository returns data, Use Case processes it
6. **UI Refresh**: ViewModel updates @Published properties
7. **View Update**: SwiftUI automatically refreshes UI

## 🎯 Design Patterns Used

### 1. MVVM (Model-View-ViewModel)
- **Model**: Data structures (Profile, SwipeAction)
- **View**: SwiftUI views with minimal logic
- **ViewModel**: UI state management and business logic coordination

### 2. Repository Pattern
- Abstracts data source details
- Enables easy switching between mock data and real APIs
- Supports unit testing with mock repositories

### 3. Dependency Injection
```swift
init(profileUseCase: ProfileUseCaseProtocol, 
     swipeUseCase: SwipeUseCaseProtocol) {
    self.profileUseCase = profileUseCase
    self.swipeUseCase = swipeUseCase
}
```

### 4. Protocol-Oriented Programming
- Defines contracts for components
- Enables mocking for unit tests
- Supports flexible implementations

### 5. Observer Pattern
- SwiftUI's `@Published` and `@ObservableObject`
- Reactive UI updates
- Automatic state synchronization

## 🔧 Key Implementation Details

### Async/Await Usage
```swift
func loadProfiles() async {
    isLoading = true
    do {
        profiles = try await profileUseCase.loadProfiles()
    } catch {
        // Handle error
    }
    isLoading = false
}
```

### Environment Objects
```swift
// App level dependency injection
.environmentObject(appState)
.environmentObject(profileViewModel)
```

### Custom Modifiers
```swift
// Reusable styling
.cardStyle()
.primaryButtonStyle()
```

## 🧪 Testing Strategy

### Unit Tests
- **ViewModels**: Business logic and state management
- **Use Cases**: Business rule validation
- **Repositories**: Data access logic

### Integration Tests
- **Data Flow**: End-to-end functionality testing
- **API Integration**: Mock API response handling

### UI Tests
- **User Interactions**: Swipe gestures and navigation
- **State Changes**: UI updates based on data changes

## 🚀 Scalability Considerations

### Future Enhancements
1. **Network Layer**: Easy API integration through Repository pattern
2. **Caching Layer**: Add between Repository and Use Cases
3. **Offline Support**: Local data persistence
4. **Analytics**: Event tracking through Use Cases
5. **A/B Testing**: Configuration-driven UI changes

### Performance Optimizations
1. **Image Caching**: Implement efficient image loading
2. **Memory Management**: Proper view lifecycle handling
3. **Background Tasks**: Non-blocking data operations
4. **State Optimization**: Minimal UI update cycles

## 📖 Best Practices Implemented

### Swift 6 Concurrency
- Proper actor isolation with `@MainActor`
- Structured concurrency with async/await
- Task cancellation support

### SwiftUI Best Practices
- Minimal view state
- Proper environment object usage
- Efficient view updates

### Code Quality
- Protocol-oriented design
- Single responsibility principle
- Dependency injection
- Comprehensive error handling
- Inline documentation

---

This architecture ensures the codebase remains maintainable, testable, and ready for future enhancements while following iOS development best practices.