import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

enum BackendMode {
  mock,
  firebase,
}

class BackendConfig {
  BackendConfig._();

  static BackendMode currentMode = BackendMode.firebase;

  static bool get isFirebaseEnabled => currentMode == BackendMode.firebase;

  static Future<bool> initializeFirebase() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      currentMode = BackendMode.firebase;
      debugPrint('[BackendConfig] Firebase initialized successfully on ${DefaultFirebaseOptions.currentPlatform.projectId}');
      return true;
    } catch (e) {
      debugPrint('[BackendConfig] Firebase initialization fallback to Mock: $e');
      currentMode = BackendMode.mock;
      return false;
    }
  }
}
