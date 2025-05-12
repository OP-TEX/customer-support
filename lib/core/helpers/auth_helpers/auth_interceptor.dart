import 'package:dio/dio.dart';
import 'auth_service.dart';

class AuthInterceptor extends Interceptor {
  final AuthService _authService;
  final Dio _dio;
  bool _isRefreshing = false;
  String? _newAccessToken;
  final List<Function()> _retryQueue = [];

  AuthInterceptor(this._authService, this._dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _authService.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers["authorization"] = "Bearer $accessToken";
    }
    print('Request Headers: ${options.headers}');
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.response?.data["errorCode"] == "TOKEN_EXPIRED") {
      RequestOptions originalRequest = err.requestOptions;

      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          bool success = await _authService.refreshToken();
          if (success) {
            _newAccessToken = await _authService.getAccessToken();
          } else {
            throw Exception("Token refresh failed");
          }

          _isRefreshing = false;

          for (var retry in _retryQueue) {
            retry();
          }
          _retryQueue.clear();
          originalRequest.headers["authorization"] = "Bearer $_newAccessToken";
          final response = await _dio.fetch(originalRequest);
          return handler.resolve(response);
        } catch (e) {
          _isRefreshing = false;
          _retryQueue.clear();
          return handler.reject(err);
        }
      } else {
        _retryQueue.add(() async {
          if (_newAccessToken != null) {
            originalRequest.headers["authorization"] =
                "Bearer $_newAccessToken";
            final response = await _dio.fetch(originalRequest);
            print('Request Headers: ${originalRequest.headers}');
            handler.resolve(response);
          } else {
            handler.reject(err);
          }
        });
      }
    } else {
      return handler.next(err);
    }
  }
}
