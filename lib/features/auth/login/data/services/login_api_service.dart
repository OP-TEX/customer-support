import 'package:dio/dio.dart';
import '../models/login_response.dart';

class LoginApiService {
  final Dio _dio;

  LoginApiService(this._dio);

  Future<LoginResponse> login(String username, String password) async {
    try {
      print(username);
      print(password);
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': username,
          'password': password,
        },
      );
      print(response.data);
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      if (e.response?.statusCode == 401) {
        return 'Incorrect credentials';
      } else {
        return 'internal Server error}';
      }
    } else {
      return 'Network error: ${e.message}';
    }
  }
}
