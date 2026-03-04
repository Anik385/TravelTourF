// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapMarker {
//   // Create custom airplane marker
//   static BitmapDescriptor getAirplaneMarker() {
//     return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
//   }

//   // Create custom destination marker
//   static BitmapDescriptor getDestinationMarker() {
//     return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
//   }

//   // Create custom airport marker
//   static BitmapDescriptor getAirportMarker() {
//     return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
//   }

//   // Generate marker set for flights
//   static Set<Marker> getFlightMarkers({
//     required LatLng departure,
//     required LatLng arrival,
//     required String flightNumber,
//     VoidCallback? onTap,
//   }) {
//     return {
//       // Departure marker with airplane icon
//       Marker(
//         markerId: const MarkerId('departure'),
//         position: departure,
//         icon: getAirplaneMarker(),
//         infoWindow: InfoWindow(
//           title: 'Departure: $flightNumber',
//           snippet: 'Tap for details',
//         ),
//         onTap: onTap ?? () {},
//       ),
      
//       // Arrival marker
//       Marker(
//         markerId: const MarkerId('arrival'),
//         position: arrival,
//         icon: getDestinationMarker(),
//         infoWindow: const InfoWindow(
//           title: 'Arrival',
//           snippet: 'Destination airport',
//         ),
//       ),
//     };
//   }

//   // Generate markers for multiple flights
//   static Set<Marker> getMultipleFlightMarkers(List<Map<String, dynamic>> flights) {
//     Set<Marker> markers = {};
    
//     for (var i = 0; i < flights.length; i++) {
//       final flight = flights[i];
//       markers.add(
//         Marker(
//           markerId: MarkerId('flight_$i'),
//           position: LatLng(
//             flight['lat'] ?? 23.83,
//             flight['lng'] ?? 90.41,
//           ),
//           icon: getAirplaneMarker(),
//           rotation: flight['heading']?.toDouble() ?? 0.0,
//           infoWindow: InfoWindow(
//             title: flight['flightNumber'] ?? 'Flight $i',
//             snippet: '${flight['airline'] ?? 'Unknown'} • ${flight['altitude'] ?? '35000'} ft',
//           ),
//           onTap: () => print('Flight ${flight['flightNumber']} tapped'),
//         ),
//       );
//     }
    
//     return markers;
//   }

//   // Generate markers for tour destinations
//   static Set<Marker> getTourMarkers(List<Map<String, dynamic>> destinations) {
//     Set<Marker> markers = {};
    
//     for (var i = 0; i < destinations.length; i++) {
//       final dest = destinations[i];
//       markers.add(
//         Marker(
//           markerId: MarkerId('dest_$i'),
//           position: LatLng(
//             dest['lat'] ?? 23.83,
//             dest['lng'] ?? 90.41,
//           ),
//           icon: getDestinationMarker(),
//           infoWindow: InfoWindow(
//             title: dest['name'] ?? 'Destination $i',
//             snippet: dest['description'] ?? 'Tour location',
//           ),
//         ),
//       );
//     }
    
//     return markers;
//   }
// }