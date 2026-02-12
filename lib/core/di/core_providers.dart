import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../analytics/analytics_service.dart';
import '../config/env_config.dart';
import '../network/dio_client.dart';
import '../storage/storage_service.dart';

final envConfigProvider = Provider<EnvConfig>((ref) {
  return EnvConfig.mock;
});

final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(envConfigProvider);
  return Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ref.watch(dioProvider));
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final secureStorageServiceProvider = Provider<StorageService>((ref) {
  return SecureStorageServiceImpl(ref.watch(secureStorageProvider));
});

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'Initialize SharedPreferences in main and override this provider',
  );
});

final sharedPrefsServiceProvider = Provider<StorageService>((ref) {
  return SharedPreferencesServiceImpl(ref.watch(sharedPrefsProvider));
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return MockAnalyticsServiceImpl();
});
