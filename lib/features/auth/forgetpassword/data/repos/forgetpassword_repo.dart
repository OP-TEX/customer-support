import 'package:support/features/auth/forgetpassword/data/services/forgetpassword_api_service.dart';

class ForgetPasswordRepo {
  final ForgetPasswordApiService apiService;

  ForgetPasswordRepo({required this.apiService});

  Future<String> forgotPassword(String email) async {
    final data = await apiService.forgotPassword(email);
    return data['forgotToken'];
  }

  Future<String> confirmOtp({
    required String email,
    required String forgotToken,
    required String otp,
  }) async {
    final data = await apiService.confirmOtp(
      email: email,
      forgotToken: forgotToken,
      otp: otp,
    );
    return data['resetToken'];
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
    required String resetToken,
  }) async {
    final data = await apiService.resetPassword(
      email: email,
      newPassword: newPassword,
      resetToken: resetToken,
    );
    return data; // Contains userId, role, accessToken, refreshToken
  }
}
