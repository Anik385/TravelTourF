import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel_tour_app/constants/app_colors.dart';

class FlightSeatSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> flightData;
  final int passengers;

  const FlightSeatSelectionScreen({
    super.key,
    required this.flightData,
    required this.passengers,
  });

  @override
  State<FlightSeatSelectionScreen> createState() =>
      _FlightSeatSelectionScreenState();
}

class _FlightSeatSelectionScreenState extends State<FlightSeatSelectionScreen> {
  final List<String> _selectedSeats = [];
  final Map<String, String> _seatClass = {};

  // Simulate seat layout
  final List<String> _rows = ['A', 'B', 'C', 'D', 'E', 'F'];
  final List<int> _columns = List.generate(30, (index) => index + 1);

  // Predefined unavailable seats
  final Set<String> _unavailableSeats = {
    '1A',
    '1B',
    '1C',
    '5D',
    '5E',
    '5F',
    '10A',
    '10B',
    '15C',
    '15D',
    '20E',
    '20F',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Seats')),
      body: Column(
        children: [
          // Flight Info
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.flightData['airline']} ${widget.flightData['flightNumber']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.flightData['from']} → ${widget.flightData['to']}',
                        style: TextStyle(color: AppColors.textSecondary),
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
                    '${_selectedSeats.length}/${widget.passengers} Seats',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Seat Legend
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(Colors.green, 'Available'),
                _buildLegendItem(Colors.grey, 'Unavailable'),
                _buildLegendItem(AppColors.primaryColor, 'Selected'),
              ],
            ),
          ),

          // Seat Map
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Seat Type Legend
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'First Class',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  _buildSeatRow(1, 5, 'first'),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Business Class',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  _buildSeatRow(6, 15, 'business'),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Economy Class',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  _buildSeatRow(16, 30, 'economy'),

                  // Emergency Exit Note
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Rows 12 and 24 are emergency exits. Seats in these rows have extra legroom but cannot be reclined.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Selected Seats'),
                        Text(
                          _selectedSeats.isEmpty
                              ? 'None'
                              : _selectedSeats.join(', '),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectedSeats.length == widget.passengers
                        ? () {
                            // Navigate to passenger details
                            context.push(
                              '/flight-passenger-details',
                              extra: {
                                'flightData': widget.flightData,
                                'selectedSeats': _selectedSeats,
                                'seatClass': _seatClass,
                              },
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      'Continue (${_selectedSeats.length}/${widget.passengers})',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildSeatRow(int start, int end, String seatClass) {
    return Column(
      children: List.generate(end - start + 1, (index) {
        final row = start + index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _rows.map((col) {
              final seatNumber = '$row$col';
              final isUnavailable = _unavailableSeats.contains(seatNumber);
              final isSelected = _selectedSeats.contains(seatNumber);

              return GestureDetector(
                onTap: isUnavailable
                    ? null
                    : () {
                        setState(() {
                          if (isSelected) {
                            _selectedSeats.remove(seatNumber);
                            _seatClass.remove(seatNumber);
                          } else if (_selectedSeats.length <
                              widget.passengers) {
                            _selectedSeats.add(seatNumber);
                            _seatClass[seatNumber] = seatClass;
                          }
                        });
                      },
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isUnavailable
                        ? Colors.grey
                        : isSelected
                        ? AppColors.primaryColor
                        : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : isUnavailable
                          ? Colors.transparent
                          : Colors.green,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      seatNumber,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : isUnavailable
                            ? Colors.white
                            : Colors.black,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }
}
