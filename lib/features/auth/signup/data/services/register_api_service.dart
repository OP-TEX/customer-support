import 'package:dio/dio.dart';
import 'package:support/features/auth/signup/data/models/register_response_model.dart';
import '../models/register_request_model.dart';

class RegisterApiService {
  final Dio _dio;

  RegisterApiService(this._dio);

  Future<RegisterResponse> register(
      RegisterRequestModel registerRequestModel) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: registerRequestModel.toJson(),
      );

      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Return error message directly without wrapping in Exception
      throw _handleDioError(e);
    } catch (e) {
      throw 'Unexpected error occurred';
    }
  }

  String _handleDioError(DioException e) {
    // No response: This is likely a network issue
    if (e.response == null) {
      return 'Network error! please try again';
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
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Requested resource not found';
      case 409:
        return backendMessage.isNotEmpty
            ? backendMessage
            : 'User already exists';
      case 500:
        return 'Internal server error';
      default:
        return backendMessage.isNotEmpty
            ? backendMessage
            : 'Something went wrong. Please try again later.';
    }
  }
}
