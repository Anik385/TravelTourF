import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_tour_app/providers/admin_provider.dart';
import 'package:travel_tour_app/providers/auth_provider.dart';
import 'package:travel_tour_app/providers/tour_provider.dart';
import 'package:travel_tour_app/providers/booking_provider.dart';
import 'package:travel_tour_app/providers/flight_provider.dart';
import 'package:travel_tour_app/routes/app_router.dart';
import 'package:travel_tour_app/services/api_service.dart';
import 'package:travel_tour_app/services/auth_service.dart';
import 'package:travel_tour_app/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TourProvider()),
        ChangeNotifierProvider(create: (_) => FlightProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => AuthService()),
      ],
      child: MaterialApp.router(
        title: 'Travel & Tour',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Inter',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
