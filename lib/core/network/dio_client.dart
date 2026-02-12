import 'package:dio/dio.dart';
import '../exceptions/app_exception.dart';
import '../logger/app_logger.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => AppLogger.debug(obj.toString()),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          final exception = _mapDioException(e);
          return handler.next(
            DioException(
              requestOptions: e.requestOptions,
              response: e.response,
              type: e.type,
              error: exception,
              message: exception.message,
            ),
          );
        },
      ),
    );
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw _mapDioException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      if (e.error is AppException) {
        throw e.error as AppException;
      }
      throw _mapDioException(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  AppException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException('Connection timed out');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return AuthException('Unauthorized access', statusCode.toString());
        }
        return ServerException(
          'Server returned $statusCode',
          statusCode?.toString(),
        );
      case DioExceptionType.cancel:
        return ServerException('Request cancelled');
      default:
        return NetworkException('Something went wrong with the network');
    }
  }
}
