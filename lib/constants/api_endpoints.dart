class ApiEndpoints {
  // In constants/api_endpoints.dart
  static const String baseUrl = 'http://192.168.0.158:8080';
  // static const String baseUrl = 'http://10.101.189.122:8080';
  // static const String baseUrl = 'http://10.0.2.2:8080'; // Android emulator
  // static const String baseUrl = 'http://localhost:8080'; // iOS simulator
  // static const String baseUrl = 'http://your-ip:8080'; // Real device

  // Authentication
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String logout = '/api/auth/logout';
  static const String validateToken = '/api/auth/validate';
  static const String initAdmin = '/api/auth/init-admin';
  static const String checkUsername = '/api/auth/check-username/';
  static const String checkEmail = '/api/auth/check-email/';

  // Tours
  static const String getAllTours = '/api/tours';
  static const String searchTours = '/api/tours/search';
  static const String toursByDestination = '/api/tours/destination/';
  static const String getTourById = '/api/tours/';
  static const String createTour = '/api/tours';
  static const String updateTour = '/api/tours/';
  static const String deleteTour = '/api/tours/';

  // Flights
  static const String searchFlights = '/api/flights/search';
  static const String getAllFlights = '/api/flights';
  static const String getFlightById = '/api/flights/';
  static const String createFlight = '/api/flights';
  static const String updateFlight = '/api/flights/';
  static const String deleteFlight = '/api/flights/';

  // Bookings
  static const String createBooking = '/api/bookings';
  static const String getUserBookings = '/api/bookings/user/';
  static const String getBookingByReference = '/api/bookings/reference/';
  static const String updateBooking = '/api/bookings/';
  static const String cancelBooking = '/api/bookings/';

  // Users
  static const String getUserProfile = '/api/users/profile';
  static const String updateProfile = '/api/users/profile';
  static const String getAllUsers = '/api/users';
  static const String getUserById = '/api/users/';
  static const String updateUser = '/api/users/';
  static const String deleteUser = '/api/users/';

  // Airports
  static const String getAllAirports = '/api/airports';
  static const String createAirport = '/api/airports';
  static const String updateAirport = '/api/airports/';
  static const String deleteAirport = '/api/airports/';
  static const String getAirportByCode = '/api/airports/';

  // Admin
  static const String adminBase = '/api/admin';
  static const String initRoles = '/api/admin/roles/init';
  static const String getAllRoles = '/api/admin/roles';
  static const String createRole = '/api/admin/roles';
  static const String deleteRole = '/api/admin/roles/';

  static const String adminUsers = '/api/admin/users';
  static const String updateUserRole = '/api/admin/users/role';
  static const String updateUserStatus = '/api/admin/users/status';

  static const String adminTours = '/api/admin/tours';
  static const String updateTourStatus = '/api/admin/tours/status';

  static const String adminFlights = '/api/admin/flights';

  static const String adminBookings = '/api/admin/bookings';
  static const String bookingStats = '/api/admin/bookings/stats';
  static const String updateBookingStatus = '/api/admin/bookings/status';

  static const String dashboardStats = '/api/admin/dashboard/stats';
  static const String salesReport = '/api/admin/reports/sales';
  static const String popularToursReport = '/api/admin/reports/popular-tours';
  static const String revenueReport = '/api/admin/reports/revenue';
}
