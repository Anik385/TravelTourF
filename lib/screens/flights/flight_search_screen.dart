import 'package:flutter/material.dart';
import 'package:travel_tour_app/constants/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  String _tripType = 'one-way';
  String _fromAirport = '';
  String _toAirport = '';
  DateTime? _departureDate;
  DateTime? _returnDate;
  int _adults = 1;
  int _children = 0;
  int _infants = 0;
  String _travelClass = 'economy';

  final List<String> _airports = [
    'DXB - Dubai International',
    'JFK - John F. Kennedy',
    'LHR - London Heathrow',
    'SIN - Singapore Changi',
    'CDG - Paris Charles de Gaulle',
    'HND - Tokyo Haneda',
    'SYD - Sydney Kingsford Smith',
    'LAX - Los Angeles International',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Flights'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Type
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trip Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTripTypeButton('One-way', 'one-way'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTripTypeButton('Round-trip', 'round-trip'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Route
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // From
                    _buildAirportField(
                      label: 'From',
                      hint: 'Select departure airport',
                      value: _fromAirport,
                      onChanged: (value) {
                        setState(() {
                          _fromAirport = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // To
                    _buildAirportField(
                      label: 'To',
                      hint: 'Select arrival airport',
                      value: _toAirport,
                      onChanged: (value) {
                        setState(() {
                          _toAirport = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Swap Button
                    Align(
                      child: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.swap_vert,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            final temp = _fromAirport;
                            _fromAirport = _toAirport;
                            _toAirport = temp;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Dates
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dates',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            label: 'Departure',
                            date: _departureDate,
                            onTap: () => _selectDate(context, true),
                          ),
                        ),
                        if (_tripType == 'round-trip') ...[
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDateField(
                              label: 'Return',
                              date: _returnDate,
                              onTap: () => _selectDate(context, false),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Travelers & Class
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Travelers & Class',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Travelers
                        Expanded(
                          child: InkWell(
                            onTap: () => _showTravelersDialog(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.borderColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Travelers',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$_adults Adult${_adults > 1 ? 's' : ''}'
                                        '${_children > 0 ? ', $_children Child${_children > 1 ? 'ren' : ''}' : ''}'
                                        '${_infants > 0 ? ', $_infants Infant${_infants > 1 ? 's' : ''}' : ''}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.people_outline),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Class
                        Expanded(
                          child: InkWell(
                            onTap: () => _showClassDialog(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.borderColor),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Class',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textTertiary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _travelClass.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.airline_seat_recline_normal),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Search Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _canSearch() ? _performSearch : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Search Flights'),
              ),
            ),
            const SizedBox(height: 16),
            // Advanced Options
            TextButton(
              onPressed: () {
                // Show advanced options
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Advanced Options'),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.expand_more,
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripTypeButton(String label, String value) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _tripType = value;
          if (value == 'one-way') {
            _returnDate = null;
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _tripType == value ? AppColors.primaryColor : Colors.white,
        foregroundColor:
            _tripType == value ? Colors.white : AppColors.primaryColor,
        side: BorderSide(
          color:
              _tripType == value ? AppColors.primaryColor : AppColors.borderColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }

  Widget _buildAirportField({
    required String label,
    required String hint,
    required String value,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          initialValue: value.isNotEmpty ? value : null,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          items: _airports.map((airport) {
            return DropdownMenuItem(
              value: airport,
              child: Text(airport),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    date == null
                        ? 'Select date'
                        : DateFormat('dd MMM yyyy').format(date),
                    style: TextStyle(
                      color: date == null
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _departureDate = picked;
          if (_tripType == 'round-trip' &&
              _returnDate != null &&
              _returnDate!.isBefore(picked)) {
            _returnDate = null;
          }
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  Future<void> _showTravelersDialog(BuildContext context) async {
    int tempAdults = _adults;
    int tempChildren = _children;
    int tempInfants = _infants;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Travelers'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTravelerCounter(
                  label: 'Adults (12+ years)',
                  value: tempAdults,
                  min: 1,
                  onIncrement: () {
                    if (tempAdults < 9) tempAdults++;
                  },
                  onDecrement: () {
                    if (tempAdults > 1) tempAdults--;
                  },
                ),
                const SizedBox(height: 16),
                _buildTravelerCounter(
                  label: 'Children (2-11 years)',
                  value: tempChildren,
                  min: 0,
                  onIncrement: () {
                    if (tempChildren < 9) tempChildren++;
                  },
                  onDecrement: () {
                    if (tempChildren > 0) tempChildren--;
                  },
                ),
                const SizedBox(height: 16),
                _buildTravelerCounter(
                  label: 'Infants (under 2 years)',
                  value: tempInfants,
                  min: 0,
                  max: tempAdults,
                  onIncrement: () {
                    if (tempInfants < tempAdults) tempInfants++;
                  },
                  onDecrement: () {
                    if (tempInfants > 0) tempInfants--;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _adults = tempAdults;
                  _children = tempChildren;
                  _infants = tempInfants;
                });
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTravelerCounter({
    required String label,
    required int value,
    required int min,
    int? max,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Icon(
                  Icons.remove,
                  size: 20,
                  color: value <= min ? Colors.grey : AppColors.primaryColor,
                ),
              ),
              onPressed: value <= min ? null : onDecrement,
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                '$value',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: (max != null && value >= max)
                      ? Colors.grey
                      : AppColors.primaryColor,
                ),
              ),
              onPressed: (max != null && value >= max) ? null : onIncrement,
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showClassDialog(BuildContext context) async {
    String? selectedClass = _travelClass;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Travel Class'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildClassOption('Economy', 'economy', selectedClass),
                const SizedBox(height: 12),
                _buildClassOption('Premium Economy', 'premium_economy', selectedClass),
                const SizedBox(height: 12),
                _buildClassOption('Business', 'business', selectedClass),
                const SizedBox(height: 12),
                _buildClassOption('First Class', 'first_class', selectedClass),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _travelClass = selectedClass;
                });
                              Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildClassOption(String label, String value, String? selectedValue) {
    return ListTile(
      title: Text(label),
      leading: Radio<String>(
        value: value,
        groupValue: selectedValue,
        onChanged: (value) {
          Navigator.pop(context);
          if (value != null) {
            setState(() {
              _travelClass = value;
            });
          }
        },
      ),
      onTap: () {
        Navigator.pop(context);
        setState(() {
          _travelClass = value;
        });
      },
    );
  }

  bool _canSearch() {
    return _fromAirport.isNotEmpty &&
        _toAirport.isNotEmpty &&
        _departureDate != null &&
        (_tripType == 'one-way' || _returnDate != null);
  }

  void _performSearch() {
    final searchParams = {
      'from': _fromAirport.split(' - ')[0],
      'to': _toAirport.split(' - ')[0],
      'departureDate': DateFormat('yyyy-MM-dd').format(_departureDate!),
      'returnDate': _returnDate != null
          ? DateFormat('yyyy-MM-dd').format(_returnDate!)
          : null,
      'adults': _adults,
      'children': _children,
      'infants': _infants,
      'travelClass': _travelClass,
      'tripType': _tripType,
    };

    // Navigate to flight results
    Navigator.pushNamed(
      context,
      '/flights',
      arguments: searchParams,
    );
  }
}