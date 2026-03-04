import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:travel_tour_app/models/booking_model.dart';
import 'package:travel_tour_app/services/api_service.dart';
import 'package:travel_tour_app/services/storage_service.dart';
import 'package:travel_tour_app/services/mock_booking_service.dart';

class BookingProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  bool useMockData = false; // Set to false when Spring Boot is fixed

  List<BookingModel> _bookings = [];
  BookingModel? _selectedBooking;
  bool _isLoading = false;
  String? _error;

  List<BookingModel> get bookings => _bookings;
  BookingModel? get selectedBooking => _selectedBooking;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalSpent {
    return _bookings
        .where((booking) => booking.status == 'CONFIRMED')
        .fold(0.0, (sum, booking) => sum + booking.totalAmount);
  }

  // Fetch user bookings
  Future<void> fetchUserBookings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (useMockData) {
        // Use mock data
        final userData = await _storageService.getUserData();
        final userId = userData?['userId'] ?? 7;

        final mockBookings = await MockBookingService.getUserBookings(userId);
        _bookings = mockBookings
            .map((item) => BookingModel.fromJson(item))
            .toList();
        print('📱 MOCK: Loaded ${_bookings.length} bookings');
        _error = null;
      } else {
        // Use real API
        final userData = await _storageService.getUserData();
        if (userData != null && userData['userId'] != null) {
          final userId = userData['userId'];
          final response = await _apiService.getUserBookings(userId);

          if (response.statusCode == 200) {
            final List<dynamic> data = json.decode(response.body);
            _bookings = data
                .map((item) => BookingModel.fromJson(item))
                .toList();
            print('📡 API: Loaded ${_bookings.length} bookings');
          } else {
            _error = 'Failed to fetch bookings: ${response.statusCode}';
          }
        } else {
          _error = 'User not logged in';
        }
      }
    } catch (e) {
      print('❌ Error fetching bookings: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create booking
  Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool success = false;

      if (useMockData) {
        // Use mock service
        print('📱 MOCK: Creating booking with data: $bookingData');
        success = await MockBookingService.createBooking(bookingData);
      } else {
        // Use real API
        print('📤 Creating booking with data: $bookingData');
        final response = await _apiService.createBooking(bookingData);
        print('📡 Create booking response: ${response.statusCode}');
        print('📡 Create booking body: ${response.body}');

        success = (response.statusCode == 201 || response.statusCode == 200);
      }

      if (success) {
        await fetchUserBookings(); // Refresh bookings list
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to create booking';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('❌ Error creating booking: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get booking by reference
  Future<void> fetchBookingByReference(String reference) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (useMockData) {
        // Mock implementation
        final userData = await _storageService.getUserData();
        final userId = userData?['userId'] ?? 7;
        final mockBookings = await MockBookingService.getUserBookings(userId);

        _selectedBooking = mockBookings
            .map((item) => BookingModel.fromJson(item))
            .firstWhere(
              (b) => b.bookingReference == reference,
              orElse: () => throw Exception('Booking not found'),
            );
      } else {
        final response = await _apiService.getBookingByReference(reference);
        if (response.statusCode == 200) {
          _selectedBooking = BookingModel.fromJson(json.decode(response.body));
        } else {
          _error = 'Booking not found';
        }
      }
      _error = null;
    } catch (e) {
      print('❌ Error fetching booking: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update booking
  Future<bool> updateBooking(int id, Map<String, dynamic> bookingData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool success = false;

      if (useMockData) {
        // Mock implementation
        print('📱 MOCK: Updating booking $id');
        success = true;
      } else {
        final response = await _apiService.updateBooking(id, bookingData);
        success = response.statusCode == 200;
      }

      if (success) {
        await fetchUserBookings(); // Refresh bookings
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to update booking';
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

  // Cancel booking
  Future<bool> cancelBooking(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool success = false;

      if (useMockData) {
        success = await MockBookingService.cancelBooking(id);
      } else {
        final response = await _apiService.cancelBooking(id);
        success = response.statusCode == 204 || response.statusCode == 200;
      }

      if (success) {
        await fetchUserBookings(); // Refresh bookings
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to cancel booking';
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

  // Toggle mock data (for development)
  void toggleMockData(bool value) {
    useMockData = value;
    fetchUserBookings(); // Refresh with new setting
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear selected booking
  void clearSelectedBooking() {
    _selectedBooking = null;
    notifyListeners();
  }
}

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:travel_tour_app/models/booking_model.dart';
// import 'package:travel_tour_app/services/api_service.dart';
// import 'package:travel_tour_app/services/storage_service.dart';

// class BookingProvider with ChangeNotifier {
//   final ApiService _apiService = ApiService();
//   final StorageService _storageService = StorageService();

//   List<BookingModel> _bookings = [];
//   BookingModel? _selectedBooking;
//   bool _isLoading = false;
//   String? _error;

//   List<BookingModel> get bookings => _bookings;
//   BookingModel? get selectedBooking => _selectedBooking;
//   bool get isLoading => _isLoading;
//   String? get error => _error;

//   double get totalSpent {
//     return _bookings
//         .where((booking) => booking.status == 'CONFIRMED')
//         .fold(0.0, (sum, booking) => sum + booking.totalAmount);
//   }

//   // Fetch user bookings
//   Future<void> fetchUserBookings() async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final userData = await _storageService.getUserData();
//       if (userData != null && userData['userId'] != null) {
//         final userId = userData['userId'];
//         final response = await _apiService.getUserBookings(userId);

//         _bookings = (jsonDecode(response.body) as List)
//             .map((item) => BookingModel.fromJson(item))
//             .toList();
//         _error = null;
//       } else {
//         _error = 'User not logged in';
//       }
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Create booking
//   Future<bool> createBooking(Map<String, dynamic> bookingData) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       // DON'T check userData here - backend gets from token
//       print('📤 Creating booking with data: $bookingData');

//       final response = await _apiService.createBooking(bookingData);
//       print('📡 Create booking response: ${response.statusCode}');
//       print('📡 Create booking body: ${response.body}');

//       if (response.statusCode == 201 || response.statusCode == 200) {
//         await fetchUserBookings(); // Refresh bookings list
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _error = 'Failed to create booking';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       print('❌ Error creating booking: $e');
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }
//   // Future<bool> createBooking(Map<String, dynamic> bookingData) async {
//   //   _isLoading = true;
//   //   _error = null;
//   //   notifyListeners();

//   //   try {
//   //     final userData = await _storageService.getUserData();
//   //     if (userData != null && userData['userId'] != null) {
//   //       bookingData['userId'] = userData['userId'];
//   //       bookingData['bookingDate'] = DateTime.now().toIso8601String();
//   //       bookingData['status'] = 'CONFIRMED';

//   //       final response = await _apiService.createBooking(bookingData);
//   //       if (response.statusCode == 201) {
//   //         await fetchUserBookings(); // Refresh bookings
//   //         _isLoading = false;
//   //         notifyListeners();
//   //         return true;
//   //       } else {
//   //         _error = 'Failed to create booking';
//   //         _isLoading = false;
//   //         notifyListeners();
//   //         return false;
//   //       }
//   //     } else {
//   //       _error = 'User not logged in';
//   //       _isLoading = false;
//   //       notifyListeners();
//   //       return false;
//   //     }
//   //   } catch (e) {
//   //     _error = e.toString();
//   //     _isLoading = false;
//   //     notifyListeners();
//   //     return false;
//   //   }
//   // }

//   // Get booking by reference
//   Future<void> fetchBookingByReference(String reference) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final response = await _apiService.getBookingByReference(reference);
//       _selectedBooking = BookingModel.fromJson(jsonDecode(response.body));
//       _error = null;
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Update booking
//   Future<bool> updateBooking(int id, Map<String, dynamic> bookingData) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final response = await _apiService.updateBooking(id, bookingData);
//       if (response.statusCode == 200) {
//         await fetchUserBookings(); // Refresh bookings
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _error = 'Failed to update booking';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   // Cancel booking
//   Future<bool> cancelBooking(int id) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       await _apiService.cancelBooking(id);
//       await fetchUserBookings(); // Refresh bookings
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   // Clear error
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }

//   // Clear selected booking
//   void clearSelectedBooking() {
//     _selectedBooking = null;
//     notifyListeners();
//   }
// }
