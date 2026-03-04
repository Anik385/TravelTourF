import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_tour_app/models/tour_model.dart';
import 'package:travel_tour_app/providers/booking_provider.dart';
import 'package:travel_tour_app/providers/tour_provider.dart';
import 'package:travel_tour_app/services/storage_service.dart';
import 'package:travel_tour_app/widgets/custom_button.dart';
import 'package:travel_tour_app/constants/app_colors.dart';
import 'package:intl/intl.dart';

class CreateBookingScreen extends StatefulWidget {
  final int? tourId;
  final int? flightId;

  const CreateBookingScreen({super.key, this.tourId, this.flightId});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  DateTime? _selectedDate;
  int _numberOfGuests = 1;
  String _selectedPaymentMethod = 'bkash';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'bkash', 'name': 'bKash', 'icon': Icons.phone_android},
    {'id': 'nagad', 'name': 'Nagad', 'icon': Icons.phone_android},
    {'id': 'card', 'name': 'Credit/Debit Card', 'icon': Icons.credit_card},
    {'id': 'paypal', 'name': 'PayPal', 'icon': Icons.paypal},
    {'id': 'bank', 'name': 'Bank Transfer', 'icon': Icons.account_balance},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.tourId != null) {
      Provider.of<TourProvider>(
        context,
        listen: false,
      ).fetchTourById(widget.tourId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tourProvider = Provider.of<TourProvider>(context);
    final tour = tourProvider.selectedTour;
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Complete Booking')),
      body: tour == null && widget.tourId != null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tour Summary Card
                  if (tour != null)
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.tourTag,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.landscape,
                                color: AppColors.primaryColor,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tour.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${tour.duration} days • ${tour.destination}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              tour.formattedPrice,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Booking Form
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Booking Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                                        if (_numberOfGuests > 1)
                                          _numberOfGuests--;
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
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Payment Methods
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment Method',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._paymentMethods.map(
                            (method) => RadioListTile<String>(
                              value: method['id'],
                              groupValue: _selectedPaymentMethod,
                              onChanged: (value) {
                                setState(() {
                                  _selectedPaymentMethod = value!;
                                });
                              },
                              title: Row(
                                children: [
                                  Icon(method['icon'], size: 24),
                                  const SizedBox(width: 12),
                                  Text(method['name']),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Price Summary
                  Card(
                    elevation: 4,
                    color: AppColors.primaryColor.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Base Price'),
                              Text(tour?.formattedPrice ?? '\$0'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Guests (x$_numberOfGuests)'),
                              Text(
                                tour != null
                                    ? '\$${(tour.price * _numberOfGuests).toStringAsFixed(2)}'
                                    : '\$0',
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Amount',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                tour != null
                                    ? '\$${(tour.price * _numberOfGuests).toStringAsFixed(2)}'
                                    : '\$0',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Confirm Button
                  _isLoading || bookingProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          text: 'Confirm & Pay',
                          onPressed: _selectedDate == null
                              ? null
                              : () => _processPayment(
                                  context,
                                  tour,
                                  bookingProvider,
                                ),
                          fullWidth: true,
                        ),

                  const SizedBox(height: 16),

                  // Secure Payment Note
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Secure Payment',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  Future<void> _processPayment(
    BuildContext context,
    TourModel? tour,
    BookingProvider bookingProvider,
  ) async {
    setState(() => _isLoading = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (tour != null) {
      // FIXED: Send only date part (YYYY-MM-DD) without time
      // final bookingData = {
      //   'tourId': tour.id,
      //   'travelDate': _selectedDate!.toIso8601String().split(
      //     'T',
      //   )[0], // FIXED: Added .split('T')[0]
      //   'numberOfGuests': _numberOfGuests,
      //   'totalAmount': tour.price * _numberOfGuests,
      //   // 'paymentMethod': _selectedPaymentMethod, // Commented out - backend may not expect it
      // };
      final bookingData = {
        'tourId': tour.id,
        'travelDate': _selectedDate!.toIso8601String().split('T')[0],
        'numberOfGuests': _numberOfGuests,
        'totalAmount': tour.price * _numberOfGuests,
        // REMOVE: userId, bookingDate, status
      };

      print('📤 Sending booking data: $bookingData');

      final success = await bookingProvider.createBooking(bookingData);

      print('✅ Booking success: $success');
      print('❌ Booking error: ${bookingProvider.error}');

      if (success && mounted) {
        print('➡️ Navigating to confirmation...');
        context.push(
          '/booking-confirmation',
          extra: {
            'bookingReference': 'TRV-${DateTime.now().millisecondsSinceEpoch}',
            'tourTitle': tour.title,
            'travelDate': _selectedDate,
            'guests': _numberOfGuests,
            'totalAmount': tour.price * _numberOfGuests,
            'paymentMethod': _selectedPaymentMethod,
          },
        );
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(bookingProvider.error ?? 'Booking failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
  }
}
