import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:travel_tour_app/services/location_service.dart';
import 'package:travel_tour_app/services/osm_map_service.dart';
import 'package:travel_tour_app/constants/app_colors.dart';
import 'dart:async';

class TourLocationMap extends StatefulWidget {
  final String tourName;
  final LatLng location;
  final List<Map<String, dynamic>> nearbyAttractions;

  const TourLocationMap({
    super.key,
    required this.tourName,
    required this.location,
    this.nearbyAttractions = const [],
  });

  @override
  State<TourLocationMap> createState() => _TourLocationMapState();
}

class _TourLocationMapState extends State<TourLocationMap> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;

  // Add stream subscription for real-time updates
  StreamSubscription<Position>? _positionStream;

  // Add loading state
  bool _isLoadingLocation = true;

  // Add current distance
  double? _currentDistance;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startLocationTracking();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    final position = await LocationService.getCurrentLocation();
    if (position != null && mounted) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
        _updateDistance();
      });

      // Center map on user location if needed
      _mapController.move(_currentLocation!, 12);
    } else {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  // Start real-time location tracking
  void _startLocationTracking() {
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // Update every 10 meters
          ),
        ).listen((Position position) {
          if (mounted) {
            setState(() {
              _currentLocation = LatLng(position.latitude, position.longitude);
              _updateDistance();
            });
            print('📍 Location updated: ${_currentLocation}');
          }
        });
  }

  // Update distance calculation
  void _updateDistance() {
    if (_currentLocation != null) {
      _currentDistance = OSMMapService.calculateDistance(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        widget.location.latitude,
        widget.location.longitude,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tourName),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerOnUserLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? widget.location,
              initialZoom: 12,
              onMapReady: () {
                print('🗺️ Map is ready');
              },
            ),
            children: [
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

              // Tour and attraction markers
              MarkerLayer(markers: _getMarkers()),
            ],
          ),

          // Loading indicator
          if (_isLoadingLocation)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),

          // Real-time distance display
          if (_currentDistance != null)
            Positioned(
              bottom: 90, // Position above FAB
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
                        Icons.directions_walk,
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
                          const Text(
                            'Distance to destination',
                            style: TextStyle(
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
                        color: _currentDistance! < 1
                            ? Colors.green.withOpacity(0.1)
                            : _currentDistance! < 5
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _currentDistance! < 1
                            ? 'Very close'
                            : _currentDistance! < 5
                            ? 'Nearby'
                            : 'Far away',
                        style: TextStyle(
                          fontSize: 10,
                          color: _currentDistance! < 1
                              ? Colors.green[700]
                              : _currentDistance! < 5
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
        label: const Text('Get Directions'),
        icon: const Icon(Icons.directions),
        backgroundColor: AppColors.primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  List<Marker> _getMarkers() {
    List<Marker> markers = [];

    // Main tour marker
    markers.add(
      Marker(
        point: widget.location,
        width: 50,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.location_on, color: Colors.white, size: 24),
          ),
        ),
      ),
    );

    // Nearby attractions
    for (var i = 0; i < widget.nearbyAttractions.length; i++) {
      final attraction = widget.nearbyAttractions[i];
      markers.add(
        Marker(
          point: LatLng(
            attraction['lat'] ?? widget.location.latitude + (0.01 * (i + 1)),
            attraction['lng'] ?? widget.location.longitude + (0.01 * (i + 1)),
          ),
          width: 40,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.secondaryColor ?? Colors.orange,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.star, color: Colors.white, size: 16),
                if (attraction.containsKey('name'))
                  Positioned(
                    bottom: -15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Text(
                        attraction['name']
                            .toString()
                            .substring(0, 1)
                            .toUpperCase(),
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return markers;
  }

  void _centerOnUserLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 14);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location not available'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Show detailed distance info
  void _showDistanceInfo() {
    if (_currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Getting your location...'),
          duration: Duration(seconds: 1),
        ),
      );
      _getCurrentLocation();
      return;
    }

    double distance = _currentDistance!;

    // Calculate estimated travel time (assuming 50 km/h average speed)
    int travelTimeMinutes = (distance / 50 * 60).round();

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
                'Distance Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildInfoRow(
                Icons.location_on,
                'Tour Location',
                widget.tourName,
              ),
              _buildInfoRow(
                Icons.straighten,
                'Distance',
                '${distance.toStringAsFixed(1)} km',
              ),
              _buildInfoRow(
                Icons.access_time,
                'Est. Driving Time',
                '$travelTimeMinutes min',
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _openInMaps();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Open in Maps'),
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

  void _openInMaps() {
    // This would open in Google Maps or Apple Maps
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening directions to ${widget.tourName}'),
        backgroundColor: AppColors.primaryColor,
      ),
    );

    // TODO: Implement actual maps launch
    // final url = 'https://www.google.com/maps/dir/?api=1&destination=${widget.location.latitude},${widget.location.longitude}';
    // launchUrl(Uri.parse(url));
  }

  // Add dispose method
  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}

//Google Map Code
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:travel_tour_app/widgets/map_marker.dart';
// import 'package:travel_tour_app/services/location_service.dart';

// class TourLocationMap extends StatefulWidget {
//   final String tourName;
//   final LatLng location;
//   final List<Map<String, dynamic>> nearbyAttractions;

//   const TourLocationMap({
//     super.key,
//     required this.tourName,
//     required this.location,
//     this.nearbyAttractions = const [],
//   });

//   @override
//   State<TourLocationMap> createState() => _TourLocationMapState();
// }

// class _TourLocationMapState extends State<TourLocationMap> {
//   GoogleMapController? _mapController;
//   Set<Marker> _markers = {};

//   @override
//   void initState() {
//     super.initState();
//     _createMarkers();
//   }

//   void _createMarkers() {
//     Set<Marker> markers = {};

//     // Main tour location marker
//     markers.add(
//       Marker(
//         markerId: const MarkerId('tour_location'),
//         position: widget.location,
//         icon: MapMarker.getDestinationMarker(),
//         infoWindow: InfoWindow(
//           title: widget.tourName,
//           snippet: 'Tour Destination',
//         ),
//       ),
//     );

//     // Nearby attractions
//     for (var i = 0; i < widget.nearbyAttractions.length; i++) {
//       final attraction = widget.nearbyAttractions[i];
//       markers.add(
//         Marker(
//           markerId: MarkerId('attraction_$i'),
//           position: LatLng(
//             attraction['lat'] ?? widget.location.latitude + 0.01,
//             attraction['lng'] ?? widget.location.longitude + 0.01,
//           ),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
//           infoWindow: InfoWindow(
//             title: attraction['name'] ?? 'Attraction',
//             snippet: attraction['description'] ?? 'Nearby attraction',
//           ),
//         ),
//       );
//     }

//     setState(() {
//       _markers = markers;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.tourName),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: widget.location,
//           zoom: 12,
//         ),
//         onMapCreated: (GoogleMapController controller) {
//           _mapController = controller;
//         },
//         markers: _markers,
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         mapType: MapType.normal,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final position = await LocationService.getCurrentLocation();
//           if (position != null && _mapController != null) {
//             // Calculate and show distance
//             double distance = LocationService.calculateDistance(
//               position.latitude, position.longitude,
//               widget.location.latitude, widget.location.longitude,
//             );
            
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Distance from you: ${distance.toStringAsFixed(1)} km'),
//                 backgroundColor: Colors.blue,
//               ),
//             );
//           }
//         },
//         child: const Icon(Icons.directions),
//       ),
//     );
//   }
// }