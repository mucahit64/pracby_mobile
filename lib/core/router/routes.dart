abstract final class Routes {
  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  /// Shown to guests after a quiz (web: /auth/register-wall).
  static const String registerWall = '/register-wall';

  // Onboarding
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String examSelect = '/exam-select';

  // Main tabs
  static const String home = '/home';
  static const String leaderboard = '/leaderboard';
  static const String store = '/store';
  static const String profile = '/profile';

  // Quiz — same shape as the web route /quiz/:topicId?stepId&testId&sessionType
  static const String quiz = '/quiz/:topicId';
  static String quizPath(
    String topicId, {
    String? stepId,
    String? testId,
    String? sessionType,
  }) =>
      Uri(
        path: '/quiz/$topicId',
        queryParameters: {
          if (stepId != null) 'stepId': stepId,
          if (testId != null) 'testId': testId,
          if (sessionType != null) 'sessionType': sessionType,
        },
      ).toString();

  // Other
  static const String notifications = '/notifications';
  static const String editProfile = '/profile/edit';
  static const String friends = '/friends';
  static const String courseDetail = '/course/:id';
  static String courseDetailWithId(String id) => '/course/$id';
}
