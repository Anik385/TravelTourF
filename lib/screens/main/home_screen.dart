import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_tour_app/providers/tour_provider.dart';
import 'package:travel_tour_app/providers/flight_provider.dart';
import 'package:travel_tour_app/widgets/tour_card.dart';
import 'package:travel_tour_app/widgets/flight_card.dart';
import 'package:travel_tour_app/widgets/bottom_navbar.dart';
import 'package:travel_tour_app/widgets/app_drawer.dart';
import 'package:travel_tour_app/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TourProvider>(context, listen: false).fetchTours();
      Provider.of<FlightProvider>(context, listen: false).fetchFlights();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tourProvider = Provider.of<TourProvider>(context);
    final flightProvider = Provider.of<FlightProvider>(context);

    return Scaffold(
      drawer: const AppDrawer(), // Add drawer
      appBar: AppBar(
        title: const Text('Travel & Tour'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await tourProvider.fetchTours();
          await flightProvider.fetchFlights();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ready for your next adventure?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Explore amazing tours and flights around the world',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.airplanemode_active,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Quick Actions Row
              Row(
                children: [
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.airplane_ticket,
                      label: 'Flights',
                      color: AppColors.primaryColor,
                      onTap: () {
                        setState(() => _currentIndex = 2);
                        context.go('/flights');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.landscape,
                      label: 'Tours',
                      color: AppColors.secondaryColor,
                      onTap: () {
                        setState(() => _currentIndex = 1);
                        context.go('/tours');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.bookmark_border,
                      label: 'Bookings',
                      color: AppColors.accentColor,
                      onTap: () {
                        setState(() => _currentIndex = 3);
                        context.go('/bookings');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickAction(
                      icon: Icons.person_outline,
                      label: 'Profile',
                      color: AppColors.dangerColor,
                      onTap: () {
                        setState(() => _currentIndex = 4);
                        context.go('/profile');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Featured Tours Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Tours',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _currentIndex = 1);
                      context.go('/tours');
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (tourProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (tourProvider.error != null)
                Text(
                  tourProvider.error!,
                  style: TextStyle(color: AppColors.dangerColor),
                )
              else if (tourProvider.tours.isEmpty)
                const Text('No tours available')
              else
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tourProvider.tours.take(5).length,
                    itemBuilder: (context, index) {
                      final tour = tourProvider.tours[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          right: index == tourProvider.tours.length - 1
                              ? 0
                              : 12,
                        ),
                        child: TourCard(tour: tour),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 32),
              // Popular Flights Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Flights',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _currentIndex = 2);
                      context.go('/flights');
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (flightProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (flightProvider.error != null)
                Text(
                  flightProvider.error!,
                  style: TextStyle(color: AppColors.dangerColor),
                )
              else if (flightProvider.flights.isEmpty)
                const Text('No flights available')
              else
                Column(
                  children: flightProvider.flights
                      .take(3)
                      .map(
                        (flight) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FlightCard(flight: flight),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 32),
              // Promo Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Special Offer!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Get 20% off on your first booking',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() => _currentIndex = 1);
                              context.go('/tours');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Book Now'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.local_offer_outlined,
                      color: Colors.white,
                      size: 60,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavBar(
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });

      //     switch (index) {
      //       case 0:
      //         context.go('/home');
      //         break;
      //       case 1:
      //         context.go('/tours');
      //         break;
      //       case 2:
      //         context.go('/flights');
      //         break;
      //       case 3:
      //         context.go('/bookings');
      //         break;
      //       case 4:
      //         context.go('/profile');
      //         break;
      //     }
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/search');
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
