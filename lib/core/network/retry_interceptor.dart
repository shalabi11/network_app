import 'package:dio/dio.dart';

/// Retry interceptor that automatically retries failed requests
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Function(String)? logPrint;
  static const int _maxRetries = 3;
  static const Duration _delayBetweenRetries = Duration(milliseconds: 500);

  RetryInterceptor({
    required this.dio,
    this.logPrint,
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      logPrint?.call('Retrying request: ${err.requestOptions.path}');
      
      return _retry(err.requestOptions, handler, 0);
    }
    return handler.next(err);
  }

  Future<void> _retry(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
    int retryCount,
  ) async {
    try {
      await Future.delayed(_delayBetweenRetries);
      
      final response = await dio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: Options(
          method: requestOptions.method,
          headers: requestOptions.headers,
        ),
      );
      
      return handler.resolve(response);
    } on DioException catch (e) {
      if (retryCount < _maxRetries && _shouldRetry(e)) {
        logPrint?.call('Retry attempt ${retryCount + 1}/$_maxRetries for: ${e.requestOptions.path}');
        return _retry(requestOptions, handler, retryCount + 1);
      }
      return handler.next(e);
    }
  }

  bool _shouldRetry(DioException error) {
    // Retry on connection timeout, receive timeout, or server errors (5xx)
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        (error.response?.statusCode ?? 0) >= 500;
  }
}
