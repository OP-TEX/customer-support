

import 'package:support/features/auth/confirmation/data/services/confirmation_api_service.dart';

class EmailConfirmationRepo {
  final ConfirmationApiService _apiService;

  EmailConfirmationRepo(this._apiService);

  Future<String> resendConfirmationEmail(String email) async {
    final response = await _apiService.sendConfirmationEmail(email);
    return response['token'] ?? '';
  }

  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String token,
    required String otp,
  }) async {
    return await _apiService.confirmEmail(
      email: email,
      token: token,
      otp: otp,
    );
  }
}
