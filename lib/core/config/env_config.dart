enum Environment { dev, prod, mock }

class EnvConfig {
  final String baseUrl;
  final Environment environment;
  final bool enableAnalytics;
  final bool showDebugBanner;

  const EnvConfig({
    required this.baseUrl,
    required this.environment,
    this.enableAnalytics = true,
    this.showDebugBanner = false,
  });

  static EnvConfig get dev => const EnvConfig(
    baseUrl: 'https://api.dev.example.com',
    environment: Environment.dev,
    showDebugBanner: true,
  );

  static EnvConfig get prod => const EnvConfig(
    baseUrl: 'https://api.example.com',
    environment: Environment.prod,
    enableAnalytics: true,
  );

  static EnvConfig get mock => const EnvConfig(
    baseUrl: 'https://mock.api.example.com',
    environment: Environment.mock,
    enableAnalytics: false,
    showDebugBanner: true,
  );
}
