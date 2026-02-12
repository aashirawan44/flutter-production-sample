import '../../../../core/logger/app_logger.dart';

abstract class AnalyticsService {
  void logEvent(String name, [Map<String, dynamic>? parameters]);
}

class MockAnalyticsServiceImpl implements AnalyticsService {
  @override
  void logEvent(String name, [Map<String, dynamic>? parameters]) {
    AppLogger.info('ANALYTICS: Event "$name" with parameters: $parameters');
  }
}
