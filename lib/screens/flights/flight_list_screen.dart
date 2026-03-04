import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_tour_app/providers/flight_provider.dart';
import 'package:travel_tour_app/widgets/flight_card.dart';
import 'package:travel_tour_app/constants/app_colors.dart';
import 'package:intl/intl.dart';

class FlightListScreen extends StatefulWidget {
  const FlightListScreen({super.key});

  @override
  State<FlightListScreen> createState() => _FlightListScreenState();
}

class _FlightListScreenState extends State<FlightListScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime? _departureDate;
  int _travelers = 1;
  String _travelClass = 'economy';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FlightProvider>(context, listen: false).fetchFlights();
    });
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flightProvider = Provider.of<FlightProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              flightProvider.fetchFlights();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Card
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _fromController,
                          decoration: const InputDecoration(
                            labelText: 'From',
                            prefixIcon: Icon(Icons.flight_takeoff),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _toController,
                          decoration: const InputDecoration(
                            labelText: 'To',
                            prefixIcon: Icon(Icons.flight_land),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.borderColor),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  _departureDate == null
                                      ? 'Departure Date'
                                      : DateFormat(
                                          'dd MMM yyyy',
                                        ).format(_departureDate!),
                                  style: TextStyle(
                                    color: _departureDate == null
                                        ? AppColors.textTertiary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _travelClass,
                          decoration: const InputDecoration(
                            labelText: 'Class',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'economy',
                              child: Text('Economy'),
                            ),
                            DropdownMenuItem(
                              value: 'business',
                              child: Text('Business'),
                            ),
                            DropdownMenuItem(
                              value: 'first',
                              child: Text('First Class'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _travelClass = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Travelers'),
                      const Spacer(),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (_travelers > 1) _travelers--;
                              });
                            },
                          ),
                          Text('$_travelers'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                _travelers++;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_fromController.text.isNotEmpty &&
                          _toController.text.isNotEmpty &&
                          _departureDate != null) {
                        final searchData = {
                          'from': _fromController.text,
                          'to': _toController.text,
                          'departureDate': _departureDate!.toIso8601String(),
                          'travelers': _travelers,
                          'travelClass': _travelClass,
                        };
                        flightProvider.searchFlights(searchData);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Search Flights'),
                  ),
                ],
              ),
            ),
          ),
          // Results
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${flightProvider.flights.length} Flights Found',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                DropdownButton<String>(
                  value: flightProvider.selectedSort,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: 'price',
                      child: Text('Sort by Price'),
                    ),
                    DropdownMenuItem(
                      value: 'duration',
                      child: Text('Sort by Duration'),
                    ),
                    DropdownMenuItem(
                      value: 'departure',
                      child: Text('Sort by Departure'),
                    ),
                  ],
                  onChanged: (value) {
                    flightProvider.sortFlights(value!);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Flights List
          Expanded(
            child: flightProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : flightProvider.error != null
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
                          flightProvider.error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            flightProvider.fetchFlights();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : flightProvider.flights.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.airplanemode_inactive,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No flights found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try a different search',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => flightProvider.fetchFlights(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: flightProvider.flights.length,
                      itemBuilder: (context, index) {
                        final flight = flightProvider.flights[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FlightCard(
                            flight: flight,
                            onTap: () {
                              print(
                                '✈️ Navigating to seat selection for: ${flight.flightNumber}',
                              );
                              context.push(
                                '/seat-selection',
                                extra: {
                                  'flightData': flight.toJson(),
                                  'passengers': 1, // You can make this dynamic
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.pushNamed(context, '/flight-search');
          context.go('/flight-search');
        },
        child: const Icon(Icons.search),
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
        _departureDate = picked;
      });
    }
  }
}
