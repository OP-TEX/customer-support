import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:support/features/auth/forgetpassword/data/repos/forgetpassword_repo.dart';
import 'package:support/features/auth/forgetpassword/logic/cubit/forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgetPasswordRepo repository;

  ForgetPasswordCubit({required this.repository})
      : super(ForgotPasswordInitial());

  Future<void> sendEmail(String email) async {
    emit(ForgotPasswordLoading());
    try {
      final forgotToken = await repository.forgotPassword(email);
      emit(ForgotPasswordEmailSent(forgotToken));
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }

  Future<void> verifyOtp(String email, String forgotToken, String otp) async {
    emit(ForgotPasswordLoading());
    try {
      final resetToken = await repository.confirmOtp(
        email: email,
        forgotToken: forgotToken,
        otp: otp,
      );
      emit(ForgotPasswordOtpVerified(resetToken));
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }

  Future<void> resetPassword(
      String email, String newPassword, String resetToken) async {
    emit(ForgotPasswordLoading());
    try {
      final userData = await repository.resetPassword(
        email: email,
        newPassword: newPassword,
        resetToken: resetToken,
      );
      emit(ForgotPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordError(e.toString()));
    }
  }
}
