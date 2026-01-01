# Network App 📱

A comprehensive Flutter mobile application for monitoring cellular towers and network performance in real-time. Built with Clean Architecture principles, BLoC/Cubit state management, and designed for scalability and maintainability.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.9.2+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 🚀 Features

### Core Functionality
- 🗺️ **Interactive Map View** - Display nearby cellular towers on Google Maps with real-time data
- 📋 **Detailed List View** - Sorted list of towers with expandable details and ping functionality
- ⚙️ **Settings & Preferences** - Customize theme, language, and notification settings
- 🌐 **Multilingual Support** - Seamless switching between English and Arabic
- 🎨 **Theme Management** - Light, Dark, and System theme modes
- 📍 **Location Services** - Real-time user location tracking with permission handling
- 💾 **Offline Support** - Local caching with Hive for offline access
- 🔔 **Push Notifications** - Background notifications (Firebase ready)
- 📱 **Responsive Design** - Adapts to all screen sizes and orientations

### Network Monitoring
- 📊 Signal strength indicators with color-coded levels
- ⚡ Tower ping functionality with latency measurements
- 🏢 Accessible vs inaccessible tower identification
- 📡 Network type display (4G, 5G, etc.)
- 📈 Real-time network statistics
- 🔄 Auto-refresh and pull-to-refresh capabilities

### User Experience
- 🎬 Animated splash screen
- 📖 First-time user onboarding
- ✨ Loading animations with shimmer effects
- 🎯 Intuitive bottom navigation
- 🔍 Distance calculation from user location
- 💬 Helpful error messages and retry options

## 🏗️ Architecture

This project follows **Clean Architecture** with clear separation into three main layers:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│    (UI, BLoC/Cubit, Widgets)           │
├─────────────────────────────────────────┤
│          Domain Layer                   │
│  (Entities, Use Cases, Repositories)    │
├─────────────────────────────────────────┤
│           Data Layer                    │
│ (Models, Data Sources, Implementations) │
└─────────────────────────────────────────┘
```

### Key Design Patterns
- **BLoC Pattern** - Predictable state management
- **Repository Pattern** - Abstract data access
- **Dependency Injection** - GetIt for loose coupling
- **Factory Pattern** - Object creation
- **Observer Pattern** - State notifications

For detailed architecture documentation, see [ARCHITECTURE.md](ARCHITECTURE.md).

## 🛠️ Tech Stack

### Frameworks & Languages
- **Flutter** 3.9.2+ - UI framework
- **Dart** 3.9.2+ - Programming language

### State Management
- `flutter_bloc` ^8.1.3 - BLoC implementation
- `equatable` ^2.0.5 - Value equality

### Dependency Injection
- `get_it` ^7.6.4 - Service locator
- `injectable` ^2.3.2 - Code generation

### Networking & Data
- `dio` ^5.4.0 - HTTP client
- `connectivity_plus` ^5.0.2 - Network monitoring
- `hive` ^2.2.3 - NoSQL database
- `shared_preferences` ^2.2.2 - Key-value storage

### Location & Maps
- `google_maps_flutter` ^2.5.0 - Google Maps
- `geolocator` ^10.1.0 - Location services
- `permission_handler` ^11.0.1 - Runtime permissions

### UI/UX
- `flutter_screenutil` ^5.9.0 - Responsive design
- `shimmer` ^3.0.0 - Loading placeholders
- `lottie` ^2.7.0 - Animations
- `introduction_screen` ^3.1.12 - Onboarding

### Testing
- `mockito` ^5.4.4 - Mocking
- `bloc_test` ^9.1.5 - BLoC testing
- `flutter_test` - Testing framework

## 📋 Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)
- Android Studio / Xcode
- Google Maps API Key

## 🚀 Getting Started

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
   - Get your API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Add to `android/app/src/main/AndroidManifest.xml`
   - Add to iOS configuration

5. **Run the app**
   ```bash
   flutter run
   ```

For detailed setup instructions, see [SETUP.md](SETUP.md).

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/features/towers/presentation/bloc/tower_bloc_test.dart
```

## 📱 Screenshots

*Coming soon - Add your app screenshots here*

## 🗂️ Project Structure

```
lib/
├── core/                   # Core functionality
│   ├── constants/          # App constants
│   ├── error/              # Error handling
│   ├── localization/       # i18n support
│   ├── network/            # Network utilities
│   ├── theme/              # Theme configuration
│   └── widgets/            # Reusable components
├── features/               # Feature modules
│   ├── common/             # Common features
│   ├── towers/             # Tower management
│   └── settings/           # App settings
├── injection_container.dart # DI setup
└── main.dart               # App entry
```

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

See [GIT_STRATEGY.md](GIT_STRATEGY.md) for commit conventions.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Shalabi**
- GitHub: [@shalabi11](https://github.com/shalabi11)
- Repository: [network_app](https://github.com/shalabi11/network_app)

## 🙏 Acknowledgments

- Flutter & Dart teams for excellent framework and language
- Clean Architecture concepts by Uncle Bob
- BLoC pattern by Felix Angelov
- All open-source contributors

## 📚 Additional Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - Detailed architecture overview
- [SETUP.md](SETUP.md) - Complete setup and installation guide
- [GIT_STRATEGY.md](GIT_STRATEGY.md) - Git workflow and commit conventions

## 🐛 Known Issues

- Google Maps API key needs to be configured
- Some features require backend API integration
- Firebase setup required for push notifications

## 🔮 Future Enhancements

- [ ] Real API integration
- [ ] Firebase Analytics
- [ ] Advanced filtering options
- [ ] Historical data tracking
- [ ] Export reports (PDF/CSV)
- [ ] Social sharing features
- [ ] User authentication
- [ ] Favorites/bookmarks

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on [GitHub Issues](https://github.com/shalabi11/network_app/issues)
- Check [existing issues](https://github.com/shalabi11/network_app/issues) first

---

Made with ❤️ using Flutter
