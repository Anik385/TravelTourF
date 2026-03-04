import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_tour_app/providers/auth_provider.dart';
import 'package:travel_tour_app/constants/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryColor),
            accountName: Text(user?.fullName ?? 'Guest User'),
            accountEmail: Text(user?.email ?? 'guest@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                (user?.firstName != null && user!.firstName.isNotEmpty)
                    ? user!.firstName.substring(0, 1).toUpperCase()
                    : (user?.username?.isNotEmpty ?? false)
                    ? user!.username.substring(0, 1).toUpperCase()
                    : 'G',
                style: TextStyle(
                  fontSize: 24,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () => context.go('/home'),
          ),
          ListTile(
            leading: const Icon(Icons.landscape_outlined),
            title: const Text('Tours'),
            onTap: () => context.go('/tours'),
          ),
          ListTile(
            leading: const Icon(Icons.flight_outlined),
            title: const Text('Flights'),
            onTap: () => context.go('/flights'),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_border),
            title: const Text('My Bookings'),
            onTap: () => context.go('/bookings'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () => context.go('/profile'),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () => context.go('/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Support'),
            onTap: () => context.go('/support'),
          ),

          // ... after profile section and before logout
          if (Provider.of<AuthProvider>(context).isAdmin) ...[
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'ADMIN PANEL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => context.go('/admin'),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('User Management'),
              onTap: () => context.go('/admin/users'),
            ),
            ListTile(
              leading: const Icon(Icons.landscape),
              title: const Text('Tour Management'),
              onTap: () => context.go('/admin/tours'),
            ),
            ListTile(
              leading: const Icon(Icons.flight),
              title: const Text('Flight Management'),
              onTap: () => context.go('/admin/flights'),
            ),
          ],

          // ... then continue with your existing code (Divider, Logout, etc.)
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _showLogoutDialog(context, authProvider),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await authProvider.logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
