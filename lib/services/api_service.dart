import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travel_tour_app/constants/api_endpoints.dart';
import 'package:travel_tour_app/services/storage_service.dart';

class ApiService {
  final StorageService _storageService = StorageService();
  final String baseUrl = ApiEndpoints.baseUrl;

  // Helper method to get headers with auth token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    print('🔑 Current token: $token'); // Debug print

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      print('📤 Adding Authorization header');
    }

    return headers;
  }

  // Helper method to handle errors
  String _handleError(http.Response response) {
    try {
      final data = json.decode(response.body);
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
      return 'Error: ${response.statusCode}';
    } catch (e) {
      return 'Error: ${response.statusCode}';
    }
  }

  // Authentication
  Future<http.Response> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.login}'),
        headers: await _getHeaders(),
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 401) {
        await _storageService.clearStorage();
      }

      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> register(Map<String, dynamic> userData) async {
    try {
      return await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.register}'),
        headers: await _getHeaders(),
        body: json.encode(userData),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.logout}'),
        headers: await _getHeaders(),
      );
      await _storageService.clearStorage();
      return response;
    } catch (e) {
      await _storageService.clearStorage();
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> validateToken() async {
    final token = await _storageService.getToken();
    try {
      return await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.validateToken}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Tours
  Future<http.Response> getAllTours() async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getAllTours}'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> getTourById(int id) async {
    try {
      final url = '$baseUrl${ApiEndpoints.getTourById}$id';
      print('🔗 Fetching tour from: $url');

      return await http.get(Uri.parse(url), headers: await _getHeaders());
    } catch (e) {
      print('❌ Network error in getTourById: $e');
      throw Exception('Network error: $e');
    }
  }

  // Future<http.Response> getTourById(int id) async {
  //   try {
  //     return await http.get(
  //       Uri.parse('$baseUrl${ApiEndpoints.getTourById}$id'),
  //       headers: await _getHeaders(),
  //     );
  //   } catch (e) {
  //     throw Exception('Network error: $e');
  //   }
  // }

  Future<http.Response> searchTours(String query) async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.searchTours}?q=$query'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> createTour(Map<String, dynamic> tourData) async {
    try {
      return await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.createTour}'),
        headers: await _getHeaders(),
        body: json.encode(tourData),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Flights
  Future<http.Response> searchFlights(Map<String, dynamic> searchData) async {
    try {
      return await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.searchFlights}'),
        headers: await _getHeaders(),
        body: json.encode(searchData),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> getAllFlights() async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getAllFlights}'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> getFlightById(int id) async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getFlightById}$id'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> createFlight(Map<String, dynamic> flightData) async {
    try {
      return await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.createFlight}'),
        headers: await _getHeaders(),
        body: json.encode(flightData),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Bookings
  Future<http.Response> createBooking(Map<String, dynamic> bookingData) async {
    try {
      return await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.createBooking}'),
        headers: await _getHeaders(),
        body: json.encode(bookingData),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> getUserBookings(int userId) async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getUserBookings}$userId'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> getBookingByReference(String reference) async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getBookingByReference}$reference'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> updateBooking(
    int id,
    Map<String, dynamic> bookingData,
  ) async {
    try {
      return await http.put(
        Uri.parse('$baseUrl${ApiEndpoints.updateBooking}$id'),
        headers: await _getHeaders(),
        body: json.encode(bookingData),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> cancelBooking(int id) async {
    try {
      return await http.delete(
        Uri.parse('$baseUrl${ApiEndpoints.cancelBooking}$id'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Users
  Future<http.Response> getUserProfile() async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getUserProfile}'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> updateProfile(Map<String, dynamic> userData) async {
    try {
      return await http.put(
        Uri.parse('$baseUrl${ApiEndpoints.updateProfile}'),
        headers: await _getHeaders(),
        body: json.encode(userData),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> getAllUsers() async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getAllUsers}'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> getUserById(int id) async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getUserById}$id'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Admin
  Future<http.Response> getDashboardStats() async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.dashboardStats}'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> getBookingStats() async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.bookingStats}'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> getSalesReport(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final params = {
        'startDate': startDate.toIso8601String().split('T')[0],
        'endDate': endDate.toIso8601String().split('T')[0],
      };
      final uri = Uri.parse(
        '$baseUrl${ApiEndpoints.salesReport}',
      ).replace(queryParameters: params);

      return await http.get(uri, headers: await _getHeaders());
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> getPopularToursReport() async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.popularToursReport}'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> getRevenueReport(int? year, int? month) async {
    try {
      final params = <String, String>{};
      if (year != null) params['year'] = year.toString();
      if (month != null) params['month'] = month.toString();

      final uri = Uri.parse(
        '$baseUrl${ApiEndpoints.revenueReport}',
      ).replace(queryParameters: params.isEmpty ? null : params);

      return await http.get(uri, headers: await _getHeaders());
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Airports
  Future<http.Response> getAllAirports() async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getAllAirports}'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> createAirport(Map<String, dynamic> airportData) async {
    try {
      return await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.createAirport}'),
        headers: await _getHeaders(),
        body: json.encode(airportData),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> updateAirport(
    String code,
    Map<String, dynamic> airportData,
  ) async {
    try {
      return await http.put(
        Uri.parse('$baseUrl${ApiEndpoints.updateAirport}$code'),
        headers: await _getHeaders(),
        body: json.encode(airportData),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> deleteAirport(String code) async {
    try {
      return await http.delete(
        Uri.parse('$baseUrl${ApiEndpoints.deleteAirport}$code'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<http.Response> getAirportByCode(String code) async {
    try {
      return await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getAirportByCode}$code'),
        headers: await _getHeaders(),
      );
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Helper method to check network connectivity (optional)
  Future<bool> checkConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/health'),
        headers: await _getHeaders(),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Parse response to JSON
  Map<String, dynamic> parseJson(http.Response response) {
    return json.decode(response.body);
  }

  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/actuator/health'),
        headers: {'Accept': 'application/json'},
      );
      print('✅ Connection test response: ${response.statusCode}');
      print('✅ Response body: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Connection failed: $e');
      return false;
    }
  }

  Future<bool> testServerConnection() async {
    try {
      print('🔗 Testing connection to: $baseUrl/api/auth/test-public');

      final response = await http.get(
        Uri.parse('$baseUrl/api/auth/test-public'),
        headers: {'Accept': 'application/json'},
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Server is running!');
        return true;
      } else {
        print('❌ Server returned error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Network error: $e');
      return false;
    }
  }
}
