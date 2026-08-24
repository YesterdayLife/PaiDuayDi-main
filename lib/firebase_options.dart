import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static const String _webApiKey = String.fromEnvironment(
    'FIREBASE_WEB_API_KEY',
  );
  static const String _webAppId = String.fromEnvironment('FIREBASE_WEB_APP_ID');
  static const String _webMessagingSenderId = String.fromEnvironment(
    'FIREBASE_WEB_MESSAGING_SENDER_ID',
  );
  static const String _webProjectId = String.fromEnvironment(
    'FIREBASE_WEB_PROJECT_ID',
  );
  static const String _webAuthDomain = String.fromEnvironment(
    'FIREBASE_WEB_AUTH_DOMAIN',
  );
  static const String _webStorageBucket = String.fromEnvironment(
    'FIREBASE_WEB_STORAGE_BUCKET',
  );

  static bool get isWebConfigured {
    return _webApiKey.isNotEmpty &&
        _webAppId.isNotEmpty &&
        _webMessagingSenderId.isNotEmpty &&
        _webProjectId.isNotEmpty &&
        _webAuthDomain.isNotEmpty;
  }

  static FirebaseOptions get web {
    if (!isWebConfigured) {
      throw StateError(
        'Firebase Web config is missing. Pass FIREBASE_WEB_* dart-defines.',
      );
    }

    return const FirebaseOptions(
      apiKey: _webApiKey,
      appId: _webAppId,
      messagingSenderId: _webMessagingSenderId,
      projectId: _webProjectId,
      authDomain: _webAuthDomain,
      storageBucket: _webStorageBucket,
    );
  }
}
