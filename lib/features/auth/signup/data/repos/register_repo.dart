

import 'package:support/core/di/dependency_injection.dart';
import 'package:support/core/helpers/auth_helpers/auth_service.dart';
import 'package:support/features/auth/signup/data/models/register_request_model.dart';
import 'package:support/features/auth/signup/data/services/register_api_service.dart';

class RegisterRepo {
  final RegisterApiService _registerApiService;

  RegisterRepo(this._registerApiService);

  Future<String> register(RegisterRequestModel req) async {
    final response = await _registerApiService.register(req);
    print("reg response is ${response.userId}");

    final AuthService authService = getIt<AuthService>();
    await authService.saveAuthInfo(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        userId: response.userId,
        role: response.role,
        confirmed: response.confirmed,
        email: response.email);

    print("reg response is $response");

    // Return email for navigation to confirmation screen if needed
    return response.email;
  }
}
