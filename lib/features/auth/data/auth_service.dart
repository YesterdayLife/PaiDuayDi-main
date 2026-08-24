import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  Future<void>? _googleSignInInitFuture;

  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signInWithGoogle() async {
    _ensureFirebaseReady();

    if (kIsWeb) {
      return _signInWithGooglePopup();
    }

    if (!_isMobileGoogleSignInTarget) {
      throw const AuthException(
        message: 'Google Sign-In is configured for Android, iOS, and Web only.',
      );
    }

    if (!_googleSignIn.supportsAuthenticate()) {
      throw const AuthException(
        message: 'Google Sign-In is not available on this device.',
      );
    }

    try {
      await _ensureGoogleSignInInitialized();
      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw const AuthException(
          message: 'Google did not return an ID token. Check Firebase setup.',
        );
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      return await _firebaseAuth.signInWithCredential(credential);
    } on GoogleSignInException catch (error) {
      throw AuthException(message: _googleSignInExceptionMessage(error));
    } on FirebaseAuthException catch (error) {
      throw AuthException(message: _firebaseAuthExceptionMessage(error));
    }
  }

  Future<void> signOut() async {
    _ensureFirebaseReady();

    if (kIsWeb) {
      await _firebaseAuth.signOut();
      return;
    }

    await _ensureGoogleSignInInitialized();
    await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<UserCredential> _signInWithGooglePopup() async {
    try {
      return await _firebaseAuth.signInWithPopup(GoogleAuthProvider());
    } on FirebaseAuthException catch (error) {
      throw AuthException(message: _firebaseAuthExceptionMessage(error));
    }
  }

  Future<void> _ensureGoogleSignInInitialized() {
    _googleSignInInitFuture ??= _googleSignIn.initialize();
    return _googleSignInInitFuture!;
  }

  bool get _isMobileGoogleSignInTarget {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  void _ensureFirebaseReady() {
    if (Firebase.apps.isEmpty) {
      throw const AuthException(
        message: 'ตั้งค่า Firebase ยังไม่ครบ กรุณาเพิ่ม Firebase config สำหรับแพลตฟอร์มนี้',
      );
    }
  }

  String _googleSignInExceptionMessage(GoogleSignInException error) {
    return switch (error.code) {
      GoogleSignInExceptionCode.canceled => 'ยกเลิกการเข้าสู่ระบบด้วย Google',
      GoogleSignInExceptionCode.uiUnavailable => 'ไม่สามารถเปิดหน้าต่าง Google Sign-In ได้ กรุณาลองบน Android/iOS ที่มี Google Play Services หรือทดสอบผ่าน Chrome Web',
      GoogleSignInExceptionCode.clientConfigurationError ||
      GoogleSignInExceptionCode.providerConfigurationError => 'ตั้งค่า Google Sign-In ยังไม่ครบ กรุณาตรวจสอบ Firebase, SHA-1/SHA-256 และไฟล์ config',
      GoogleSignInExceptionCode.interrupted =>
        'การเข้าสู่ระบบถูกขัดจังหวะ กรุณาลองอีกครั้ง',
      _ => 'เข้าสู่ระบบด้วย Google ไม่สำเร็จ กรุณาลองอีกครั้ง',
    };
  }

  String _firebaseAuthExceptionMessage(FirebaseAuthException error) {
    return switch (error.code) {
      'network-request-failed' =>
        'ไม่สามารถเชื่อมต่อเครือข่ายได้ กรุณาลองอีกครั้ง',
      'invalid-credential' => 'ข้อมูลเข้าสู่ระบบไม่ถูกต้อง กรุณาลองอีกครั้ง',
      _ => 'เข้าสู่ระบบด้วย Google ไม่สำเร็จ (${error.code})',
    };
  }
}

class AuthException implements Exception {
  const AuthException({required this.message});

  final String message;

  @override
  String toString() => message;
}
