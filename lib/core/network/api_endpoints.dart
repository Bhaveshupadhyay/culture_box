class ApiEndpoints {
  static const String baseUrl = 'https://api.cultureboxtv.com/api/v1';

  // Auth & Account
  static const String login = '/auth/login';
  static const String sendOtp = '/auth/send-otp';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyResetOtp = '/auth/verify-reset-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String refresh = '/refresh';
  static const String logout = '/logout';
  static const String deleteAccount = '/delete-account';

  // Devices & Profile
  static const String devices = '/devices';
  static String removeDevice(String deviceId, String delDeviceId) => '/devices/$deviceId/$delDeviceId';
  static const String profile = '/profile';
  static String updateProfile(String id) => '/profile/$id';

  // Cloudinary
  static const String cloudinarySignature = '/cloudinary/signature';
  static const String cloudinaryDelete = '/cloudinary/delete';

  // Payments
  static const String paymentsPlans = '/payments/plans';
  static const String checkoutSession = '/payments/checkout-session';
  static const String paymentStatus = '/payments/status';
  static const String cancelSubscription = '/payments/cancel';
  static const String mySubscriptions = '/payments/my-subscriptions';
  static const String paymentsWebhook = '/payments/webhook';

  // Content Discovery & Playback
  static const String userPlans = '/users/plans';
  static const String userCategories = '/users/categories';
  static const String homeSliders = '/users/home/sliders';
  static const String homeLayout = '/users/home/layout';
  static String contentRow(int id) => '/users/content/row/$id';
  static const String contentVideoUrl = '/users/content/video-url';
  static String contentDetails(int id) => '/users/content/$id';
  static String recommendedContent(int id) => '/users/content/$id/recommended';
  static const String search = '/users/search';
}
