class AppConstants {
  // App Info
  static const String appName = 'Travel & Tour';
  static const String appVersion = '1.0.0';

  // Shared Preferences Keys
  static const String prefToken = 'auth_token';
  static const String prefUserData = 'user_data';
  static const String prefTheme = 'theme_mode';
  static const String prefFirstLaunch = 'first_launch';

  // Date Formats
  static const String dateFormatDisplay = 'dd MMM yyyy';
  static const String dateFormatApi = 'yyyy-MM-dd';
  static const String timeFormatDisplay = 'hh:mm a';

  // Pagination
  static const int itemsPerPage = 20;

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Error Messages
  static const String errorNetwork =
      'Network error. Please check your connection.';
  static const String errorServer = 'Server error. Please try again later.';
  static const String errorUnauthorized =
      'Session expired. Please login again.';
  static const String errorUnknown = 'Something went wrong. Please try again.';
}
