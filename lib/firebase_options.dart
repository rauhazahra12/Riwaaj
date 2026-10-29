import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
/// Generated with data from the user-provided google-services.json configuration.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDo4L0XkezPDIf_cjZbmMoULpwdtZztkKs',
    appId: '1:335532153657:web:740e73dafde702870d26e8',
    messagingSenderId: '335532153657',
    projectId: 'todo-app-a9372',
    storageBucket: 'todo-app-a9372.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDo4L0XkezPDIf_cjZbmMoULpwdtZztkKs',
    appId: '1:335532153657:android:740e73dafde702870d26e8',
    messagingSenderId: '335532153657',
    projectId: 'todo-app-a9372',
    storageBucket: 'todo-app-a9372.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDo4L0XkezPDIf_cjZbmMoULpwdtZztkKs',
    appId: '1:335532153657:ios:740e73dafde702870d26e8',
    messagingSenderId: '335532153657',
    projectId: 'todo-app-a9372',
    storageBucket: 'todo-app-a9372.firebasestorage.app',
  );
}
