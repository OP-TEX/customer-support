import 'package:support/core/di/dependency_injection.dart';
import 'package:support/core/helpers/auth_helpers/auth_service.dart';
import 'package:support/features/auth/login/data/models/login_response.dart';
import 'package:support/features/auth/login/data/services/login_api_service.dart';

class LoginRepo {
  final LoginApiService _loginApiService;

  LoginRepo(this._loginApiService);

  Future<LoginResponse> login(String email, String password) async {
    final response = await _loginApiService.login(email, password);
    final AuthService authService = getIt<AuthService>();
    await authService.saveAuthInfo(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userId: response.userId,
        role: response.role,
        confirmed: response.confirmed,
        email: response.email
        );
            return response;

  }
}

