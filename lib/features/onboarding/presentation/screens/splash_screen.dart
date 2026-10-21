import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
    _navigateAfterDelay();
  }

  /// Launch logic (docs 3.8): a valid token goes home, otherwise a guest
  /// with a chosen exam goes home as guest, otherwise exam selection.
  /// Startup failed for a reason other than a rejected token (server error,
  /// or offline without a cached profile). The token is kept; offer a retry.
  bool _startupFailed = false;

  Future<void> _navigateAfterDelay() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    await _route();
  }

  Future<void> _route({bool retry = false}) async {
    if (!mounted) return;
    // AuthNotifier.build already called /users/me (and dropped a 401/403
    // token). Any other failure surfaces here as an error.
    UserModel? user;
    try {
      // A retry must wait for a fresh request: refresh() rebuilds the
      // provider and returns the new future, read() could hand back the
      // failed one.
      user = await (retry
          ? ref.refresh(authStateProvider.future)
          : ref.read(authStateProvider.future));
    } catch (_) {
      if (mounted) setState(() => _startupFailed = true);
      return;
    }
    if (!mounted) return;

    final isGuest = ref.read(guestProvider).isActive;
    context.go(user != null || isGuest ? Routes.home : Routes.welcome);
  }

  void _retry() {
    setState(() => _startupFailed = false);
    _route(retry: true);
  }

  /// Way out when the session keeps failing: drop the token and continue
  /// as a guest (or from the welcome screen).
  Future<void> _logout() async {
    await ref.read(authStateProvider.notifier).logout();
    if (!mounted) return;
    setState(() => _startupFailed = false);
    final isGuest = ref.read(guestProvider).isActive;
    context.go(isGuest ? Routes.home : Routes.welcome);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The app icon's P, inverted to stand out on purple.
                SvgPicture.asset(
                  'assets/brand/p-icon-inverse.svg',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 24),
                // The web's wordmark: lowercase, black weight.
                const Text(
                  'pracby',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sınavlara hazırlanmanın en eğlenceli yolu',
                  style: TextStyle(fontSize: 14, color: AppColors.grey200),
                ),
                if (_startupFailed) ...[
                  const SizedBox(height: 32),
                  const Text(
                    'Sunucuya bağlanılamadı.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _retry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(160, 44),
                    ),
                    child: const Text(
                      'Tekrar Dene',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _logout,
                    child: const Text(
                      'Çıkış Yap',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
