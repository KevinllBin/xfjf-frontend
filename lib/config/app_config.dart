class AppConfig {
  AppConfig._();

  static const defaultBackendBaseUrl = 'https://api.example.com';

  // Use --dart-define or --dart-define-from-file to override this value.
  static const backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: defaultBackendBaseUrl,
  );
}
