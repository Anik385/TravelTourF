import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:travel_tour_app/constants/app_colors.dart';
import 'package:travel_tour_app/models/flight_model.dart';
import 'package:travel_tour_app/providers/flight_provider.dart';

class FlightManagementScreen extends StatefulWidget {
  const FlightManagementScreen({super.key});

  @override
  State<FlightManagementScreen> createState() => _FlightManagementScreenState();
}

class _FlightManagementScreenState extends State<FlightManagementScreen> {
  String _searchQuery = '';
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FlightProvider>(context, listen: false).fetchFlights();
    });
  }

  List<FlightModel> get _filteredFlights {
    final flightProvider = Provider.of<FlightProvider>(context, listen: false);
    return flightProvider.flights.where((flight) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          flight.airline.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          flight.flightNumber.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      // Add status filtering if your FlightModel has status field
      return matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final flightProvider = Provider.of<FlightProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin'), // CHANGE THIS LINE
        ),
        title: const Text('Flight Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/admin/flights/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search flights',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          // Flights List
          Expanded(
            child: flightProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredFlights.length,
                    itemBuilder: (context, index) {
                      final flight = _filteredFlights[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            '${flight.airline} ${flight.flightNumber}',
                          ),
                          subtitle: Text(
                            '${flight.departure.airport} → ${flight.arrival.airport}',
                          ),
                          trailing: Text('\$${flight.price.economy}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:travel_tour_app/constants/app_colors.dart';
// import 'package:travel_tour_app/providers/flight_provider.dart';

// class FlightManagementScreen extends StatefulWidget {
//   const FlightManagementScreen({super.key});

//   @override
//   State<FlightManagementScreen> createState() => _FlightManagementScreenState();
// }

// class _FlightManagementScreenState extends State<FlightManagementScreen> {
//   @override
// void initState() {
//   super.initState();
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     Provider.of<FlightProvider>(context, listen: false).fetchFlights(); // Already have this
//   });
// }
//   final List<Map<String, dynamic>> _flights = [
//     {
//       'id': 1,
//       'airline': 'Emirates',
//       'flightNumber': 'EK 203',
//       'from': 'DXB',
//       'to': 'JFK',
//       'departure': '2024-03-15 08:00',
//       'arrival': '2024-03-15 14:30',
//       'seats': 120,
//       'status': 'scheduled',
//       'price': 899.99,
//     },
//     {
//       'id': 2,
//       'airline': 'Singapore Airlines',
//       'flightNumber': 'SQ 321',
//       'from': 'SIN',
//       'to': 'LHR',
//       'departure': '2024-03-16 22:00',
//       'arrival': '2024-03-17 06:00',
//       'seats': 85,
//       'status': 'scheduled',
//       'price': 1099.99,
//     },
//     {
//       'id': 3,
//       'airline': 'Qatar Airways',
//       'flightNumber': 'QR 123',
//       'from': 'DOH',
//       'to': 'CDG',
//       'departure': '2024-03-14 13:45',
//       'arrival': '2024-03-14 19:30',
//       'seats': 45,
//       'status': 'delayed',
//       'price': 799.99,
//     },
//   ];

//   String _searchQuery = '';
//   String _selectedStatus = 'all';
//   String _selectedAirline = 'all';

//   List<Map<String, dynamic>> get _filteredFlights {
//     return _flights.where((flight) {
//       final matchesSearch =
//           flight['airline'].toString().toLowerCase().contains(
//             _searchQuery.toLowerCase(),
//           ) ||
//           flight['flightNumber'].toString().toLowerCase().contains(
//             _searchQuery.toLowerCase(),
//           ) ||
//           flight['from'].toString().toLowerCase().contains(
//             _searchQuery.toLowerCase(),
//           ) ||
//           flight['to'].toString().toLowerCase().contains(
//             _searchQuery.toLowerCase(),
//           );

//       final matchesStatus =
//           _selectedStatus == 'all' || flight['status'] == _selectedStatus;

//       final matchesAirline =
//           _selectedAirline == 'all' || flight['airline'] == _selectedAirline;

//       return matchesSearch && matchesStatus && matchesAirline;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final airlines = _flights.map((f) => f['airline']).toSet().toList();
//     airlines.insert(0, 'all');

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flight Management'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               Navigator.pushNamed(context, '/admin/flights/add');
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Filters
//           Card(
//             margin: const EdgeInsets.all(16),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   TextField(
//                     decoration: const InputDecoration(
//                       labelText: 'Search flights',
//                       prefixIcon: Icon(Icons.search),
//                       border: OutlineInputBorder(),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _searchQuery = value;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           initialValue: _selectedAirline,
//                           decoration: const InputDecoration(
//                             labelText: 'Airline',
//                             border: OutlineInputBorder(),
//                           ),
//                           items: airlines.map<DropdownMenuItem<String>>((
//                             airline,
//                           ) {
//                             return DropdownMenuItem(
//                               value: airline as String,
//                               child: Text(
//                                 airline == 'all' ? 'All Airlines' : airline,
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               _selectedAirline = value!;
//                             });
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: DropdownButtonFormField<String>(
//                           initialValue: _selectedStatus,
//                           decoration: const InputDecoration(
//                             labelText: 'Status',
//                             border: OutlineInputBorder(),
//                           ),
//                           items: const [
//                             DropdownMenuItem(
//                               value: 'all',
//                               child: Text('All Status'),
//                             ),
//                             DropdownMenuItem(
//                               value: 'scheduled',
//                               child: Text('Scheduled'),
//                             ),
//                             DropdownMenuItem(
//                               value: 'delayed',
//                               child: Text('Delayed'),
//                             ),
//                             DropdownMenuItem(
//                               value: 'cancelled',
//                               child: Text('Cancelled'),
//                             ),
//                             DropdownMenuItem(
//                               value: 'completed',
//                               child: Text('Completed'),
//                             ),
//                           ],
//                           onChanged: (value) {
//                             setState(() {
//                               _selectedStatus = value!;
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Stats
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildStatCard(
//                   'Total Flights',
//                   _flights.length.toString(),
//                   Icons.flight,
//                   AppColors.primaryColor,
//                 ),
//                 _buildStatCard(
//                   'Available Seats',
//                   _flights
//                       .fold<int>(
//                         0,
//                         (sum, flight) => sum + flight['seats'] as int,
//                       )
//                       .toString(),
//                   Icons.event_seat,
//                   AppColors.secondaryColor,
//                 ),
//                 _buildStatCard(
//                   'Delayed',
//                   _flights
//                       .where((flight) => flight['status'] == 'delayed')
//                       .length
//                       .toString(),
//                   Icons.schedule,
//                   AppColors.warningColor,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           // Flights List
//           Expanded(
//             child: _filteredFlights.isEmpty
//                 ? const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.flight_takeoff_outlined,
//                           size: 64,
//                           color: Colors.grey,
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           'No flights found',
//                           style: TextStyle(fontSize: 18, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: _filteredFlights.length,
//                     itemBuilder: (context, index) {
//                       final flight = _filteredFlights[index];
//                       return Card(
//                         margin: const EdgeInsets.only(bottom: 12),
//                         child: ListTile(
//                           leading: Container(
//                             width: 50,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               color: AppColors.flightTag,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(
//                               Icons.flight,
//                               color: AppColors.secondaryColor,
//                             ),
//                           ),
//                           title: Text(
//                             '${flight['airline']} ${flight['flightNumber']}',
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('${flight['from']} → ${flight['to']}'),
//                               const SizedBox(height: 4),
//                               Row(
//                                 children: [
//                                   Text(
//                                     flight['departure'].toString().substring(
//                                       11,
//                                       16,
//                                     ),
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   const Icon(Icons.arrow_forward, size: 12),
//                                   const SizedBox(width: 8),
//                                   Text(
//                                     flight['arrival'].toString().substring(
//                                       11,
//                                       16,
//                                     ),
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           trailing: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 '\$${flight['price'].toStringAsFixed(2)}',
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primaryColor,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                       vertical: 2,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: _getStatusColor(
//                                         flight['status'],
//                                       ).withOpacity(0.1),
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: Text(
//                                       flight['status'].toString().toUpperCase(),
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         color: _getStatusColor(
//                                           flight['status'],
//                                         ),
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Icon(
//                                     Icons.people,
//                                     size: 12,
//                                     color: AppColors.textSecondary,
//                                   ),
//                                   Text(
//                                     '${flight['seats']}',
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: AppColors.textSecondary,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           onTap: () {
//                             Navigator.pushNamed(
//                               context,
//                               '/admin/flights/edit',
//                               arguments: flight['id'],
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/admin/flights/add');
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _buildStatCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Icon(icon, size: 24, color: color),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               title,
//               style: const TextStyle(fontSize: 11, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'scheduled':
//         return AppColors.successColor;
//       case 'delayed':
//         return AppColors.warningColor;
//       case 'cancelled':
//         return AppColors.dangerColor;
//       case 'completed':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }
// }
