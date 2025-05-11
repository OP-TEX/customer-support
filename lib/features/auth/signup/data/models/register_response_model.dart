class RegisterResponse {
final String accessToken;
  final String refreshToken;
  final String userId;
  final String role = 'customer';
  final String email;
  final bool confirmed;

  RegisterResponse({
    required this.userId,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
    this.confirmed = false,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    print(json);
    return RegisterResponse(
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      confirmed: json['confirmed'] ?? false,
    );
  }
}
