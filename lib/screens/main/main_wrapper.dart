import 'package:flutter/material.dart';
import 'package:travel_tour_app/widgets/bottom_navbar.dart';
import 'package:travel_tour_app/screens/main/home_screen.dart';
import 'package:travel_tour_app/screens/tours/tour_list_screen.dart';
import 'package:travel_tour_app/screens/flights/flight_list_screen.dart';
import 'package:travel_tour_app/screens/bookings/booking_list_screen.dart';
import 'package:travel_tour_app/screens/profile/profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TourListScreen(),
    const FlightListScreen(),
    const BookingListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
