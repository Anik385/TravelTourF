import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_tour_app/providers/admin_provider.dart';
import 'package:travel_tour_app/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Add a small delay to prevent multiple calls
    Future.delayed(Duration.zero, () {
      if (mounted) {
        final adminProvider = Provider.of<AdminProvider>(
          context,
          listen: false,
        );
        // Check if already loading
        if (!adminProvider.isLoading) {
          adminProvider.fetchDashboardStats();
          adminProvider.fetchBookingStats();
        }
      }
    });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<AdminProvider>(context, listen: false).fetchDashboardStats();
  //         Provider.of<AdminProvider>(context, listen: false).fetchBookingStats();

  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          // WRAP WITH BUILDER
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              adminProvider.fetchDashboardStats();
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: adminProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.person, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Welcome, Admin',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateTime.now().toString().substring(0, 10),
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Stats Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildStatCard(
                        'Total Users',
                        adminProvider.dashboardStats?.totalUsers.toString() ??
                            '0',
                        Icons.people,
                        AppColors.primaryColor,
                      ),
                      _buildStatCard(
                        'Total Tours',
                        adminProvider.dashboardStats?.totalTours.toString() ??
                            '0',
                        Icons.landscape,
                        AppColors.secondaryColor,
                      ),
                      _buildStatCard(
                        'Total Flights',
                        adminProvider.dashboardStats?.totalFlights.toString() ??
                            '0',
                        Icons.flight,
                        AppColors.accentColor,
                      ),
                      _buildStatCard(
                        'Total Bookings',
                        adminProvider.dashboardStats?.totalBookings
                                .toString() ??
                            '0',
                        Icons.book_online,
                        AppColors.dangerColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Revenue Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildRevenueCard(
                          'Monthly Revenue',
                          '\$${adminProvider.dashboardStats?.monthlyRevenue.toStringAsFixed(2) ?? '0.00'}',
                          AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildRevenueCard(
                          'Yearly Revenue',
                          '\$${adminProvider.dashboardStats?.yearlyRevenue.toStringAsFixed(2) ?? '0.00'}',
                          AppColors.successColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Recent Bookings
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Bookings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (adminProvider.dashboardStats?.recentBookings !=
                              null)
                            ...adminProvider.dashboardStats!.recentBookings
                                .take(5)
                                .map(
                                  (booking) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: const CircleAvatar(
                                        child: Icon(Icons.receipt),
                                      ),
                                      title: Text(booking.customerName),
                                      subtitle: Text(booking.tourName),
                                      trailing: Text(
                                        '\$${booking.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList()
                          else
                            const Text('No recent bookings'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Popular Tours
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Popular Tours',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (adminProvider.dashboardStats?.popularTours !=
                              null)
                            ...adminProvider.dashboardStats!.popularTours
                                .take(5)
                                .map(
                                  (tour) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: const CircleAvatar(
                                        child: Icon(Icons.landscape),
                                      ),
                                      title: Text(tour.tourName),
                                      subtitle: Text(
                                        '${tour.bookingsCount} bookings',
                                      ),
                                      trailing: Text(
                                        '\$${tour.totalRevenue.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList()
                          else
                            const Text('No tour data'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Quick Actions
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildQuickAction(Icons.person_add, 'Add User', () {
                        context.push('/admin/users/add');
                        // Navigator.pushNamed(context, '/admin/users/add');
                      }),
                      _buildQuickAction(Icons.landscape, 'Add Tour', () {
                        context.push('/admin/tours/add');
                      }),
                      _buildQuickAction(Icons.flight, 'Add Flight', () {
                        context.push('/admin/flights/add');
                        // Navigator.pushNamed(context, '/admin/flights/add');
                      }),
                      _buildQuickAction(Icons.airport_shuttle, 'Airports', () {
                        context.push('/admin/airports');
                        // Navigator.pushNamed(context, '/admin/airports');
                      }),
                      _buildQuickAction(Icons.analytics, 'Reports', () {
                        context.push('/admin/reports');
                        // Navigator.pushNamed(context, '/admin/reports');
                      }),
                      _buildQuickAction(Icons.settings, 'Settings', () {
                        context.push('/admin/settings');
                      }),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryColor),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 36,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Management',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('User Management'),
            onTap: () {
              // Navigator.pushNamed(context, '/admin/users');
              context.go('/admin/users');
            },
          ),
          ListTile(
            leading: const Icon(Icons.landscape),
            title: const Text('Tour Management'),
            onTap: () {
              // Navigator.pushNamed(context, '/admin/tours');
              context.go('/admin/tours');
            },
          ),
          ListTile(
            leading: const Icon(Icons.flight),
            title: const Text('Flight Management'),
            onTap: () {
              context.go('/admin/flights');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_online),
            title: const Text('Booking Management'),
            onTap: () {
              context.go('/admin/bookings');
            },
          ),
          ListTile(
            leading: const Icon(Icons.airport_shuttle),
            title: const Text('Airport Management'),
            onTap: () {
              context.go('/admin/airports');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Reports & Analytics'),
            onTap: () {
              context.go('/admin/reports');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              context.go('/admin/settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              // Implement logout
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueCard(String title, String amount, Color color) {
    return Card(
      elevation: 2,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.borderColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: AppColors.primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
