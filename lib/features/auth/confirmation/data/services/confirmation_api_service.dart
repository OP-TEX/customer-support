import 'package:dio/dio.dart';
import 'package:support/core/di/dependency_injection.dart';
import 'package:support/core/helpers/auth_helpers/auth_service.dart';

class ConfirmationApiService {
  final Dio _dio;
  final AuthService _authService = getIt<AuthService>();
  ConfirmationApiService(this._dio);

  Future<Map<String, dynamic>> sendConfirmationEmail(String email) async {
    try {
      final response = await _dio
          .post('/auth/send-confirmation-email', data: {'email': email});
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Unexpected error occurred';
    }
  }

  Future<Map<String, dynamic>> confirmEmail({
    required String email,
    required String token,
    required String otp,
  }) async {
    try {
      final response = await _dio.post('/auth/confirm-email', data: {
        'email': email,
        'token': token,
        'otp': otp,
      });

      // If verification is successful, update the auth info
      if (response.statusCode == 200) {
        _authService.updateConfirmationStatus(true);
        return response.data;
      }

      throw 'Email verification failed';
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  String _handleDioError(DioException e) {
    if (e.response == null) {
      return 'Network error! Please try again';
    }

    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    String backendMessage = '';
    if (data is Map<String, dynamic>) {
      backendMessage = data['message']?.toString() ?? '';
    } else if (data is String) {
      backendMessage = data;
    }

    switch (statusCode) {
      case 400:
        return backendMessage.isNotEmpty
            ? backendMessage
            : 'Invalid input data';
      case 401:
        return 'Unauthorized request';
      case 404:
        return 'User not found';
      case 500:
        return 'Internal server error';
      default:
        return backendMessage.isNotEmpty
            ? backendMessage
            : 'Something went wrong. Please try again later.';
    }
  }
}
