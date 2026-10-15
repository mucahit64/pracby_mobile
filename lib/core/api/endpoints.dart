abstract final class Endpoints {
  // Auth
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';
  static const String checkEmail = '/api/auth/check-email';
  static const String checkUsername = '/api/auth/check-username';
  static const String mergeGuestProgress = '/api/auth/merge-guest-progress';

  // User
  static const String me = '/api/users/me';
  static const String myStats = '/api/users/me/stats';
  static const String myAchievements = '/api/users/me/achievements';
  static const String myStreakHistory = '/api/users/me/streak-history';
  static const String myEnrollments = '/api/users/me/enrollments';
  static const String activeExam = '/api/users/me/active-exam';

  // Courses
  static const String examGroups = '/api/exam-groups';
  static const String modules = '/api/modules';
  static const String courses = '/api/courses';
  static String courseFull(String id) => '/api/courses/$id/full';
  static String courseTopics(String id) => '/api/courses/$id/topics';

  // Quiz
  static const String quizStart = '/api/quiz/start';
  static const String quizGuestStart = '/api/quiz/guest-start';
  static String quizFinishBulk(String sessionId) =>
      '/api/quiz/$sessionId/finish-bulk';
  static String quizRewardClaim(String stepId) =>
      '/api/quiz/reward/$stepId/claim';
  static const String quizReportQuestion = '/api/quiz/report-question';
  static const String quizGuestReportQuestion =
      '/api/quiz/guest-report-question';

  // Store
  static const String storeItems = '/api/store/items';
  static const String storeInventory = '/api/store/inventory';
  static const String storeEffects = '/api/store/effects';
  static const String storePurchase = '/api/store/purchase';
  static String storeActivate(String itemId) =>
      '/api/store/activate/$itemId';
  static const String acornPackages = '/api/store/acorn-packages';

  // Leaderboard
  static const String leaderboard = '/api/leaderboard';

  // Friends
  static const String friends = '/api/friends';
  static const String friendRequests = '/api/friends/requests';
  static const String friendRequest = '/api/friends/request';
  static String friendRespond(String id) => '/api/friends/$id';
  static String friendRemove(String id) => '/api/friends/$id';

  // Notifications
  static const String notifications = '/api/notifications';
  static const String notificationsUnreadCount =
      '/api/notifications/unread-count';
  static String notificationRead(String id) => '/api/notifications/$id/read';
  static const String notificationsReadAll = '/api/notifications/read-all';
}
