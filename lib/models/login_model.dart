class LoginRequest {
  final String username;
  final String password;

  LoginRequest({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class LoginResponse {
  final bool success;
  final String? token;
  final String message;
  final int timestamp;

  LoginResponse({
    required this.success,
    this.token,
    required this.message,
    required this.timestamp,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      token: json['token'],
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }
}

class RegisterRequest {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? phone;

  RegisterRequest({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }
}