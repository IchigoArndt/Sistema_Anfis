class AppConfig {
  /// IP da máquina de desenvolvimento na rede local (Wi-Fi).
  /// Emulador Android: `--dart-define=DEV_HOST=10.0.2.2`
  /// Celular físico: `--dart-define=DEV_HOST=<ip-do-pc>`
  static const String devHost = String.fromEnvironment(
    'DEV_HOST',
    defaultValue: '10.0.0.220',
  );

  static const String _authUrlOverride = String.fromEnvironment('AUTH_URL');
  static const String _apiUrlOverride = String.fromEnvironment('API_URL');

  /// Auth API (container sd-auth) — porta 5159
  static String get authBaseUrl => _authUrlOverride.isNotEmpty
      ? _authUrlOverride
      : 'http://$devHost:5159';

  /// Server API (container sd-server) — porta 5252
  static String get apiBaseUrl => _apiUrlOverride.isNotEmpty
      ? _apiUrlOverride
      : 'http://$devHost:5252';
}
