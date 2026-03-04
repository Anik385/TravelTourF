import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travel_tour_app/models/flight_model.dart';
import 'package:travel_tour_app/services/api_service.dart';

class FlightProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<FlightModel> _flights = [];
  List<FlightModel> _filteredFlights = [];
  FlightModel? _selectedFlight;
  bool _isLoading = false;
  String? _error;
  String _selectedSort = 'price';

  List<FlightModel> get flights => _filteredFlights;
  FlightModel? get selectedFlight => _selectedFlight;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedSort => _selectedSort;

  // Fetch all flights
  Future<void> fetchFlights() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getAllFlights();
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.body.isEmpty || response.body == 'null') {
        _flights = [];
        _filteredFlights = [];
      } else {
        // Your API returns a List directly
        final List<dynamic> data = json.decode(response.body);
        print('📊 Parsed ${data.length} flights');

        _flights = data.map((item) => FlightModel.fromJson(item)).toList();
        _filteredFlights = List.from(_flights);
        _sortFlights();
      }
      _error = null;
    } catch (e, stacktrace) {
      print('❌ Error parsing flights: $e');
      print('📚 Stacktrace: $stacktrace');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // CRITICAL: Notify that data is loaded
    }
  }

  //   try {
  //     final response = await _apiService.getAllFlights();
  //     final String responseBody = response.body; // ✅ Get raw response
  //     final dynamic data = json.decode(responseBody); // ✅ Parse JSON

  //     final List<dynamic> flightData = data is List
  //         ? data
  //         : (data as Map<String, dynamic>)['data'] ?? [];
  //     // final data = await _apiService.getAllFlights();
  //     // final List<dynamic> flightData = data is List
  //     //     ? data
  //     //     : (data as Map<String, dynamic>)['data'] ?? [];

  //     _flights = flightData.map((item) => FlightModel.fromJson(item)).toList();
  //     _filteredFlights = List.from(_flights);
  //     _sortFlights();
  //     _error = null;
  //   } catch (e) {
  //     _error = e.toString();
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Search flights
  Future<void> searchFlights(Map<String, dynamic> searchData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.searchFlights(searchData);
      final List<dynamic> flightData = data is List
          ? data
          : (data as Map<String, dynamic>)['data'] ?? [];

      _filteredFlights = flightData
          .map((item) => FlightModel.fromJson(item))
          .toList();
      _sortFlights();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get flight by ID
  Future<void> fetchFlightById(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getFlightById(id);
      final Map<String, dynamic> flightData = response is Map<String, dynamic>
          ? response
          : (response as Map<String, dynamic>)['data'] ?? {};
      _selectedFlight = FlightModel.fromJson(flightData);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sort flights
  void sortFlights(String sortBy) {
    _selectedSort = sortBy;
    _sortFlights();
    notifyListeners();
  }

  void _sortFlights() {
    switch (_selectedSort) {
      case 'price':
        _filteredFlights.sort(
          (a, b) => a.price.economy.compareTo(b.price.economy),
        );
        break;
      case 'duration':
        // Parse duration string to minutes for comparison
        _filteredFlights.sort((a, b) {
          final aDuration = _parseDuration(a.duration);
          final bDuration = _parseDuration(b.duration);
          return aDuration.compareTo(bDuration);
        });
        break;
      case 'departure':
        _filteredFlights.sort(
          (a, b) => a.departure.time.compareTo(b.departure.time),
        );
        break;
    }
  }

  int _parseDuration(String duration) {
    try {
      final parts = duration.split(' ');
      int totalMinutes = 0;

      for (final part in parts) {
        if (part.contains('h')) {
          totalMinutes += int.parse(part.replaceAll('h', '')) * 60;
        } else if (part.contains('m')) {
          totalMinutes += int.parse(part.replaceAll('m', ''));
        }
      }

      return totalMinutes;
    } catch (e) {
      return 0;
    }
  }

  // Filter flights by price
  void filterByPrice(double minPrice, double maxPrice) {
    _filteredFlights = _flights
        .where(
          (flight) =>
              flight.price.economy >= minPrice &&
              flight.price.economy <= maxPrice,
        )
        .toList();
    _sortFlights();
    notifyListeners();
  }

  // Filter flights by airline
  void filterByAirline(String airline) {
    if (airline.isEmpty) {
      _filteredFlights = List.from(_flights);
    } else {
      _filteredFlights = _flights
          .where(
            (flight) =>
                flight.airline.toLowerCase().contains(airline.toLowerCase()),
          )
          .toList();
    }
    _sortFlights();
    notifyListeners();
  }

  // Filter flights by stops
  void filterByStops(int maxStops) {
    _filteredFlights = _flights
        .where((flight) => flight.stops <= maxStops)
        .toList();
    _sortFlights();
    notifyListeners();
  }

  // Clear filters
  void clearFilters() {
    _filteredFlights = List.from(_flights);
    _sortFlights();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear selected flight
  void clearSelectedFlight() {
    _selectedFlight = null;
    notifyListeners();
  }
}
