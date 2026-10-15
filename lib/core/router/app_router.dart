import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pracby_mobile/core/router/routes.dart';
import 'package:pracby_mobile/features/auth/data/models/user_model.dart';
import 'package:pracby_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:pracby_mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:pracby_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:pracby_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:pracby_mobile/features/auth/presentation/screens/register_wall_screen.dart';
import 'package:pracby_mobile/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:pracby_mobile/features/friends/presentation/screens/friends_screen.dart';
import 'package:pracby_mobile/features/guest/guest_provider.dart';
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
  ref
    ..onDispose(notifier.dispose)
    ..listen<AsyncValue<UserModel?>>(
      authStateProvider,
      (_, __) => notifier.refresh(),
    )
    ..listen<bool>(
      guestProvider.select((g) => g.isActive),
      (_, __) => notifier.refresh(),
    );

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authStateProvider).valueOrNull != null;
      final isGuest = !isLoggedIn && ref.read(guestProvider).isActive;
      final path = state.matchedLocation;

      const authRoutes = {
        Routes.login,
        Routes.register,
        Routes.forgotPassword,
        Routes.resetPassword,
      };
      const onboardingRoutes = {Routes.splash, Routes.welcome};
      // What a guest may open (docs 10.2, web middleware/auth.global.ts).
      final guestAllowed = path == Routes.home ||
          path == Routes.store ||
          path == Routes.leaderboard ||
          path == Routes.registerWall ||
          path.startsWith('/quiz/');

      if (path == Routes.splash) return null;

      if (isLoggedIn) {
        if (authRoutes.contains(path) ||
            path == Routes.welcome ||
            path == Routes.registerWall) {
          return Routes.home;
        }
        return null;
      }

      if (authRoutes.contains(path) ||
          onboardingRoutes.contains(path) ||
          path == Routes.examSelect) {
        return null;
      }
      if (isGuest) {
        // Profile, friends, notifications… need an account.
        return guestAllowed ? null : Routes.register;
      }
      // Neither logged in nor a guest with an exam (e.g. after a 401).
      return Routes.login;
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
      GoRoute(
        path: Routes.registerWall,
        builder: (context, state) => const RegisterWallScreen(),
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
          final query = state.uri.queryParameters;
          return QuizScreen(
            params: (
              topicId: state.pathParameters['topicId']!,
              stepId: query['stepId'],
              testId: query['testId'],
              sessionType: query['sessionType'],
            ),
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

class _ScaffoldWithNavBar extends ConsumerWidget {
  const _ScaffoldWithNavBar({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context, ref),
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

  void _onItemTapped(int index, BuildContext context, WidgetRef ref) {
    switch (index) {
      case 0:
        context.go(Routes.home);
      case 1:
        context.go(Routes.leaderboard);
      case 2:
        context.go(Routes.store);
      case 3:
        // Guests get the register screen on top of the current tab, so its
        // ✕ returns to where they were (web: PROFİL → /auth/register).
        final isLoggedIn = ref.read(authStateProvider).valueOrNull != null;
        isLoggedIn
            ? context.go(Routes.profile)
            : context.push(Routes.register);
    }
  }
}
