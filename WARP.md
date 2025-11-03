# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

**Hicom Partner** is a mobile application for partners (dealers, service centers, representatives) working with the Hicom system. Built with Flutter and GetX for cross-platform iOS and Android deployment.

- **Package Name**: `hicom_patners`
- **Current Version**: 1.0.6+10
- **Flutter SDK**: >=3.4.3 <4.0.0
- **State Management**: GetX
- **Backend**: REST API (https://hicom.app:81/api)

## Common Development Commands

### Setup and Dependencies
```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run on specific device
flutter run -d <device_id>

# List available devices
flutter devices
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format code
flutter format lib/

# Run tests
flutter test
```

### Build Commands
```bash
# Build APK (Android)
flutter build apk --release

# Build App Bundle (Android)
flutter build appbundle --release

# Build iOS
flutter build ios --release

# Clean build artifacts
flutter clean
```

### Assets and Icons
```bash
# Generate app icons (uses icons_launcher package)
flutter pub run icons_launcher:create

# Generate native splash screen
flutter pub run flutter_native_splash:create
```

## Architecture

### State Management Pattern

This app uses **GetX** for state management with a centralized controller approach:

- **Global Controller**: `GetController` (in `lib/controllers/get_controller.dart`) manages app-wide state including:
  - User authentication state (token, phone number)
  - UI state (loading, errors, navigation)
  - Persistent storage via GetStorage
  - Network connectivity monitoring
  - Biometric authentication state
  - Form controllers and validation

- **Feature Controllers**: Lazy-loaded controllers for specific features (e.g., `SwitchesController`, `PartnersController`) registered in `lib/controllers/dependency.dart`

- **API Controller**: `ApiController` (in `lib/controllers/api_controller.dart`) handles all HTTP communication with the backend

### Directory Structure

```
lib/
├── companents/          # Reusable UI components
│   ├── filds/          # Custom text fields and inputs
│   ├── home/           # Home screen components
│   ├── instrument/     # Utility widgets (toast, shake, etc.)
│   ├── skletons/       # Skeleton loading screens
│   └── utils/          # Responsive utilities
├── controllers/         # State management and business logic
│   ├── api_controller.dart      # All API calls
│   ├── dependency.dart          # Dependency injection setup
│   ├── firebase_api.dart        # Firebase/FCM integration
│   ├── get_controller.dart      # Global state controller
│   └── switch_repository.dart   # Switch feature repository
├── models/             # Data models
│   ├── auth/          # Authentication models
│   └── sample/        # App domain models
├── pages/              # Screen/page widgets
│   ├── account/       # User account screens
│   ├── auth/          # Authentication flow (login, register, passcode)
│   ├── bottombar/     # Bottom navigation screens (home, reports, guarantee)
│   ├── home/          # Home feature screens
│   ├── partners/      # Partner/shop feature (controllers, views, widgets)
│   ├── sample/        # Sample/onboarding screens
│   └── switches/      # Switches/devices feature (controllers, views, widgets)
└── resource/           # App constants
    ├── colors.dart    # Color definitions
    └── srting.dart    # Localization strings
```

### Key Architectural Patterns

1. **Feature Modules**: Features like `switches` and `partners` follow a modular structure:
   - `controllers/` - Feature-specific controllers
   - `views/` - UI screens
   - `widgets/` - Feature-specific reusable widgets

2. **Dependency Injection**: All controllers are registered in `DependencyInjection.init()` at app startup, with lazy loading for feature controllers

3. **API Communication**:
   - All API calls centralized in `ApiController`
   - Bearer token authentication from `GetController.token`
   - Language header based on `GetController.headerLanguage`
   - Base URL: `https://hicom.app:81/api`

4. **Navigation**: GetX navigation (`Get.to()`, `Get.offAll()`, etc.) used throughout with custom transitions

5. **Persistent Storage**: `GetStorage` used for:
   - Authentication token
   - User phone number
   - User profile (JSON serialized)
   - Passcode
   - Biometric preferences
   - Language settings
   - Notification messages

6. **Localization**: Multi-language support (Uzbek, Russian, English) via GetX translations:
   - Language stored in GetStorage as locale (e.g., 'uz_UZ', 'ru_RU')
   - Translations defined in `resource/srting.dart` (LocaleString class)
   - Use `.tr` extension on strings for translation

7. **Authentication Flow**:
   - Phone-based login → OTP verification → Profile check
   - If profile incomplete: registration flow → passcode creation
   - If profile complete: passcode entry (or biometric) → main app
   - Token stored in GetStorage and used in API headers

8. **Bottom Navigation**: App uses `ConvexBottomBar` with 5 tabs controlled via `GetController.index`

## Code Conventions

### GetX Reactive Variables
- Use `.obs` for reactive variables
- Use `.value` to access/update observable values
- Call `.refresh()` on observable lists/objects after mutation

### API Calls
- All API methods return `Future<void>`
- Success handling updates GetX controllers which automatically updates UI
- Error handling uses toast notifications via `InstrumentComponents().showToast()`

### Screen Navigation
- Use GetX navigation: `Get.to()`, `Get.back()`, `Get.offAll()`
- Pass data via `arguments` parameter
- Transitions: `Transition.fadeIn` commonly used

### Model Updates
- Models are updated via controller methods (e.g., `changeProfileInfoModel()`)
- Clear methods available for resetting state (e.g., `clearProfileInfoModel()`)

## Firebase Integration

- Firebase Cloud Messaging for push notifications
- FCM token stored and sent to backend via `postFcmToken()`
- Notification handling in `controllers/firebase_api.dart`

## Important Notes

- The app requires network connectivity - connectivity status monitored via `connectivity_plus`
- Profile photos and images cached using `disposable_cached_images`
- QR code scanning for warranty products (mobile_scanner package)
- Biometric authentication available via `local_auth`
- All date formatting uses custom methods in `GetController` for localization
