
abstract class LoginState {}

final class LoginInitial extends LoginState {}
final class LoginLoading extends LoginState {}
final class LoginSuccess extends LoginState {
}

class LoginEmailNotConfirmed extends LoginState {
  final String email;
  LoginEmailNotConfirmed(this.email);
}


final class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}

