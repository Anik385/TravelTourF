import 'dart:convert';

class MockBookingService {
  // Mock database - stores bookings in memory
  static List<Map<String, dynamic>> _mockBookings = [];

  // Create booking (always succeeds)
  static Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    print('📱 MOCK: Creating booking with data: $bookingData');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Generate booking reference
    final bookingRef = 'TRV-${DateTime.now().millisecondsSinceEpoch}';

    // Create mock booking
    final newBooking = {
      'id': _mockBookings.length + 1,
      'bookingReference': bookingRef,
      'userId': 7, // Mock user ID
      'tourId': bookingData['tourId'],
      'travelDate': bookingData['travelDate'],
      'numberOfGuests': bookingData['numberOfGuests'],
      'totalAmount': bookingData['totalAmount'],
      'bookingDate': DateTime.now().toIso8601String().split('T')[0],
      'status': 'CONFIRMED',
    };

    _mockBookings.add(newBooking);
    print('✅ MOCK: Booking created successfully: $bookingRef');
    return true;
  }

  // Get user bookings
  static Future<List<Map<String, dynamic>>> getUserBookings(int userId) async {
    print('📱 MOCK: Fetching bookings for user: $userId');
    await Future.delayed(const Duration(milliseconds: 500));

    // Return mock bookings (filter by userId if needed)
    return _mockBookings.isEmpty
        ? _getDefaultMockBookings(userId)
        : _mockBookings;
  }

  // Default mock bookings if none exist
  static List<Map<String, dynamic>> _getDefaultMockBookings(int userId) {
    return [
      {
        'id': 1,
        'bookingReference': 'TRV-123456789',
        'userId': userId,
        'tourId': 2,
        'tourTitle': 'Tokyo City Break',
        'travelDate': DateTime.now()
            .add(const Duration(days: 7))
            .toIso8601String()
            .split('T')[0],
        'numberOfGuests': 2,
        'totalAmount': 2400.0,
        'bookingDate': DateTime.now().toIso8601String().split('T')[0],
        'status': 'CONFIRMED',
      },
      {
        'id': 2,
        'bookingReference': 'TRV-987654321',
        'userId': userId,
        'tourId': 1,
        'tourTitle': 'Bali Tour',
        'travelDate': DateTime.now()
            .add(const Duration(days: 14))
            .toIso8601String()
            .split('T')[0],
        'numberOfGuests': 1,
        'totalAmount': 899.0,
        'bookingDate': DateTime.now().toIso8601String().split('T')[0],
        'status': 'PENDING',
      },
    ];
  }

  // Cancel booking
  static Future<bool> cancelBooking(int bookingId) async {
    print('📱 MOCK: Cancelling booking: $bookingId');
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _mockBookings.indexWhere((b) => b['id'] == bookingId);
    if (index != -1) {
      _mockBookings[index]['status'] = 'CANCELLED';
    }
    return true;
  }

  // Clear all mock data (for testing)
  static void clearMockData() {
    _mockBookings.clear();
  }
}
