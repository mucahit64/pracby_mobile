abstract final class Routes {
  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Onboarding
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String examSelect = '/exam-select';

  // Main tabs
  static const String home = '/home';
  static const String leaderboard = '/leaderboard';
  static const String store = '/store';
  static const String profile = '/profile';

  // Quiz
  static const String quiz = '/quiz/:id';
  static String quizWithId(String id) => '/quiz/$id';

  // Other
  static const String notifications = '/notifications';
  static const String editProfile = '/profile/edit';
  static const String friends = '/friends';
  static const String courseDetail = '/course/:id';
  static String courseDetailWithId(String id) => '/course/$id';
}
