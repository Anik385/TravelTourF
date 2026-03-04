import 'dart:convert';
import 'dart:convert' show base64, utf8;

import 'package:http/http.dart' as http;
import 'package:travel_tour_app/models/login_model.dart';
import 'package:travel_tour_app/services/api_service.dart';
import 'package:travel_tour_app/services/storage_service.dart';

import '../constants/api_endpoints.dart';

const String baseUrl =
    'http://192.168.0.158:8080'; // Update with your actual base URL
// const String baseUrl = 'http://10.101.189.122:8080'; // Update with your actual base URL
// const String baseUrlold = 'http://192.168.0.158:8080'; // Update with your actual base URL

class AuthService {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await _apiService.login(username, password);
      print('📡 Login response: ${response.statusCode}');
      print('📡 Login body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final token = data['token'];

          // Decode JWT token to get userId
          final parts = token.split('.');
          if (parts.length > 1) {
            // Decode the payload (second part)
            String normalized = base64.normalize(parts[1]);
            final payload = json.decode(utf8.decode(base64.decode(normalized)));

            print('🔓 Decoded token payload: $payload');

            // Get userId from payload (check your JWT structure)
            final userId = payload['userId'] ?? payload['id'] ?? payload['sub'];

            await _storageService.saveToken(token);
            await _storageService.saveUserData({
              'username': username,
              'userId': userId, // This is the key line
              'userRole': payload['roles'],
              'loggedIn': true,
            });

            print('✅ Saved user data with userId: $userId');
          }

          return LoginResponse.fromJson(data);
        } else {
          throw Exception(data['message'] ?? 'Login failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  // Future<LoginResponse> login(String username, String password) async {
  //   try {
  //     print('🔗 Login URL: $baseUrl${ApiEndpoints.login}');

  //     final response = await http.post(
  //       Uri.parse('$baseUrl${ApiEndpoints.login}'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({'username': username, 'password': password}),
  //     );

  //     print('📡 Login response: ${response.statusCode}');
  //     print('📡 Login body: ${response.body}');

  //     final data = json.decode(response.body);

  //     if (response.statusCode == 200 && data['success'] == true) {
  //       final token = data['token'];
  //       await _storageService.saveToken(token);
  //       await _storageService.saveUserData({
  //         'username': username,
  //         'loggedIn': true,
  //       });
  //       return LoginResponse.fromJson(data);
  //     } else {
  //       throw Exception(data['message'] ?? 'Login failed');
  //     }
  //   } catch (e) {
  //     print('❌ Login error: $e');
  //     rethrow;
  //   }
  // }

  // Future<LoginResponse> login(String username, String password) async {
  //   try {
  //     final response = await _apiService.login(username, password);
  //     final data = json.decode(response.body);

  //     if (response.statusCode == 200 && data['success'] == true) {
  //       final token = data['token'];
  //       await _storageService.saveToken(token);
  //       await _storageService.saveUserData({
  //         'username': username,
  //         'loggedIn': true,
  //       });

  //       return LoginResponse.fromJson(data);
  //     } else {
  //       throw Exception(data['message'] ?? 'Login failed');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<void> register(Map<String, dynamic> userData) async {
  //   try {
  //     final response = await _apiService.register(userData);
  //     final data = json.decode(response.body);

  //     if (data['success'] != true) {
  //       throw Exception(data['message']);
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> register(Map<String, dynamic> userData) async {
    try {
      print('📤 Sending registration request...');
      print('📤 Data: $userData');

      final response = await _apiService.register(userData);
      print('📡 Register response: ${response.statusCode}');
      print('📡 Register body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          print('✅ Registration successful: ${data['message']}');
        } else {
          throw Exception(data['message'] ?? 'Registration failed');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ??
              'Registration failed with status ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Registration error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } finally {
      await _storageService.clearStorage();
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storageService.getToken();
    return token != null;
  }

  Future<String?> getToken() async {
    return await _storageService.getToken();
  }

  Future<Map<String, dynamic>?> getUserData() async {
    return await _storageService.getUserData();
  }

  Future<bool> validateToken() async {
    try {
      await _apiService.validateToken();
      return true;
    } catch (e) {
      return false;
    }
  }
}
