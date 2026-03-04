// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class CacheService {
//   static const String toursKey = 'cached_tours';
//   static const String flightsKey = 'cached_flights';
//   static const String userKey = 'user_data';
//   static const String loginKey = 'is_logged_in';
//   static const String toursLastUpdatedKey = 'tours_last_updated';
//   static const String flightsLastUpdatedKey = 'flights_last_updated';

//   // ========== TOURS CACHE ==========
//   static Future<void> cacheTours(List<dynamic> tours) async {
//     final prefs = await SharedPreferences.getInstance();
//     final toursJson = json.encode(tours);
//     await prefs.setString(toursKey, toursJson);
//     await prefs.setString(
//       toursLastUpdatedKey,
//       DateTime.now().toIso8601String(),
//     );
//     print('✅ Cached ${tours.length} tours');
//   }

//   static Future<List<dynamic>> getCachedTours() async {
//     final prefs = await SharedPreferences.getInstance();
//     final toursJson = prefs.getString(toursKey);
//     if (toursJson != null) {
//       print('📦 Loading ${json.decode(toursJson).length} tours from cache');
//       return json.decode(toursJson);
//     }
//     return [];
//   }

//   static Future<DateTime?> getToursLastUpdated() async {
//     final prefs = await SharedPreferences.getInstance();
//     final lastUpdated = prefs.getString(toursLastUpdatedKey);
//     if (lastUpdated != null) {
//       return DateTime.parse(lastUpdated);
//     }
//     return null;
//   }

//   // ========== FLIGHTS CACHE ==========
//   static Future<void> cacheFlights(List<dynamic> flights) async {
//     final prefs = await SharedPreferences.getInstance();
//     final flightsJson = json.encode(flights);
//     await prefs.setString(flightsKey, flightsJson);
//     await prefs.setString(
//       flightsLastUpdatedKey,
//       DateTime.now().toIso8601String(),
//     );
//     print('✅ Cached ${flights.length} flights');
//   }

//   static Future<List<dynamic>> getCachedFlights() async {
//     final prefs = await SharedPreferences.getInstance();
//     final flightsJson = prefs.getString(flightsKey);
//     if (flightsJson != null) {
//       print('📦 Loading ${json.decode(flightsJson).length} flights from cache');
//       return json.decode(flightsJson);
//     }
//     return [];
//   }

//   static Future<DateTime?> getFlightsLastUpdated() async {
//     final prefs = await SharedPreferences.getInstance();
//     final lastUpdated = prefs.getString(flightsLastUpdatedKey);
//     if (lastUpdated != null) {
//       return DateTime.parse(lastUpdated);
//     }
//     return null;
//   }

//   // ========== USER CACHE ==========
//   static Future<void> cacheUser(Map<String, dynamic> userData) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(userKey, json.encode(userData));
//     await prefs.setBool(loginKey, true);
//     print('✅ Cached user data: ${userData['username']}');
//   }

//   static Future<Map<String, dynamic>?> getCachedUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userJson = prefs.getString(userKey);
//     if (userJson != null) {
//       return json.decode(userJson);
//     }
//     return null;
//   }

//   static Future<bool> isLoggedIn() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool(loginKey) ?? false;
//   }

//   // ========== CLEAR CACHE ==========
//   static Future<void> clearCache() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     print('🗑️ Cache cleared');
//   }

//   // ========== CACHE STATS ==========
//   static Future<Map<String, dynamic>> getCacheStats() async {
//     final prefs = await SharedPreferences.getInstance();
//     final tours = await getCachedTours();
//     final flights = await getCachedFlights();
//     final user = await getCachedUser();
//     final toursUpdated = await getToursLastUpdated();
//     final flightsUpdated = await getFlightsLastUpdated();

//     return {
//       'toursCount': tours.length,
//       'flightsCount': flights.length,
//       'userCached': user != null,
//       'loggedIn': await isLoggedIn(),
//       'toursLastUpdated': toursUpdated,
//       'flightsLastUpdated': flightsUpdated,
//       'totalCacheSize': prefs.getKeys().length,
//     };
//   }

//   // ========== REMOVE SPECIFIC CACHE ==========
//   static Future<void> removeToursCache() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(toursKey);
//     await prefs.remove(toursLastUpdatedKey);
//     print('🗑️ Tours cache removed');
//   }

//   static Future<void> removeFlightsCache() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(flightsKey);
//     await prefs.remove(flightsLastUpdatedKey);
//     print('🗑️ Flights cache removed');
//   }

//   static Future<void> removeUserCache() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(userKey);
//     await prefs.remove(loginKey);
//     print('🗑️ User cache removed');
//   }
// }

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String toursKey = 'cached_tours';
  static const String flightsKey = 'cached_flights';
  static const String userKey = 'user_data';
  static const String loginKey = 'is_logged_in';

  // Cache tours
  static Future<void> cacheTours(List<dynamic> tours) async {
    final prefs = await SharedPreferences.getInstance();
    final toursJson = json.encode(tours);
    await prefs.setString(toursKey, toursJson);
    await prefs.setString(
      'tours_last_updated',
      DateTime.now().toIso8601String(),
    );
  }

  static Future<List<dynamic>> getCachedTours() async {
    final prefs = await SharedPreferences.getInstance();
    final toursJson = prefs.getString(toursKey);
    if (toursJson != null) {
      return json.decode(toursJson);
    }
    return [];
  }

  // Cache flights
  static Future<void> cacheFlights(List<dynamic> flights) async {
    final prefs = await SharedPreferences.getInstance();
    final flightsJson = json.encode(flights);
    await prefs.setString(flightsKey, flightsJson);
  }

  static Future<List<dynamic>> getCachedFlights() async {
    final prefs = await SharedPreferences.getInstance();
    final flightsJson = prefs.getString(flightsKey);
    if (flightsJson != null) {
      return json.decode(flightsJson);
    }
    return [];
  }

  // Cache user login state
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(loginKey, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey) ?? false;
  }

  // Cache user data
  static Future<void> cacheUser(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, json.encode(userData));
  }

  static Future<Map<String, dynamic>?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(userKey);
    if (userJson != null) {
      return json.decode(userJson);
    }
    return null;
  }

  // Clear all cache
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
