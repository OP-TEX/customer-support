class UserContact {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  UserContact({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory UserContact.fromJson(Map<String, dynamic> json) {
    return UserContact(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  String get fullName => '$firstName $lastName';
}
