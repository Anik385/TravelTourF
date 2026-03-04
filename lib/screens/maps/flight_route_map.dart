import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travel_tour_app/services/location_service.dart';
import 'package:travel_tour_app/services/osm_map_service.dart';
import 'package:travel_tour_app/constants/app_colors.dart';
import 'dart:async';

class FlightRouteMap extends StatefulWidget {
  final Map<String, dynamic> flightData;

  const FlightRouteMap({super.key, required this.flightData});

  @override
  State<FlightRouteMap> createState() => _FlightRouteMapState();
}

class _FlightRouteMapState extends State<FlightRouteMap> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _isLoading = true;

  // Add variables for real-time tracking
  StreamSubscription<Position>? _positionStream;
  double? _currentDistance;

  // Sample flight paths for demo
  final List<Map<String, dynamic>> _demoFlights = [
    {
      'flightNumber': 'EK 123',
      'airline': 'Emirates',
      'from': 'DXB',
      'to': 'LHR',
      'departure': const LatLng(25.2532, 55.3657), // Dubai
      'arrival': const LatLng(51.4700, -0.4543), // London
    },
    {
      'flightNumber': 'SQ 321',
      'airline': 'Singapore Airlines',
      'from': 'SIN',
      'to': 'SYD',
      'departure': const LatLng(1.3644, 103.9915), // Singapore
      'arrival': const LatLng(-33.9399, 151.1753), // Sydney
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeMap();
    _startLocationTracking(); // Add this
  }

  Future<void> _initializeMap() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _updateDistance();
      });
    }
    setState(() => _isLoading = false);
  }

  // Add location tracking method
  void _startLocationTracking() {
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) {
          if (mounted) {
            setState(() {
              _currentLocation = LatLng(position.latitude, position.longitude);
              _updateDistance();
            });
          }
        });
  }

  // Add method to update distance
  void _updateDistance() {
    if (_currentLocation != null && _demoFlights.isNotEmpty) {
      _currentDistance = OSMMapService.calculateDistance(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        _demoFlights[0]['departure'].latitude,
        _demoFlights[0]['departure'].longitude,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Routes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerOnCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? const LatLng(23.83, 90.41),
              initialZoom: 4,
              onTap: (tapPosition, point) {
                print('Tapped at: $point');
              },
            ),
            children: [
              // OpenStreetMap tile layer
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.travel_tour_app',
              ),

              // User location marker
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: 40,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              // Flight route polylines
              PolylineLayer(polylines: _getFlightPolylines()),

              // Markers layer
              MarkerLayer(markers: _getFlightMarkers()),
            ],
          ),

          // Real-time distance display
          if (_currentDistance != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.flight,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Distance to ${_demoFlights[0]['flightNumber']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_currentDistance!.toStringAsFixed(1)} km',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _currentDistance! < 100
                            ? Colors.green.withOpacity(0.1)
                            : _currentDistance! < 500
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _currentDistance! < 100
                            ? 'Very close'
                            : _currentDistance! < 500
                            ? 'Nearby'
                            : 'Far away',
                        style: TextStyle(
                          fontSize: 10,
                          color: _currentDistance! < 100
                              ? Colors.green[700]
                              : _currentDistance! < 500
                              ? Colors.orange[700]
                              : Colors.red[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showDistanceInfo,
        label: const Text('Flight Info'),
        icon: const Icon(Icons.info),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  List<Polyline> _getFlightPolylines() {
    List<Polyline> polylines = [];

    for (var flight in _demoFlights) {
      polylines.add(
        Polyline(
          points: [flight['departure'], flight['arrival']],
          color: AppColors.primaryColor,
          strokeWidth: 3,
          borderStrokeWidth: 1,
          borderColor: Colors.white,
        ),
      );
    }

    return polylines;
  }

  List<Marker> _getFlightMarkers() {
    List<Marker> markers = [];

    for (var i = 0; i < _demoFlights.length; i++) {
      final flight = _demoFlights[i];

      // Departure marker
      markers.add(
        Marker(
          point: flight['departure'],
          width: 40,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.flight_takeoff, color: Colors.white, size: 16),
            ),
          ),
        ),
      );

      // Arrival marker
      markers.add(
        Marker(
          point: flight['arrival'],
          width: 40,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondaryColor.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.flight_land, color: Colors.white, size: 16),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  void _centerOnCurrentLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 10);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location not available'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDistanceInfo() {
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Getting your location...'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    double totalDistance = 0;
    for (var flight in _demoFlights) {
      totalDistance += OSMMapService.calculateDistance(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        flight['departure'].latitude,
        flight['departure'].longitude,
      );
    }

    // Calculate average distance per flight
    double avgDistance = totalDistance / _demoFlights.length;

    // Calculate estimated travel time (assuming 800 km/h flight speed)
    int flightTimeMinutes = (avgDistance / 800 * 60).round();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Flight Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildInfoRow(
                Icons.flight,
                'Active Flights',
                '${_demoFlights.length}',
              ),
              _buildInfoRow(
                Icons.flight_takeoff,
                'Nearest Flight',
                _demoFlights[0]['flightNumber'],
              ),
              _buildInfoRow(
                Icons.straighten,
                'Avg Distance',
                '${avgDistance.toStringAsFixed(0)} km',
              ),
              _buildInfoRow(
                Icons.access_time,
                'Est. Flight Time',
                '$flightTimeMinutes min',
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Add dispose method
  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}

// //google Map Code
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:travel_tour_app/widgets/map_marker.dart';
// import 'package:travel_tour_app/services/location_service.dart';
// import 'package:travel_tour_app/constants/app_colors.dart';

// class FlightRouteMap extends StatefulWidget {
//   final Map<String, dynamic> flightData;

//   const FlightRouteMap({super.key, required this.flightData});

//   @override
//   State<FlightRouteMap> createState() => _FlightRouteMapState();
// }

// class _FlightRouteMapState extends State<FlightRouteMap> {
//   GoogleMapController? _mapController;
//   Set<Marker> _markers = {};
//   Set<Polyline> _polylines = {};
//   LatLng? _currentLocation;
//   bool _isLoading = true;

//   // Sample flight paths for demo
//   final List<Map<String, dynamic>> _demoFlights = [
//     {
//       'flightNumber': 'EK 123',
//       'airline': 'Emirates',
//       'from': 'DXB',
//       'to': 'LHR',
//       'departure': const LatLng(25.2532, 55.3657), // Dubai
//       'arrival': const LatLng(51.4700, -0.4543), // London
//       'heading': 280.0,
//       'altitude': 35000,
//     },
//     {
//       'flightNumber': 'SQ 321',
//       'airline': 'Singapore Airlines',
//       'from': 'SIN',
//       'to': 'SYD',
//       'departure': const LatLng(1.3644, 103.9915), // Singapore
//       'arrival': const LatLng(-33.9399, 151.1753), // Sydney
//       'heading': 120.0,
//       'altitude': 37000,
//     },
//     {
//       'flightNumber': 'QR 789',
//       'airline': 'Qatar Airways',
//       'from': 'DOH',
//       'to': 'JFK',
//       'departure': const LatLng(25.2609, 51.6138), // Doha
//       'arrival': const LatLng(40.6413, -73.7781), // New York
//       'heading': 315.0,
//       'altitude': 38000,
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeMap();
//   }

//   Future<void> _initializeMap() async {
//     // Get current location
//     final position = await LocationService.getCurrentLocation();
//     if (position != null) {
//       setState(() {
//         _currentLocation = LatLng(position.latitude, position.longitude);
//       });
//     }

//     // Create markers for demo flights
//     _createFlightMarkers();

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   void _createFlightMarkers() {
//     Set<Marker> markers = {};
//     Set<Polyline> polylines = {};

//     for (var flight in _demoFlights) {
//       // Add departure marker
//       markers.add(
//         Marker(
//           markerId: MarkerId('${flight['flightNumber']}_dep'),
//           position: flight['departure'],
//           icon: MapMarker.getAirplaneMarker(),
//           rotation: flight['heading'],
//           infoWindow: InfoWindow(
//             title: '${flight['airline']} ${flight['from']}',
//             snippet: 'Departure • ${flight['altitude']} ft',
//           ),
//         ),
//       );

//       // Add arrival marker
//       markers.add(
//         Marker(
//           markerId: MarkerId('${flight['flightNumber']}_arr'),
//           position: flight['arrival'],
//           icon: MapMarker.getDestinationMarker(),
//           infoWindow: InfoWindow(
//             title: '${flight['airline']} ${flight['to']}',
//             snippet: 'Arrival • Flight ${flight['flightNumber']}',
//           ),
//         ),
//       );

//       // Draw flight route polyline
//       polylines.add(
//         Polyline(
//           polylineId: PolylineId(flight['flightNumber']),
//           points: [flight['departure'], flight['arrival']],
//           color: AppColors.primaryColor,
//           width: 3,
//           patterns: [PatternItem.dash(10)], // Dotted line for flight path
//         ),
//       );
//     }

//     setState(() {
//       _markers = markers;
//       _polylines = polylines;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Live Flight Tracker'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.my_location),
//             onPressed: _centerOnCurrentLocation,
//           ),
//         ],
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _currentLocation ?? const LatLng(23.83, 90.41),
//           zoom: 4,
//         ),
//         onMapCreated: (GoogleMapController controller) {
//           _mapController = controller;
//         },
//         markers: _markers,
//         polylines: _polylines,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: false,
//         mapType: MapType.normal,
//         compassEnabled: true,
//         trafficEnabled: false,
//         buildingsEnabled: true,
//         indoorViewEnabled: true,
//         onTap: (LatLng position) {
//           print('Tapped at: $position');
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _animateFlights,
//         label: const Text('Play Flight Demo'),
//         icon: const Icon(Icons.play_arrow),
//         backgroundColor: AppColors.primaryColor,
//       ),
//     );
//   }

//   Future<void> _centerOnCurrentLocation() async {
//     if (_currentLocation != null && _mapController != null) {
//       await _mapController!.animateCamera(
//         CameraUpdate.newLatLngZoom(_currentLocation!, 10),
//       );
//     }
//   }

//   void _animateFlights() {
//     // Simple animation to simulate flight movement
//     int index = 0;
//     Timer.periodic(const Duration(milliseconds: 500), (timer) {
//       if (!mounted) {
//         timer.cancel();
//         return;
//       }

//       setState(() {
//         // Update marker positions to simulate movement
//         _markers = _markers.map((marker) {
//           if (marker.markerId.value.contains('dep')) {
//             // Move departure marker slightly
//             return marker.copyWith(
//               positionParam: LatLng(
//                 marker.position.latitude + 0.001,
//                 marker.position.longitude + 0.001,
//               ),
//             );
//           }
//           return marker;
//         }).toSet();
//       });

//       index++;
//       if (index > 10) timer.cancel();
//     });
//   }

//   @override
//   void dispose() {
//     _mapController?.dispose();
//     super.dispose();
//   }
// }
