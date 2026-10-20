import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';

/// Shown to guests after each quiz (docs 10.8, web
/// `pages/auth/register-wall.vue`).
class RegisterWallScreen extends StatelessWidget {
  const RegisterWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Harika gidiyorsun! 🎉',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.grey800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'İlerlemeni kaydetmek ve ücretsiz olarak öğrenmeye devam '
                    'etmek için bir profil oluştur.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push(Routes.register),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text(
                        'Profil Oluştur',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.push(Routes.login),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(46),
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Giriş Yap',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    // Back to the map it was opened over, where it was left.
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go(Routes.home),
                    child: const Text(
                      '← Ana sayfaya dön',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
