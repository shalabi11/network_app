# Network App - Setup Guide

## Quick Start Guide

This guide will help you set up and run the Network App on your local machine.

## Prerequisites

1. **Flutter SDK** (3.9.2 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **IDE** (Choose one)
   - Android Studio (recommended)
   - VS Code with Flutter extension
   - IntelliJ IDEA

3. **Platforms**
   - For Android: Android Studio with Android SDK
   - For iOS: Xcode (Mac only)

## Setup Steps

### 1. Clone the Repository
```bash
git clone https://github.com/shalabi11/network_app.git
cd network_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Code
The app uses code generation for JSON serialization, dependency injection, and mocks.

```bash
# Generate all required code
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch for changes (useful during development)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. Configure Google Maps API

#### Get API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable "Maps SDK for Android" and "Maps SDK for iOS"
4. Create credentials (API Key)
5. Restrict the API key (recommended for production)

#### Android Configuration
Edit `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
```

#### iOS Configuration
1. Edit `ios/Runner/AppDelegate.swift`
2. Add import: `import GoogleMaps`
3. In `application:didFinishLaunchingWithOptions:`, add:
```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")
```

### 5. Run the App

#### Using Command Line
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run in release mode
flutter run --release
```

#### Using IDE
- **Android Studio**: Click "Run" button (green triangle)
- **VS Code**: Press F5 or Run > Start Debugging

## Project Structure

```
network_app/
├── android/              # Android-specific code
├── ios/                  # iOS-specific code
├── lib/                  # Main application code
│   ├── core/             # Core functionality
│   ├── features/         # Feature modules
│   ├── injection_container.dart  # DI setup
│   └── main.dart         # App entry point
├── test/                 # Unit and widget tests
├── assets/               # Images, animations, icons
├── pubspec.yaml          # Dependencies
└── README.md             # This file
```

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/towers/presentation/bloc/tower_bloc_test.dart

# Generate test mocks
flutter pub run build_runner build
```

## Building for Production

### Android APK
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Output location:
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/bundle/release/app-release.aab
```

### iOS IPA
```bash
# Build for iOS
flutter build ios --release

# Note: Requires Mac with Xcode
# Archive using Xcode for App Store submission
```

## Common Issues & Solutions

### Issue: Package resolution fails
**Solution:**
```bash
flutter clean
flutter pub get
```

### Issue: Build runner fails
**Solution:**
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: Google Maps not showing
**Solution:**
- Verify API key is correct
- Ensure Maps SDK is enabled in Google Cloud Console
- Check API key restrictions

### Issue: Location permission denied
**Solution:**
- Grant location permission in device settings
- Ensure permission is declared in AndroidManifest.xml (Android)
- Ensure usage description is in Info.plist (iOS)

### Issue: Gradle build fails (Android)
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

## Development Tips

### Hot Reload
- Press `r` in terminal while app is running
- Or press "Hot Reload" in IDE

### Hot Restart
- Press `R` in terminal
- Or press "Hot Restart" in IDE

### Debug vs Release Mode
- **Debug**: Includes debugging information, slower
- **Profile**: Performance profiling
- **Release**: Optimized, no debugging info

### Useful Commands
```bash
# Check Flutter installation
flutter doctor -v

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Clean build
flutter clean

# Update dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated
```

## Environment Variables (Optional)

Create `.env` file in project root:
```env
API_BASE_URL=https://api.example.com
GOOGLE_MAPS_API_KEY=your_key_here
```

## Firebase Setup (For Notifications)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create new project
3. Add Android app
   - Download `google-services.json`
   - Place in `android/app/`
4. Add iOS app
   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/`
5. Follow FlutterFire CLI setup instructions

## CI/CD Setup

### GitHub Actions
Create `.github/workflows/flutter.yml`:
```yaml
name: Flutter CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.2'
      - run: flutter pub get
      - run: flutter test
      - run: flutter analyze
      - run: flutter build apk
```

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [BLoC Documentation](https://bloclibrary.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## Support

For issues and questions:
- Open an issue on [GitHub](https://github.com/shalabi11/network_app/issues)
- Check existing issues first

## License

This project is licensed under the MIT License - see the LICENSE file for details.
