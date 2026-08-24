import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseReady = await _initializeFirebase();

  // Set status bar icons and navigation bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(PaiDuayDiApp(firebaseReady: firebaseReady));
}

class PaiDuayDiApp extends StatelessWidget {
  const PaiDuayDiApp({super.key, required this.firebaseReady});

  final bool firebaseReady;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaiDuayDi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: SplashScreen(firebaseReady: firebaseReady),
    );
  }
}

Future<bool> _initializeFirebase() async {
  try {
    if (kIsWeb) {
      if (!DefaultFirebaseOptions.isWebConfigured) {
        debugPrint(
          'Firebase Web config is missing. Run with '
          '--dart-define-from-file=config/firebase.web.json',
        );
        return false;
      }
      await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
      debugPrint('Firebase initialized for project piduaydi (web).');
      return true;
    }

    await Firebase.initializeApp();
    debugPrint('Firebase initialized.');
    return true;
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization failed: $error');
    debugPrint('$stackTrace');
    return false;
  }
}
