import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_tour_app/screens/admin/admin_dashboard_screen.dart';
import 'package:travel_tour_app/screens/admin/flight_management_screen.dart';
import 'package:travel_tour_app/screens/admin/tour_management_screen.dart';
import 'package:travel_tour_app/screens/admin/user_management_screen.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_tour_app/screens/auth/login_screen.dart';
import 'package:travel_tour_app/screens/bookings/booking_confirmation_screen.dart';
import 'package:travel_tour_app/screens/bookings/create_booking_screen.dart';
import 'package:travel_tour_app/screens/common/splash_screen.dart';
import 'package:travel_tour_app/screens/flights/flight_passenger_details.dart';
import 'package:travel_tour_app/screens/flights/flight_seat_selection_screen.dart';
import 'package:travel_tour_app/screens/main/home_screen.dart';
import 'package:travel_tour_app/screens/auth/register_screen.dart';
import 'package:travel_tour_app/screens/main/main_wrapper.dart';
import 'package:travel_tour_app/screens/maps/flight_route_map.dart';
import 'package:travel_tour_app/screens/maps/tour_location_map.dart';
import 'package:travel_tour_app/screens/payment/payment_failed_screen.dart';
import 'package:travel_tour_app/screens/payment/payment_success_screen.dart';
import 'package:travel_tour_app/screens/tours/tour_detail_screen.dart';
import 'package:travel_tour_app/screens/tours/tour_list_screen.dart';
import 'package:travel_tour_app/screens/flights/flight_list_screen.dart';
import 'package:travel_tour_app/screens/bookings/booking_list_screen.dart';
import 'package:travel_tour_app/screens/profile/profile_screen.dart';
import 'package:travel_tour_app/screens/tours/tour_search_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // Set splash as initial route for testing
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainWrapper(), // CHANGE THIS
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/tours',
        name: 'tours',
        builder: (context, state) => const TourListScreen(),
      ),
      GoRoute(
        path: '/flights',
        name: 'flights',
        builder: (context, state) => const FlightListScreen(),
      ),
      GoRoute(
        path: '/bookings',
        name: 'bookings',
        builder: (context, state) => const BookingListScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/users',
        name: 'admin-users',
        builder: (context, state) => const UserManagementScreen(),
      ),
      GoRoute(
        path: '/admin/tours',
        name: 'admin-tours',
        builder: (context, state) => const TourManagementScreen(),
      ),
      GoRoute(
        path: '/admin/flights',
        name: 'admin-flights',
        builder: (context, state) => const FlightManagementScreen(),
      ),
      GoRoute(
        path: '/tour-search',
        name: 'tour-search',
        builder: (context, state) => const TourSearchScreen(),
      ),
      GoRoute(
        path: '/create-booking',
        name: 'create-booking',
        builder: (context, state) {
          final args = state.extra as Map? ?? {};
          return CreateBookingScreen(
            tourId: args['tourId'],
            flightId: args['flightId'],
          );
        },
      ),
      GoRoute(
        path: '/booking-confirmation',
        name: 'booking-confirmation',
        builder: (context, state) => const BookingConfirmationScreen(),
      ),
      GoRoute(
        path: '/seat-selection',
        name: 'seat-selection',
        builder: (context, state) {
          final args = state.extra as Map? ?? {};
          return FlightSeatSelectionScreen(
            flightData: args['flightData'] ?? {},
            passengers: args['passengers'] ?? 1,
          );
        },
      ),
      GoRoute(
        path: '/flight-passenger-details',
        name: 'flight-passenger-details',
        builder: (context, state) => const FlightPassengerDetailsScreen(),
      ),
      GoRoute(
        path: '/payment-success',
        name: 'payment-success',
        builder: (context, state) => const PaymentSuccessScreen(),
      ),
      GoRoute(
        path: '/payment-failed',
        name: 'payment-failed',
        builder: (context, state) => const PaymentFailedScreen(),
      ),
      GoRoute(
        path: '/tour/:id', // Make sure this matches exactly
        name: 'tour-detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return TourDetailScreen(tourId: id);
        },
      ),
      GoRoute(
        path: '/flight-route-map',
        name: 'flight-route-map',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return FlightRouteMap(flightData: args);
        },
      ),
      GoRoute(
        path: '/tour-location-map',
        name: 'tour-location-map',
        builder: (context, state) {
          final args = state.extra as Map? ?? {};
          return TourLocationMap(
            tourName: args['tourName'] ?? 'Tour',
            location: args['location'] ?? const LatLng(23.83, 90.41),
            nearbyAttractions:
                (args['attractions'] as List?)?.cast<Map<String, dynamic>>() ??
                [],
          );
        },
      ),
      // GoRoute(
      //   path: '/tour-location-map',
      //   name: 'tour-location-map',
      //   builder: (context, state) {
      //     final args = state.extra as Map? ?? {};
      //     return TourLocationMap(
      //       tourName: args['tourName'] ?? 'Tour',
      //       location: args['location'] ?? const LatLng(23.83, 90.41),
      //       nearbyAttractions: args['attractions'] ?? [],
      //     );
      //   },
      // ),
    ],
  );
}

// import 'package:go_router/go_router.dart';
// import 'package:travel_tour_app/screens/auth/login_screen.dart';
// import 'package:travel_tour_app/screens/auth/register_screen.dart';
// // import 'package:travel_tour_app/screens/common/test_connection_screen.dart';
// import 'package:travel_tour_app/screens/main/home_screen.dart';
// import 'package:travel_tour_app/screens/tours/tour_list_screen.dart';
// import 'package:travel_tour_app/screens/tours/tour_detail_screen.dart';
// import 'package:travel_tour_app/screens/flights/flight_list_screen.dart';
// import 'package:travel_tour_app/screens/flights/flight_search_screen.dart';
// import 'package:travel_tour_app/screens/bookings/booking_list_screen.dart';
// import 'package:travel_tour_app/screens/profile/profile_screen.dart';
// import 'package:travel_tour_app/screens/admin/admin_dashboard_screen.dart';

// class AppRouter {
//   static final GoRouter router = GoRouter(
//     initialLocation: '/login', // Set test as initial route
//     routes: [
//       // Test route
//       // GoRoute(
//       //   path: '/test',
//       //   name: 'test',
//       //   builder: (context, state) => const TestConnectionScreen(),
//       // ),
//       // Auth Routes
//       GoRoute(
//         path: '/login',
//         name: 'login',
//         builder: (context, state) => const LoginScreen(),
//       ),
//       GoRoute(
//         path: '/register',
//         name: 'register',
//         builder: (context, state) => const RegisterScreen(),
//       ),
//       // Main Routes
//       GoRoute(
//         path: '/home',
//         name: 'home',
//         builder: (context, state) => const HomeScreen(),
//       ),
//       // Tour Routes
//       GoRoute(
//         path: '/tours',
//         name: 'tours',
//         builder: (context, state) => const TourListScreen(),
//       ),
//       GoRoute(
//         path: '/tour/:id',
//         name: 'tour-detail',
//         builder: (context, state) {
//           final id = int.parse(state.pathParameters['id']!);
//           return TourDetailScreen(tourId: id);
//         },
//       ),
//       // Flight Routes
//       GoRoute(
//         path: '/flights',
//         name: 'flights',
//         builder: (context, state) => const FlightListScreen(),
//       ),
//       GoRoute(
//         path: '/flight-search',
//         name: 'flight-search',
//         builder: (context, state) => const FlightSearchScreen(),
//       ),
//       // Booking Routes
//       GoRoute(
//         path: '/bookings',
//         name: 'bookings',
//         builder: (context, state) => const BookingListScreen(),
//       ),
//       // Profile Route
//       GoRoute(
//         path: '/profile',
//         name: 'profile',
//         builder: (context, state) => const ProfileScreen(),
//       ),
//       // Admin Routes
//       GoRoute(
//         path: '/admin',
//         name: 'admin',
//         builder: (context, state) => const AdminDashboardScreen(),
//       ),
//     ],
//     redirect: (context, state) {
//       // Add authentication check here
//       // For now, always allow navigation
//       return null;
//     },
//   );
// }
