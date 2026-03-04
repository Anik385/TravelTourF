import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_tour_app/providers/booking_provider.dart';
import 'package:travel_tour_app/widgets/booking_card.dart';
import 'package:travel_tour_app/constants/app_colors.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).fetchUserBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final filteredBookings = _selectedFilter == 'all'
        ? bookingProvider.bookings
        : bookingProvider.bookings
              .where(
                (booking) => booking.status.toLowerCase() == _selectedFilter,
              )
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigator.pushNamed(context, '/tour-list');
              context.go('/tour-list');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Confirmed', 'confirmed'),
                const SizedBox(width: 8),
                _buildFilterChip('Pending', 'pending'),
                const SizedBox(width: 8),
                _buildFilterChip('Cancelled', 'cancelled'),
                const SizedBox(width: 8),
                _buildFilterChip('Completed', 'completed'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Stats Card
          if (bookingProvider.bookings.isNotEmpty)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      bookingProvider.bookings.length.toString(),
                      'Total',
                    ),
                    _buildStatItem(
                      bookingProvider.bookings
                          .where((b) => b.status == 'CONFIRMED')
                          .length
                          .toString(),
                      'Confirmed',
                      color: AppColors.successColor,
                    ),
                    _buildStatItem(
                      '\$${bookingProvider.totalSpent.toStringAsFixed(2)}',
                      'Total Spent',
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          // Bookings List
          Expanded(
            child: bookingProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : bookingProvider.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          bookingProvider.error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            bookingProvider.fetchUserBookings();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : filteredBookings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.bookmark_border,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No bookings found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedFilter == 'all'
                              ? 'Start by booking a tour or flight'
                              : 'No $_selectedFilter bookings',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.pushNamed(context, '/tours');
                            context.go('/tours');
                          },
                          child: const Text('Browse Tours'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => bookingProvider.fetchUserBookings(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredBookings.length,
                      itemBuilder: (context, index) {
                        final booking = filteredBookings[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: BookingCard(booking: booking),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == value,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: AppColors.borderColor,
      selectedColor: AppColors.primaryColor,
      labelStyle: TextStyle(
        color: _selectedFilter == value ? Colors.white : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildStatItem(String value, String label, {Color? color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
