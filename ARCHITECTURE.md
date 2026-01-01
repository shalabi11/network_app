# Network App - Flutter Clean Architecture

A comprehensive Flutter mobile application for monitoring cellular towers and network performance, built with Clean Architecture principles and BLoC/Cubit state management.

## 🏗️ Architecture

The project follows **Clean Architecture** with clear separation of concerns:

```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App constants
│   ├── error/                      # Error handling (failures & exceptions)
│   ├── localization/               # Multilingual support
│   ├── network/                    # Network utilities
│   ├── theme/                      # Theme configuration
│   ├── usecases/                   # Base use case
│   ├── utils/                      # Utility functions & extensions
│   └── widgets/                    # Reusable UI components
│
├── features/                       # Feature modules
│   ├── common/                     # Shared features
│   │   └── presentation/           # Splash, onboarding, home
│   │
│   ├── towers/                     # Tower management feature
│   │   ├── data/                   # Data layer
│   │   │   ├── datasources/        # Remote & local data sources
│   │   │   ├── models/             # Data models
│   │   │   └── repositories/       # Repository implementations
│   │   ├── domain/                 # Domain layer
│   │   │   ├── entities/           # Business entities
│   │   │   ├── repositories/       # Repository interfaces
│   │   │   └── usecases/           # Business logic
│   │   └── presentation/           # Presentation layer
│   │       ├── bloc/               # BLoC for state management
│   │       └── screens/            # UI screens
│   │
│   └── settings/                   # Settings feature
│       └── presentation/
│           ├── cubit/              # Cubit for settings
│           └── screens/            # Settings UI
│
├── injection_container.dart        # Dependency injection setup
└── main.dart                       # App entry point
```

## ✨ Features

### Core Features
- ✅ **Clean Architecture** - Separation of domain, data, and presentation layers
- ✅ **BLoC/Cubit State Management** - Predictable state management
- ✅ **Dependency Injection** - GetIt for loose coupling
- ✅ **Responsive Design** - Adapts to all screen sizes and orientations
- ✅ **Multilingual Support** - English and Arabic languages
- ✅ **Theme Management** - Light/Dark/System theme modes

### Main Sections
1. **Map View** 🗺️
   - Display nearby cellular towers on Google Maps
   - Color-coded markers (Green: Accessible, Red: Not Accessible)
   - Interactive tower details
   - User location tracking

2. **List View** 📋
   - Sorted list of cellular towers by distance
   - Expandable tower details
   - Signal strength indicators
   - Ping functionality
   - Pull-to-refresh

3. **Settings** ⚙️
   - Theme selection (Light/Dark/System)
   - Language switching (English/Arabic)
   - Notification preferences
   - Background updates toggle

### Additional Features
- 🎨 **Splash Screen** - Branded app introduction
- 📱 **Onboarding** - First-time user guide
- 🔔 **Push Notifications** - Background alerts (ready for Firebase)
- 📍 **Location Permissions** - Runtime permission handling
- 💾 **Local Caching** - Hive for offline data
- 🌐 **Network Monitoring** - Real-time connection status
- 📊 **Network Statistics** - Signal strength, ping, speeds
- ♻️ **Reusable Components** - Modular UI widgets

## 🛠️ Technologies & Packages

### State Management
- `flutter_bloc` - BLoC pattern implementation
- `equatable` - Value equality

### Dependency Injection
- `get_it` - Service locator
- `injectable` - Code generation for DI

### Network
- `dio` - HTTP client
- `connectivity_plus` - Network connectivity
- `json_annotation` & `json_serializable` - JSON serialization

### Location & Maps
- `google_maps_flutter` - Google Maps integration
- `geolocator` - Location services
- `permission_handler` - Runtime permissions

### Local Storage
- `shared_preferences` - Simple key-value storage
- `hive` & `hive_flutter` - Fast NoSQL database

### Notifications
- `firebase_core` & `firebase_messaging` - Push notifications
- `flutter_local_notifications` - Local notifications
- `workmanager` - Background tasks

### UI/UX
- `flutter_screenutil` - Responsive design
- `shimmer` - Loading placeholders
- `lottie` - Animations
- `introduction_screen` - Onboarding

### Internationalization
- `intl` - Internationalization support

### Testing
- `mockito` - Mocking framework
- `bloc_test` - BLoC testing utilities
- `flutter_test` - Flutter testing framework

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.9.2)
- Dart SDK (>=3.9.2)
- Android Studio / Xcode
- Google Maps API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/shalabi11/network_app.git
   cd network_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Configure Google Maps API**
   - Get API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Add to `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <meta-data
         android:name="com.google.android.geo.API_KEY"
         android:value="YOUR_API_KEY_HERE"/>
     ```
   - Add to `ios/Runner/AppDelegate.swift`:
     ```swift
     GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
     ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate mocks
flutter pub run build_runner build
```

## 📱 Permissions

### Android
- `INTERNET` - Network access
- `ACCESS_FINE_LOCATION` - Precise location
- `ACCESS_COARSE_LOCATION` - Approximate location
- `ACCESS_NETWORK_STATE` - Network state
- `POST_NOTIFICATIONS` - Push notifications
- `FOREGROUND_SERVICE` - Background services

### iOS
- `NSLocationWhenInUseUsageDescription` - Location while using
- `NSLocationAlwaysAndWhenInUseUsageDescription` - Background location
- `NSUserTrackingUsageDescription` - Tracking usage

## 🎨 Design Patterns

- **Clean Architecture** - Separation of concerns
- **Repository Pattern** - Abstract data sources
- **BLoC Pattern** - Predictable state management
- **Dependency Injection** - Loose coupling
- **Factory Pattern** - Object creation
- **Observer Pattern** - State changes

## 📈 Future Enhancements

- [ ] Real API integration
- [ ] Firebase Analytics
- [ ] Crashlytics integration
- [ ] Advanced filtering & sorting
- [ ] Tower comparison feature
- [ ] Historical data tracking
- [ ] Export reports (PDF/CSV)
- [ ] Social sharing
- [ ] User authentication
- [ ] Favorites/bookmarks

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

**Shalabi**
- GitHub: [@shalabi11](https://github.com/shalabi11)
- Repository: [network_app](https://github.com/shalabi11/network_app.git)

## 🙏 Acknowledgments

- Flutter & Dart teams
- Clean Architecture by Uncle Bob
- BLoC pattern by Felix Angelov
- Flutter community

---

**Note**: Replace `YOUR_API_KEY_HERE` with actual Google Maps API keys before running the app.
