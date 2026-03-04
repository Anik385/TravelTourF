import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_tour_app/widgets/custom_button.dart';
import 'package:travel_tour_app/constants/app_colors.dart';
import 'package:travel_tour_app/utils/validators.dart';

class FlightPassengerDetailsScreen extends StatefulWidget {
  const FlightPassengerDetailsScreen({super.key});

  @override
  State<FlightPassengerDetailsScreen> createState() =>
      _FlightPassengerDetailsScreenState();
}

class _FlightPassengerDetailsScreenState
    extends State<FlightPassengerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, TextEditingController>> _passengerControllers = [];

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = GoRouterState.of(context).extra as Map? ?? {};
    final passengerCount = args['passengers'] ?? 1;

    if (_passengerControllers.isEmpty) {
      for (int i = 0; i < passengerCount; i++) {
        _passengerControllers.add({
          'firstName': TextEditingController(),
          'lastName': TextEditingController(),
          'age': TextEditingController(),
          'passport': TextEditingController(),
        });
      }
    }
  }

  @override
  void dispose() {
    for (var controllers in _passengerControllers) {
      controllers['firstName']?.dispose();
      controllers['lastName']?.dispose();
      controllers['age']?.dispose();
      controllers['passport']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = GoRouterState.of(context).extra as Map? ?? {};
    final flightData = args['flightData'] ?? {};
    final selectedSeats = args['selectedSeats'] ?? [];
    final seatClass = args['seatClass'] ?? {};
    final passengerCount = args['passengers'] ?? 1;

    return Scaffold(
      appBar: AppBar(title: const Text('Passenger Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flight Summary
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${flightData['airline']} ${flightData['flightNumber']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${flightData['from']} → ${flightData['to']}',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              selectedSeats.join(', '),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Passenger Forms
              const Text(
                'Passenger Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              ...List.generate(passengerCount, (index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Passenger ${index + 1} - Seat ${selectedSeats[index] ?? 'Not selected'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // First Name
                        TextFormField(
                          controller: _passengerControllers[index]['firstName'],
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: Validators.validateName,
                        ),
                        const SizedBox(height: 12),

                        // Last Name
                        TextFormField(
                          controller: _passengerControllers[index]['lastName'],
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: Validators.validateName,
                        ),
                        const SizedBox(height: 12),

                        // Age
                        TextFormField(
                          controller: _passengerControllers[index]['age'],
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Age is required';
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 0 || age > 120) {
                              return 'Enter valid age';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Passport Number
                        TextFormField(
                          controller: _passengerControllers[index]['passport'],
                          decoration: const InputDecoration(
                            labelText: 'Passport Number',
                            border: OutlineInputBorder(),
                            hintText: 'Optional for domestic flights',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Contact Information
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: Validators.validatePhone,
                        keyboardType: TextInputType.phone,
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
                          const Text('Base Fare'),
                          Text('\$${flightData['price']?['economy'] ?? '500'}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Passengers (x$passengerCount)'),
                          Text(
                            '\$${(flightData['price']?['economy'] ?? 500) * passengerCount}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Taxes & Fees'),
                          const Text('\$50.00'),
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
                            '\$${((flightData['price']?['economy'] ?? 500) * passengerCount + 50).toStringAsFixed(2)}',
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
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      text: 'Confirm & Pay',
                      onPressed: _processPayment,
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
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        final args = GoRouterState.of(context).extra as Map? ?? {};
        context.push(
          '/booking-confirmation',
          extra: {
            'bookingReference': 'FLT-${DateTime.now().millisecondsSinceEpoch}',
            'tourTitle':
                'Flight: ${args['flightData']?['airline']} ${args['flightData']?['flightNumber']}',
            'travelDate': DateTime.now(),
            'guests': args['passengers'] ?? 1,
            'totalAmount':
                (args['flightData']?['price']?['economy'] ?? 500) *
                    (args['passengers'] ?? 1) +
                50,
            'paymentMethod': _selectedPaymentMethod,
          },
        );
      }

      setState(() => _isLoading = false);
    }
  }
}
