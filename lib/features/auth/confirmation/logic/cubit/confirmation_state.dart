abstract class EmailConfirmationState {}

class EmailConfirmationInitial extends EmailConfirmationState {}

class EmailConfirmationLoading extends EmailConfirmationState {}

// Replaced EmailConfirmationSuccess with two more specific states
class EmailConfirmationOtpSent extends EmailConfirmationState {
  final String message;
  final String email;

  EmailConfirmationOtpSent(this.message, this.email);
}

class EmailConfirmationVerified extends EmailConfirmationState {
  final String message;

  EmailConfirmationVerified(this.message);
}

class EmailConfirmationFailure extends EmailConfirmationState {
  final String message;
  EmailConfirmationFailure(this.message);
}

class EmailConfirmationStatusChecked extends EmailConfirmationState {
  final bool isConfirmed;
  EmailConfirmationStatusChecked(this.isConfirmed);
}
