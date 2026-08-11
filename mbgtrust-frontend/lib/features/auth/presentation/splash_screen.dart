import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/mbgtrust_logo.dart';
import 'providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotateAnimation;

  String _loadingText = 'Memuat Sistem MBGTrust...';
  Timer? _textTimer;

  final List<String> _loadingMessages = [
    'Memuat Sistem MBGTrust...',
    'Menghubungkan ke Dapur SPPG...',
    'Memuat Jadwal & Menu MBG...',
    'Sinkronisasi AI Mitigasi Food Waste...',
    'Menyiapkan Sesi Pengguna...',
  ];

  int _textIndex = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.06).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _startLoadingAnimation();
  }

  void _startLoadingAnimation() {
    _textTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _textIndex = (_textIndex + 1) % _loadingMessages.length;
          _loadingText = _loadingMessages[_textIndex];
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 2400), () async {
      if (!mounted) return;
      _textTimer?.cancel();
      await ref.read(authProvider.notifier).checkCurrentUser();
      final authState = ref.read(authProvider);

      if (!mounted) return;
      if (authState.isAuthenticated) {
        final role = authState.user?.peran;
        if (role == 'SUPER_ADMIN') {
          context.go('/admin/sekolah');
        } else if (role == 'ADMIN_SPPG') {
          context.go('/sppg/dashboard');
        } else {
          context.go('/home');
        }
      } else {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF06201B),
              Color(0xFF043427),
              Color(0xFF0F172A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Animated WOW Pulsing Glow & Rotation Aura Logo
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotateAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryDark.withValues(alpha: 0.35),
                            border: Border.all(
                              color: AppColors.primaryLight.withValues(alpha: 0.3 + (_scaleAnimation.value - 0.94) * 2),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.5),
                                blurRadius: 42 * _scaleAnimation.value,
                                spreadRadius: 10 * _scaleAnimation.value,
                              ),
                              BoxShadow(
                                color: AppColors.secondary.withValues(alpha: 0.25),
                                blurRadius: 60,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const MbgTrustLogo(
                            size: 110,
                            showText: false,
                            isDark: true,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),

              // Title
              const Text(
                'MBGTrust Platform',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              // Sub-title 2 Baris Presisi
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Mitigasi Food Waste Berbasis AI\npada Program Makan Bergizi Gratis',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.45,
                  ),
                ),
              ),

              const Spacer(),

              // Interactive Animated Loading Section
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Column(
                  children: [
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        color: AppColors.secondary,
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _loadingText,
                        key: ValueKey<String>(_loadingText),
                        style: const TextStyle(
                          color: AppColors.secondaryLight,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Copyright 2 Baris Presisi
                    const Text(
                      '© 2026 MBGTrust Platform\nBadan Gizi Nasional Republik Indonesia',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        height: 1.4,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
