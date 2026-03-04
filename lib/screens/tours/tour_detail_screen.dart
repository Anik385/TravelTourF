import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:travel_tour_app/providers/tour_provider.dart';
import 'package:travel_tour_app/providers/booking_provider.dart';
import 'package:travel_tour_app/widgets/custom_button.dart';
import 'package:travel_tour_app/constants/app_colors.dart';
import 'package:intl/intl.dart';

import '../../models/tour_model.dart';

class TourDetailScreen extends StatefulWidget {
  final int tourId;

  const TourDetailScreen({super.key, required this.tourId});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  final int _selectedImageIndex = 0;
  int _numberOfGuests = 1;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TourProvider>(
        context,
        listen: false,
      ).fetchTourById(widget.tourId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tourProvider = Provider.of<TourProvider>(context);
    final bookingProvider = Provider.of<BookingProvider>(context);
    final tour = tourProvider.selectedTour;

    if (tour == null && !tourProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tour Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: Text('Tour not found')),
      );
    }

    return Scaffold(
      body: tourProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // App Bar with back button
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  floating: true,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.share, color: Colors.white),
                      ),
                      onPressed: () {
                        // Share tour
                      },
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        // Add to favorites
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Tour Images
                        tour!.images.isNotEmpty
                            ? Image.network(
                                tour.images[_selectedImageIndex],
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: AppColors.borderColor,
                                child: const Icon(
                                  Icons.landscape,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                        // Image Indicator
                        if (tour.images.length > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: tour.images.asMap().entries.map((
                                entry,
                              ) {
                                return Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _selectedImageIndex == entry.key
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Tour Details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                tour.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              tour.formattedPrice,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Destination and Duration
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tour.destination,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              tour.durationText,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Categories
                        Wrap(
                          spacing: 8,
                          children: tour.categories
                              .map(
                                (category) => Chip(
                                  label: Text(category),
                                  backgroundColor: AppColors.tourTag,
                                  labelStyle: const TextStyle(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tour.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Inclusions
                        const Text(
                          'Inclusions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tour.inclusions
                              .map(
                                (inclusion) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        size: 16,
                                        color: AppColors.successColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(child: Text(inclusion)),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        // Itinerary
                        const Text(
                          'Itinerary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tour.itinerary.length,
                          itemBuilder: (context, index) {
                            final day = tour.itinerary[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Day ${day.day}: ${day.title}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(day.description),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // Booking Form
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Book This Tour',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Travel Date
                                InkWell(
                                  onTap: () => _selectDate(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.borderColor,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _selectedDate == null
                                                ? 'Select travel date'
                                                : DateFormat(
                                                    'dd MMM yyyy',
                                                  ).format(_selectedDate!),
                                            style: TextStyle(
                                              color: _selectedDate == null
                                                  ? AppColors.textTertiary
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Number of Guests
                                Row(
                                  children: [
                                    const Text('Number of Guests'),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              if (_numberOfGuests > 1) {
                                                _numberOfGuests--;
                                              }
                                            });
                                          },
                                        ),
                                        Container(
                                          width: 40,
                                          alignment: Alignment.center,
                                          child: Text('$_numberOfGuests'),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              _numberOfGuests++;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // Total Price
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Price',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '\$${(tour.price * _numberOfGuests).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                // Book Now Button
                                bookingProvider.isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : CustomButton(
                                        text: 'Book Now',
                                        onPressed: _selectedDate == null
                                            ? null
                                            : () {
                                                _bookTour(
                                                  tour,
                                                  bookingProvider,
                                                );
                                              },
                                        fullWidth: true,
                                      ),
                                // Add this button
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.push(
                                      '/tour-location-map',
                                      extra: {
                                        'tourName': tour.title,
                                        'location': LatLng(
                                          -8.4095,
                                          115.1889,
                                        ), // Replace with actual coordinates
                                        'attractions':
                                            [], // Add nearby attractions if available
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.map),
                                  label: const Text('View on Map'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _bookTour(
    TourModel tour,
    BookingProvider bookingProvider,
  ) async {
    if (_selectedDate == null) return;

    // Navigate to CREATE BOOKING screen first (with payment)
    context.push(
      '/create-booking',
      extra: {
        'tourId': tour.id,
        'tourTitle': tour.title,
        'tourPrice': tour.price,
        'selectedDate': _selectedDate,
        'numberOfGuests': _numberOfGuests,
      },
    );

    // REMOVE the old booking creation code from here
  }

  // Future<void> _bookTour(
  //   TourModel tour,
  //   BookingProvider bookingProvider,
  // ) async {
  //   final bookingData = {
  //     'tourId': tour.id,
  //     'travelDate': _selectedDate!.toIso8601String(),
  //     'numberOfGuests': _numberOfGuests,
  //     'totalAmount': tour.price * _numberOfGuests,
  //   };

  //   final success = await bookingProvider.createBooking(bookingData);

  //   if (success) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Booking successful!'),
  //         backgroundColor: AppColors.successColor,
  //       ),
  //     );
  //     // Navigator.pushNamed(context, '/bookings');
  //     context.go('/bookings'); // CHANGE THIS LINE
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(bookingProvider.error ?? 'Booking failed'),
  //         backgroundColor: AppColors.dangerColor,
  //       ),
  //     );
  //   }
  // }
}
