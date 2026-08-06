import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:pracby_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:pracby_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:pracby_mobile/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:pracby_mobile/features/friends/presentation/screens/friends_screen.dart';
import 'package:pracby_mobile/features/home/presentation/screens/course_detail_screen.dart';
import 'package:pracby_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:pracby_mobile/features/leaderboard/presentation/screens/leaderboard_screen.dart';
import 'package:pracby_mobile/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:pracby_mobile/features/onboarding/presentation/screens/exam_select_screen.dart';
import 'package:pracby_mobile/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:pracby_mobile/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:pracby_mobile/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:pracby_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:pracby_mobile/features/quiz/presentation/screens/quiz_screen.dart';
import 'package:pracby_mobile/features/store/presentation/screens/store_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterRefreshNotifier();
  ref.onDispose(notifier.dispose);
  ref.listen<AsyncValue<UserModel?>>(
    authStateProvider,
    (_, __) => notifier.refresh(),
  );

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isLoggedIn = authState.valueOrNull != null;
      final path = state.matchedLocation;
      final isAuthRoute = path == Routes.login ||
          path == Routes.register ||
          path == Routes.forgotPassword ||
          path == Routes.resetPassword;
      final isSplash = path == Routes.splash;
      final isOnboarding =
          path == Routes.welcome || path == Routes.examSelect;

      if (isSplash) return null;

      if (!isLoggedIn && !isAuthRoute && !isOnboarding) {
        return Routes.login;
      }

      if (isLoggedIn && isAuthRoute) {
        return Routes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: Routes.examSelect,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ExamSelectScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => _ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: Routes.leaderboard,
            builder: (context, state) => const LeaderboardScreen(),
          ),
          GoRoute(
            path: Routes.store,
            builder: (context, state) => const StoreScreen(),
          ),
          GoRoute(
            path: Routes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.quiz,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return QuizScreen(
            stepId: state.pathParameters['id']!,
            topicId: extra?['topicId'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: Routes.notifications,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.editProfile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: Routes.courseDetail,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => CourseDetailScreen(
          courseId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: Routes.friends,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FriendsScreen(),
      ),
    ],
  );
});

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Sıralama',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Mağaza',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(Routes.home)) return 0;
    if (location.startsWith(Routes.leaderboard)) return 1;
    if (location.startsWith(Routes.store)) return 2;
    if (location.startsWith(Routes.profile)) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(Routes.home);
      case 1:
        context.go(Routes.leaderboard);
      case 2:
        context.go(Routes.store);
      case 3:
        context.go(Routes.profile);
    }
  }
}
