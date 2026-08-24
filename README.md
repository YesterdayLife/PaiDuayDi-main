# paiduaydi

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Firebase Google Sign-In setup

This project wires Google Sign-In through Firebase Auth for Android, iOS, and
Web/Chrome.
Before running the app, complete these manual setup steps:

1. Create or open a Firebase project in the Firebase Console.
2. Enable Authentication > Sign-in method > Google.
3. Register the Android app with package name `com.paiduaydi.paiduaydi`.
4. Add your Android debug and release SHA-1/SHA-256 fingerprints to the
   Firebase Android app settings.
5. Download `google-services.json` and place it at
   `android/app/google-services.json`.
6. Register the iOS app with your Runner bundle identifier from Xcode.
7. Download `GoogleService-Info.plist` and add it to `ios/Runner/` through
   Xcode so it is included in the Runner target.
8. Copy `REVERSED_CLIENT_ID` from `GoogleService-Info.plist` and replace
   `REPLACE_WITH_REVERSED_CLIENT_ID` in `ios/Runner/Info.plist`.
9. Register a Web app in Firebase for Chrome testing.
10. Add your local test origin to Firebase Authentication > Settings >
    Authorized domains if needed, for example `localhost`.
11. Run Chrome with the Firebase Web config file (avoids PowerShell
    splitting `appId` values that contain colons):

```powershell
flutter run -d chrome --dart-define-from-file=config/firebase.web.json
```

In Cursor / VS Code, use the **paiduaydi (Chrome + Firebase)** launch
configuration. If you still pass `--dart-define` flags one by one, quote
every value.

To print the Android debug SHA-1/SHA-256 fingerprints, run:

```sh
cd android
./gradlew signingReport
```

On Windows PowerShell, use:

```powershell
cd android
.\gradlew signingReport
```
