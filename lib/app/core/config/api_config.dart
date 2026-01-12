class AppUrl {
  AppUrl._();

  static const String baseUrl =
      'https://faithconnect-backend-production.up.railway.app';

  static const String login = '/api/auth/login';

  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration connectionTimeout = Duration(seconds: 60);
}
