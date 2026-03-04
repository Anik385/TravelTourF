import 'dart:math';

import 'package:latlong2/latlong.dart';

class OSMMapService {
  // Calculate distance between coordinates (using geolocator or manual)
  static double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    // Simple approximation using Haversine formula
    const R = 6371; // Earth's radius in km
    double dLat = _degToRad(endLat - startLat);
    double dLon = _degToRad(endLng - startLng);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(startLat)) *
            cos(_degToRad(endLat)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  static double _degToRad(double deg) => deg * (3.14159 / 180);
}
