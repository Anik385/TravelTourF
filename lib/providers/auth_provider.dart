import 'dart:convert';
import 'dart:convert' show base64, utf8;
import 'package:flutter/material.dart';
import 'package:travel_tour_app/models/user_model.dart';
import 'package:travel_tour_app/services/auth_service.dart';
import 'package:travel_tour_app/services/api_service.dart';
import 'package:travel_tour_app/services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _isLoggedIn;

  bool get isAdmin {
    print('👤 User role in isAdmin: ${_user?.role}');
    return _user?.role == 'ROLE_ADMIN' || _user?.role == 'ADMIN';
  }

  // Login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(username, password);

      if (response.success) {
        _isLoggedIn = true;

        // Get token from storage
        final token = await _storageService.getToken();
        print('🔑 Full token: $token');

        if (token != null) {
          final parts = token.split('.');
          print('📦 Token parts count: ${parts.length}');

          if (parts.length > 1) {
            // Decode token payload
            String normalized = base64.normalize(parts[1]);
            final payload = json.decode(utf8.decode(base64.decode(normalized)));
            print('📦 Decoded payload: $payload');

            // Get roles from token
            List<dynamic> roles = payload['roles'] ?? [];
            print('👥 Roles from token: $roles');

            String userRole = 'ROLE_USER'; // default
            if (roles.contains('ROLE_ADMIN')) {
              userRole = 'ROLE_ADMIN';
            } else if (roles.isNotEmpty) {
              userRole = roles.first;
            }
            // Create user from token data
            _user = UserModel(
              id: payload['userId'],
              username: username,
              firstName: payload['firstName'] ?? '',
              lastName: payload['lastName'] ?? '',
              email: payload['email'] ?? '',
              phone: '',
              role: userRole,
              enabled: true,
            );

            // Save user data to storage
            await _storageService.saveUserData({
              'username': username,
              'userId': _user?.id,
              'userRole': _user?.role,
              'firstName': _user?.firstName,
              'lastName': _user?.lastName,
              'email': _user?.email,
              'loggedIn': true,
            });

            print('✅ User loaded from token with role: ${_user?.role}');
          }
        }

        notifyListeners();
        return true;
      } else {
        _error = response.message;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // Register
  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.register(userData);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _authService.logout();
      _user = null;
      _isLoggedIn = false;
      await _storageService.clearStorage();
      notifyListeners();
      print('✅ User logged out');
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Check login status
  Future<bool> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isLoggedIn = await _authService.isLoggedIn();

      if (_isLoggedIn) {
        final isValid = await _authService.validateToken();
        if (!isValid) {
          await logout();
          _isLoggedIn = false;
        } else {
          // Load user from storage
          final userData = await _storageService.getUserData();
          if (userData != null) {
            _user = UserModel(
              id: userData['userId'],
              username: userData['username'] ?? '',
              firstName: userData['firstName'] ?? '',
              lastName: userData['lastName'] ?? '',
              email: userData['email'] ?? '',
              phone: userData['phone'] ?? '',
              role: userData['userRole'] ?? 'ROLE_USER',
              enabled: true,
            );
            print('✅ User loaded from storage with role: ${_user?.role}');
          }
        }
      }

      _isLoading = false;
      notifyListeners();
      return _isLoggedIn;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Set user (for profile updates)
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Call update profile API
      final response = await _apiService.updateProfile(userData);

      if (response.statusCode == 200) {
        if (_user != null) {
          _user = UserModel(
            id: _user!.id,
            username: userData['username'] ?? _user!.username,
            firstName: userData['firstName'] ?? _user!.firstName,
            lastName: userData['lastName'] ?? _user!.lastName,
            email: userData['email'] ?? _user!.email,
            phone: userData['phone'] ?? _user!.phone,
            role: _user!.role,
            enabled: _user!.enabled,
          );
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to update profile';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
