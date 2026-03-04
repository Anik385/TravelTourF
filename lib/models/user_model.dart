class UserModel {
  final int? id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? role;
  final bool? enabled;

  UserModel({
    this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.role,
    this.enabled,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      enabled: json['enabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'role': role,
      'enabled': enabled,
    };
  }

  String get fullName => '$firstName $lastName';
}