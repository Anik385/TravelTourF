import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_tour_app/constants/app_colors.dart';
import 'package:travel_tour_app/services/pdf_service.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({super.key});

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  bool _isDownloading = false;
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra as Map? ?? {};
    
    print('📦 Confirmation args: $args');

    final bookingReference = args['bookingReference'] ?? 'TRV-${DateTime.now().millisecondsSinceEpoch}';
    final tourTitle = args['tourTitle'] ?? 'Tour Booking';
    final travelDate = args['travelDate'] as DateTime? ?? DateTime.now();
    final guests = args['guests'] ?? 1;
    final totalAmount = args['totalAmount'] ?? 0.0;
    final paymentMethod = args['paymentMethod'] ?? 'bkash';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Success Animation
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your booking has been successfully confirmed',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Booking Details Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Booking Reference
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        bookingReference,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tour Name
                    Row(
                      children: [
                        const Icon(Icons.landscape, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tour',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                tourTitle,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Travel Date
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Travel Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                DateFormat('dd MMMM yyyy').format(travelDate),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Guests
                    Row(
                      children: [
                        const Icon(Icons.people, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Guests',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '$guests ${guests == 1 ? 'Person' : 'Persons'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Payment Method
                    Row(
                      children: [
                        Icon(
                          _getPaymentMethodIcon(paymentMethod),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Method',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                _getPaymentMethodName(paymentMethod),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Total Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$${totalAmount.toStringAsFixed(2)}',
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

            // Action Buttons - Download & Share
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isDownloading ? null : () => _downloadVoucher(context),
                    icon: _isDownloading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download),
                    label: Text(_isDownloading ? 'Saving...' : 'Download Voucher'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isSharing ? null : () => _shareVoucher(context),
                    icon: _isSharing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.share),
                    label: Text(_isSharing ? 'Sharing...' : 'Share Voucher'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Back to Home Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back to Home'),
              ),
            ),

            const SizedBox(height: 16),

            // Email sent confirmation
            Text(
              'A confirmation email has been sent to your registered email',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method) {
      case 'bkash':
        return Icons.phone_android;
      case 'nagad':
        return Icons.phone_android;
      case 'card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.paypal;
      case 'bank':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentMethodName(String method) {
    switch (method) {
      case 'bkash':
        return 'bKash';
      case 'nagad':
        return 'Nagad';
      case 'card':
        return 'Credit/Debit Card';
      case 'paypal':
        return 'PayPal';
      case 'bank':
        return 'Bank Transfer';
      default:
        return method;
    }
  }

  Future<void> _downloadVoucher(BuildContext context) async {
    setState(() => _isDownloading = true);

    try {
      final args = GoRouterState.of(context).extra as Map? ?? {};
      
      final file = await PdfService.generateBookingVoucher(
        bookingReference: args['bookingReference'] ?? 'TRV-123',
        customerName: 'John Doe', // Get from user data
        tourName: args['tourTitle'] ?? 'Tour Booking',
        travelDate: args['travelDate'] as DateTime? ?? DateTime.now(),
        guests: args['guests'] ?? 1,
        totalAmount: args['totalAmount'] ?? 0.0,
        paymentMethod: _getPaymentMethodName(args['paymentMethod'] ?? 'bkash'),
        bookingDate: DateFormat('dd MMM yyyy').format(DateTime.now()),
        customMessage: 'Thank you for booking with Travel & Tour!',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Voucher downloaded successfully'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'OPEN',
              onPressed: () => _shareVoucher(context),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving voucher: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  Future<void> _shareVoucher(BuildContext context) async {
    setState(() => _isSharing = true);

    try {
      final args = GoRouterState.of(context).extra as Map? ?? {};
      
      final file = await PdfService.generateBookingVoucher(
        bookingReference: args['bookingReference'] ?? 'TRV-123',
        customerName: 'John Doe',
        tourName: args['tourTitle'] ?? 'Tour Booking',
        travelDate: args['travelDate'] as DateTime? ?? DateTime.now(),
        guests: args['guests'] ?? 1,
        totalAmount: args['totalAmount'] ?? 0.0,
        paymentMethod: _getPaymentMethodName(args['paymentMethod'] ?? 'bkash'),
        bookingDate: DateFormat('dd MMM yyyy').format(DateTime.now()),
      );

      await PdfService.sharePdf(file);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing voucher: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }

  void _shareViaEmail(BuildContext context, String reference) async {
    final email = Uri(
      scheme: 'mailto',
      path: 'user@example.com',
      query: 'subject=Your Booking Voucher - $reference&body=Thank you for booking with Travel & Tour. Your voucher is attached.',
    );

    try {
      if (await canLaunchUrl(email)) {
        await launchUrl(email);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open email app')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}