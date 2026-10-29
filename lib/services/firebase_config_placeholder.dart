// =======================================================================
// RIWAAJ FIREBASE INTEGRATION GUIDE & STUB
// =======================================================================
//
// Once you have your Firebase project credentials ready:
//
// 1. Run FlutterFire CLI:
//      flutterfire configure --project=[your-firebase-project-id]
//    This will generate `lib/firebase_options.dart` automatically.
//
// 2. Add Firebase packages to pubspec.yaml:
//      firebase_core: ^3.6.0
//      firebase_auth: ^5.3.1
//      cloud_firestore: ^5.4.4
//      firebase_storage: ^12.3.4
//
// 3. In `lib/main.dart`, uncomment:
//      WidgetsFlutterBinding.ensureInitialized();
//      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//      BackendConfig.currentMode = BackendMode.firebase;
//
// 4. The services in `lib/services/` already implement `IAuthService`,
//    `IOutfitService`, `IBookingService`, and `IChatService`.
//    The Firestore and FirebaseAuth adapters can be plugged in directly!
// =======================================================================

class FirebaseConfigPlaceholder {
  static const bool isConfigured = false;
  static const String notes =
      'Awaiting Firebase credentials (firebase_options.dart / google-services.json).';
}
