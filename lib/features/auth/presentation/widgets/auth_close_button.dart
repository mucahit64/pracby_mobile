import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/core/theme/app_colors.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';

/// ✕ button on the auth screens, like the web client's `handleClose`:
/// go back if possible; otherwise a guest returns to the lesson map and
/// anyone else to the welcome screen (web: landing page).
class AuthCloseButton extends ConsumerWidget {
  const AuthCloseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: AppColors.grey100,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.grey200, width: 2),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else if (ref.read(guestProvider).isActive) {
              context.go(Routes.home);
            } else {
              context.go(Routes.welcome);
            }
          },
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: Text(
                '✕',
                semanticsLabel: 'Geri dön',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
