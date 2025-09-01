# 🌟 HumsafarConnect - Profile Swipe iOS App

A modern iOS dating app built with SwiftUI featuring intuitive swipe gestures, detailed profile views, and a clean MVVM architecture.

![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-red.svg)

## 📱 Features

### Core Functionality
- **🔄 Swipe Gestures**: Intuitive left (pass) and right (like) swipe functionality
- **📋 Profile Details**: Comprehensive profile view with photo carousel
- **💫 Smooth Animations**: Fluid card stack animations and transitions
- **🎯 Swipe Limits**: Daily swipe limit with premium upgrade prompt

### Enhanced Features
- **📸 Photo Carousel**: Multiple photos with smooth page transitions
- **✅ Profile Verification**: Verified badge system
- **🏷️ Interest Tags**: Visual interest display with custom styling
- **📍 Location Display**: Distance-based matching
- **💬 Quick Actions**: Like, pass, and message buttons
- **🎨 Modern UI**: Glassmorphism effects and gradient backgrounds

## 🏗️ Architecture

### MVVM with Clean Architecture
```
HumsafarConnect/
├── 📁 Models/
│   ├── Profile.swift
│   ├── SwipeAction.swift
│   └── SwipeDirection.swift
├── 📁 ViewModels/
│   └── ProfileViewModel.swift
├── 📁 Views/
│   ├── ContentView.swift
│   ├── ProfileDetailView.swift
│   ├── Components/
│   │   ├── ProfileCard.swift
│   │   ├── ActionButton.swift
│   │   └── LoadingView.swift
├── 📁 Business Logic/
│   ├── UseCases/
│   │   ├── ProfileUseCase.swift
│   │   └── SwipeUseCase.swift
│   └── Repositories/
│       └── ProfileRepository.swift
├── 📁 Infrastructure/
│   └── MockDataService.swift
├── 📁 Core/
│   ├── AppState/
│   │   └── AppStateManager.swift
│   └── Design/
│       └── DesignSystem.swift
└── 📁 Resources/
    └── MockProfiles.json
```

### Key Design Patterns
- **MVVM**: Clear separation between View, ViewModel, and Model
- **Dependency Injection**: Loose coupling through protocol-based dependencies
- **Repository Pattern**: Abstracted data layer
- **Use Cases**: Business logic encapsulation
- **Observer Pattern**: Reactive UI updates with Combine

## 🚀 Technical Highlights

### Swift 6 & Concurrency
- **Structured Concurrency**: Proper async/await implementation
- **Actor Isolation**: Thread-safe data handling
- **Task Management**: Efficient asynchronous operations
- **Cancellation Support**: Proper task cleanup

### SwiftUI Best Practices
- **Environment Objects**: Shared state management
- **Custom Modifiers**: Reusable styling components
- **Animation Coordination**: Smooth state transitions
- **Memory Management**: Efficient image loading

### Code Quality
- **Protocol-Oriented Programming**: Flexible and testable architecture
- **Type Safety**: Strong typing throughout the codebase
- **Error Handling**: Comprehensive error management
- **Documentation**: Inline documentation and comments

## 📸 Screenshots

### Main Swipe Interface
<img width="350" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-02 at 01 26 57" src="https://github.com/user-attachments/assets/bd350cf8-624a-46ff-ab60-7297396b35c1" />


*Clean card stack with intuitive swipe gestures and action buttons*

### Profile Detail View
<img width="350" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-02 at 01 27 00" src="https://github.com/user-attachments/assets/d2d30580-1eda-4c99-bea8-22cc0802d904" />

*Comprehensive profile information with photo carousel and quick actions*

### Swipe Animations
<img width="350" height="991" alt="Screenshot 2025-09-02 at 1 29 50 AM" src="https://github.com/user-attachments/assets/9e231ce4-3718-4561-81ca-53f5009f5684" />
<img width="350" height="985" alt="Screenshot 2025-09-02 at 1 30 11 AM" src="https://github.com/user-attachments/assets/314f7308-d07b-478a-95f6-bab8907e810e" />

*Smooth card animations with haptic feedback*

## 🛠️ Setup Instructions

### Prerequisites
- **Xcode**: 15.0 or later
- **iOS Deployment Target**: 17.0+
- **Swift**: 6.0
- **macOS**: Ventura 13.0 or later

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/sraj2794/HumsafarConnect.git
   cd HumsafarConnect
   ```

2. **Open in Xcode**
   ```bash
   open HumsafarConnect.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `⌘ + R` to build and run

### Configuration
No additional configuration required. The app uses mock data for demonstration.

## 🎯 Usage

### Basic Operations
1. **Swipe Right**: Like a profile
2. **Swipe Left**: Pass on a profile  
3. **Tap Card**: View detailed profile
4. **Action Buttons**: Use bottom buttons for like/pass actions

### Premium Features
- **Swipe Limit**: 10 swipes per day for free users
- **Unlimited Swipes**: Available through premium upgrade

## 🏆 Evaluation Criteria Addressed

### ✅ UI/UX Quality
- Modern, intuitive interface design
- Smooth animations and transitions  
- Consistent visual hierarchy
- Responsive layout for all device sizes

### ✅ Code Architecture & Quality
- Clean MVVM architecture with proper separation of concerns
- Protocol-oriented design for testability
- Dependency injection for loose coupling
- Comprehensive error handling

### ✅ Functionality Implementation
- Fully functional swipe gestures
- Complete profile detail screens
- Proper state management
- Smooth user experience

### ✅ Creativity & Innovation
- **Glassmorphism Design**: Modern visual effects
- **Haptic Feedback**: Enhanced user interaction
- **Smart Swipe Limits**: Gamification element
- **Verification System**: Trust and safety features
- **Interest Tags**: Visual personality representation

## 🔧 Technical Implementation Details

### Swipe Gesture Implementation
```swift
// Custom swipe detection with smooth animations
private var swipeGesture: some Gesture {
    DragGesture()
        .onChanged { value in
            withAnimation(.interactiveSpring()) {
                offset = value.translation
                rotation = offset.width / 1000
            }
        }
        .onEnded { value in
            handleSwipeEnd(value: value)
        }
}
```

### Async Data Loading
```swift
// Structured concurrency for profile loading
@MainActor
func loadProfiles() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
        profiles = try await profileUseCase.loadProfiles()
    } catch {
        handleError(error)
    }
}
```

### State Management
```swift
// Reactive state updates with Combine
@Published private(set) var profiles: [Profile] = []
@Published private(set) var currentIndex = 0
@Published private(set) var isLoading = false
```

## 🚀 Future Enhancements

### Planned Features
- [ ] **Real-time Chat**: In-app messaging system
- [ ] **Push Notifications**: Match alerts and messages
- [ ] **Advanced Filters**: Age, location, interest-based filtering
- [ ] **Video Profiles**: Short video introductions
- [ ] **Social Integration**: Connect with social media accounts

### Technical Improvements
- [ ] **Core Data Integration**: Offline data persistence
- [ ] **Network Layer**: RESTful API integration
- [ ] **Unit Testing**: Comprehensive test coverage
- [ ] **UI Testing**: Automated UI test suite
- [ ] **Performance Optimization**: Image caching and memory management

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Raj Shekhar**
- GitHub: [@sraj2794](https://github.com/shekharraj2794)
- LinkedIn: [Your LinkedIn Profile](https://linkedin.com/in/raj-shekhar-ios)

## 🙏 Acknowledgments

- SwiftUI documentation and community
- iOS design guidelines and best practices
- Swift concurrency documentation
- Open source SwiftUI components and inspirations

---

**Built with ❤️ using SwiftUI and Swift 6**
