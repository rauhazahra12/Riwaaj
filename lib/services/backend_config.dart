enum BackendMode {
  mock,
  firebase,
}

class BackendConfig {
  BackendConfig._();

  /// Set to true once Firebase configuration (firebase_options.dart / google-services.json)
  /// is supplied.
  static BackendMode currentMode = BackendMode.mock;

  static bool get isFirebaseEnabled => currentMode == BackendMode.firebase;
}
