import 'package:dio/dio.dart';

class ForgetPasswordApiService {
  final Dio _dio;

  ForgetPasswordApiService(this._dio);

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _dio.post('/auth/forgot-password', data: {
        'email': email,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<Map<String, dynamic>> confirmOtp({
    required String email,
    required String forgotToken,
    required String otp,
  }) async {
    try {
      final response = await _dio.post('/auth/confirm-otp', data: {
        'email': email,
        'forgotToken': forgotToken,
        'otp': otp,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
    required String resetToken,
  }) async {
    try {
      final response = await _dio.post('/auth/reset-password', data: {
        'email': email,
        'newPassword': newPassword,
        'resetToken': resetToken,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Error handler that extracts the backend message or returns a default error
  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please try again later.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Unable to get response from the server. Please try again.';
    } else if (e.type == DioExceptionType.badResponse) {
      try {
        final responseData = e.response?.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          return responseData['message'] ??
              'Unexpected error occurred. Please try again.';
        } else {
          return 'Unexpected error occurred. Please try again.';
        }
      } catch (e) {
        return 'Something went wrong parsing the error. Please try again.';
      }
    } else if (e.type == DioExceptionType.cancel) {
      return 'Request was cancelled. Please try again.';
    } else if (e.type == DioExceptionType.unknown) {
      return 'No internet connection. Please check your network.';
    } else {
      return 'Something went wrong. Please try again.';
    }
  }
}
