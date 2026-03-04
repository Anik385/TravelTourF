// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:travel_tour_app/widgets/map_marker.dart';

// class AirportMap extends StatefulWidget {
//   final String airportCode;
//   final String airportName;
//   final LatLng location;

//   const AirportMap({
//     super.key,
//     required this.airportCode,
//     required this.airportName,
//     required this.location,
//   });

//   @override
//   State<AirportMap> createState() => _AirportMapState();
// }

// class _AirportMapState extends State<AirportMap> {
//   GoogleMapController? _mapController;

//   // Sample terminal locations relative to airport
//   final List<Map<String, dynamic>> _terminals = [
//     {'name': 'Terminal 1', 'lat': 0.002, 'lng': 0.001},
//     {'name': 'Terminal 2', 'lat': -0.001, 'lng': 0.003},
//     {'name': 'Terminal 3', 'lat': 0.003, 'lng': -0.002},
//     {'name': 'Cargo Terminal', 'lat': -0.002, 'lng': -0.002},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.airportCode} - ${widget.airportName}'),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: widget.location,
//           zoom: 14,
//         ),
//         onMapCreated: (GoogleMapController controller) {
//           _mapController = controller;
//         },
//         markers: _getAirportMarkers(),
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         mapType: MapType.satellite, // Satellite view for airport
//       ),
//     );
//   }

//   Set<Marker> _getAirportMarkers() {
//     Set<Marker> markers = {};

//     // Main airport marker
//     markers.add(
//       Marker(
//         markerId: const MarkerId('airport'),
//         position: widget.location,
//         icon: MapMarker.getAirportMarker(),
//         infoWindow: InfoWindow(
//           title: widget.airportName,
//           snippet: 'Airport • $widget',
//         ),
//       ),
//     );

//     // Terminal markers
//     for (var i = 0; i < _terminals.length; i++) {
//       final terminal = _terminals[i];
//       markers.add(
//         Marker(
//           markerId: MarkerId('terminal_$i'),
//           position: LatLng(
//             widget.location.latitude + terminal['lat'],
//             widget.location.longitude + terminal['lng'],
//           ),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
//           infoWindow: InfoWindow(
//             title: terminal['name'],
//             snippet: 'Airport terminal',
//           ),
//         ),
//       );
//     }

//     return markers;
//   }
// }