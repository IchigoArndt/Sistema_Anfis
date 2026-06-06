class AppConfig {
  static const String authBaseUrl = String.fromEnvironment(
    'AUTH_URL',
    defaultValue: 'https://10.0.2.2:7289',
  );

  static const String apiBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://10.0.2.2:7171',
  );
}
