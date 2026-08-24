import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../data/auth_service.dart';
import '../widgets/brand_logo.dart';
import '../widgets/social_auth_button.dart';
import '../../../home/presentation/screens/home_screen.dart';
import 'phone_entry_screen.dart';

class AuthEntryScreen extends StatefulWidget {
  const AuthEntryScreen({super.key, this.firebaseReady = true});

  final bool firebaseReady;

  @override
  State<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends State<AuthEntryScreen> {
  bool _isGoogleLoading = false;

  void _onSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'เข้าสู่ระบบด้วย $provider',
          style: AppTypography.bodyMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onGoogleLogin() async {
    if (_isGoogleLoading) return;

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      await AuthService.instance.signInWithGoogle();
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (_) => false,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _googleSignInErrorMessage(error),
            style: AppTypography.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  String _googleSignInErrorMessage(Object error) {
    if (error is AuthException) {
      return error.message;
    }

    final errorText = error.toString().toLowerCase();
    if (errorText.contains('cancel')) {
      return 'ยกเลิกการเข้าสู่ระบบด้วย Google';
    }
    if (errorText.contains('network')) {
      return 'ไม่สามารถเชื่อมต่อเครือข่ายได้ กรุณาลองอีกครั้ง';
    }
    return 'เข้าสู่ระบบด้วย Google ไม่สำเร็จ กรุณาลองอีกครั้ง';
  }

  void _onPhoneLogin() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PhoneEntryScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (kIsWeb && !widget.firebaseReady)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Firebase ยังไม่พร้อมบน Web กรุณารันด้วย --dart-define-from-file=config/firebase.web.json',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 1),
              const BrandLogo(size: 110, showText: false),
              const SizedBox(height: 16),
              Text(
                'PaiDuayDi',
                style: AppTypography.brandSubtitle.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'แชร์เส้นทาง แชร์ค่าเดินทาง ปลอดภัยทุกทริป',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
              const Spacer(flex: 2),
              SocialAuthButton(
                type: AuthButtonType.facebook,
                onTap: () => _onSocialLogin('Facebook'),
              ),
              SocialAuthButton(
                type: AuthButtonType.google,
                onTap: _onGoogleLogin,
                isLoading: _isGoogleLoading,
              ),
              SocialAuthButton(
                type: AuthButtonType.apple,
                onTap: () => _onSocialLogin('Apple'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(color: AppColors.border, thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'หรือ',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: AppColors.border, thickness: 1),
                    ),
                  ],
                ),
              ),
                    SocialAuthButton(
                      type: AuthButtonType.phone,
                      onTap: _onPhoneLogin,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
