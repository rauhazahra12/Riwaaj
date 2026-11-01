# Riwaaj – Occasion Wear Rental Platform

Riwaaj is a Flutter-based fashion rental application designed to simplify the discovery and rental of occasion wear across Pakistan. It connects customers with boutiques and outfit owners, making it easier to explore available outfits, discover styles, and manage rental bookings through a single platform.

Customers can browse outfits by category and city, save their favourite looks, communicate with boutique owners, and manage rental requests. Boutique owners can showcase their collections, publish outfit listings, and manage incoming bookings through a dedicated dashboard.

## Key Features

### For Customers
- **Outfit Discovery:** Browse occasion wear listings with images, sizes, rental prices, security deposits, and owner details.
- **Advanced Search and Filtering:** Find outfits based on category, city, size, and rental duration.
- **Outfit Details:** View detailed information about individual listings.
- **Saved Outfits:** Bookmark favourite looks for easy access.
- **Rental Bookings:** Create and manage outfit rental requests.
- **In-App Messaging:** Communicate directly with outfit owners and discuss rental requests.
- **User Accounts:** Register, log in, manage profiles, and complete the application's verification flow.

### For Boutique Owners
- **Listing Management:** Create and publish outfit listings with images and relevant rental information.
- **Booking Management:** View and manage incoming rental requests.
- **Boutique Dashboard:** Access a dedicated dashboard for managing boutique activities.

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform mobile application development |
| Dart | Application programming language |
| Provider | State management |
| Firebase Authentication | User authentication |
| Cloud Firestore | Cloud database |
| Firebase Storage | Image and file storage |
| Mock Services | Sample data and development fallback |

## Prerequisites

Before running the project, ensure you have:

- Flutter SDK with Dart version `>=3.13.0 <4.0.0`
- Android Studio or Xcode for mobile development
- A configured Firebase project for backend functionality

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/rauhazahra12/Riwaaj.git
cd Riwaaj
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the Application

```bash
flutter run
```

The application attempts to initialize Firebase during startup. If Firebase initialization fails, it switches to mock services automatically.

Mock mode provides sample outfits, bookings, chats, and a default demo user. Changes made while using mock services are stored in memory and are not retained after the application restarts.

## Firebase Configuration

The project includes `lib/firebase_options.dart`. However, its configuration must correspond to the Firebase project you intend to use.

Configure Firebase using the FlutterFire CLI.

### 1. Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### 2. Configure Your Firebase Project

```bash
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

### 3. Configure Platform-Specific Files

- **Android:** Ensure `android/app/google-services.json` belongs to the configured Firebase project.
- **iOS:** Add the corresponding `GoogleService-Info.plist` to the Runner target.

### 4. Enable Firebase Services

In your Firebase Console:

- Enable Email/Password authentication in Firebase Authentication.
- Create and configure a Cloud Firestore database.
- Enable Firebase Storage.
- Configure appropriate Firestore and Storage security rules.

**Implementation Note:** The application currently selects Firebase as its default backend and falls back to mock services if Firebase initialization throws an error. Firebase phone OTP methods are currently placeholders and require further implementation before phone-based verification can be used with Firebase.

For additional configuration guidance, refer to the [official FlutterFire documentation](https://firebase.google.com/docs/flutter/setup).

## Project Structure

```text
Riwaaj/
│
├── assets/
│   └── images/          # Bundled sample outfit images
│
├── lib/
│   ├── core/            # Themes, colors, constants, and helpers
│   ├── models/          # User, outfit, booking, and chat models
│   ├── providers/       # State management and application actions
│   ├── screens/         # Application screens and user interfaces
│   ├── services/        # Firebase and mock service implementations
│   ├── widgets/         # Reusable UI components
│   │
│   ├── firebase_options.dart
│   └── main.dart        # Application entry point
│
├── android/
├── ios/
├── pubspec.yaml
└── README.md
```

## Architecture Overview

Riwaaj follows a service-oriented application structure with separate responsibilities for the user interface, state management, data models, and backend operations.

- **Presentation Layer:** Contains application screens and reusable widgets.
- **State Management Layer:** Uses Provider to manage application state and user interactions.
- **Service Layer:** Handles backend operations through Firebase or mock implementations.
- **Data Layer:** Defines models for users, outfits, bookings, and conversations.

Service implementations are initialized in `lib/main.dart` and made available to the application through providers. The service interfaces also allow alternative implementations to be supplied directly to `RiwaajApp` during development and testing.

## Development Commands

Run the following commands from the project directory.

| Command | Description |
|---|---|
| `flutter pub get` | Install project dependencies |
| `flutter analyze` | Analyze code for potential issues |
| `flutter test` | Run automated tests |
| `flutter build apk` | Build an Android APK |
| `flutter build ios` | Build for iOS |
| `flutter build web` | Build the web application |

## Important Notes

- Firebase platform configurations are managed through `lib/firebase_options.dart`.
- Sample outfit images are bundled in `assets/images/`.
- Mock service data is intended for development and fallback scenarios.
- Mock-mode changes are not persisted between application launches.
- Firebase phone OTP functionality requires further implementation.
- Configure production-ready Firebase Security Rules and platform signing settings before release.

## Project Status

Riwaaj includes outfit discovery, rental booking workflows, customer accounts, boutique listing management, and messaging functionality. Firebase-backed services and mock implementations support the application's development and testing workflows.
