class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String role;
  final String email;
  final bool confirmed;

  LoginResponse(
      {required this.accessToken,
      required this.refreshToken,
      required this.userId,
      required this.role,
      required this.email,
      this.confirmed = false});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        userId: json['user']['_id'],
        role: 'Customer',
        email: json['user']['email'],
        confirmed: json['user']['confirmed'] ?? false);
  }
}
