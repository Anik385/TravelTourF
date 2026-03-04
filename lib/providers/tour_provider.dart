import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:travel_tour_app/models/tour_model.dart';
import 'package:travel_tour_app/services/api_service.dart';

class TourProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<TourModel> _tours = [];
  List<TourModel> _filteredTours = [];
  TourModel? _selectedTour;
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _currentCategory = '';

  List<TourModel> get tours => _filteredTours;
  List<TourModel> get allTours => _tours;
  TourModel? get selectedTour => _selectedTour;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get currentCategory => _currentCategory;

  // Fetch all tours
  Future<void> fetchTours() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getAllTours();
      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.body.isEmpty || response.body == 'null') {
        _tours = [];
      } else {
        final List<dynamic> data = json.decode(response.body);
        _tours = data.map((item) => TourModel.fromJson(item)).toList();
        print('✅ Tours loaded: ${_tours.length}');
      }

      _filteredTours = List.from(_tours);
      _error = null;
    } catch (e, stacktrace) {
      print('❌ Error: $e');
      print('📚 Stacktrace: $stacktrace');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get tour by ID
  Future<void> fetchTourById(int id) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _apiService.getTourById(id);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _selectedTour = TourModel.fromJson(data);
      }

      // Safely notify after build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isLoading = false;
        _error = e.toString();
        notifyListeners();
      });
    }
  }

  // Search tours
  Future<void> searchTours(String query) async {
    _searchQuery = query;
    _isLoading = true;
    notifyListeners();

    try {
      if (query.isEmpty) {
        _filteredTours = List.from(_tours);
      } else {
        final response = await _apiService.searchTours(query);
        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          _filteredTours = data
              .map((item) => TourModel.fromJson(item))
              .toList();
        }
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter by category
  void filterByCategory(String category) {
    print('🔍 Filtering by category: "$category"');
    _currentCategory = category;
    _filteredTours = _tours
        .where((tour) => tour.categories.contains(category))
        .toList();
    print('📊 Found ${_filteredTours.length} tours with category "$category"');
    notifyListeners();
  }

  // Filter by destination
  void filterByDestination(String destination) {
    if (destination.isEmpty) {
      _filteredTours = List.from(_tours);
    } else {
      _filteredTours = _tours
          .where(
            (tour) => tour.destination.toLowerCase().contains(
              destination.toLowerCase(),
            ),
          )
          .toList();
    }
    notifyListeners();
  }

  // Filter by price range
  void filterByPriceRange(double minPrice, double maxPrice) {
    _filteredTours = _tours
        .where((tour) => tour.price >= minPrice && tour.price <= maxPrice)
        .toList();
    notifyListeners();
  }

  // Filter by duration
  void filterByDuration(int minDays, int maxDays) {
    _filteredTours = _tours
        .where((tour) => tour.duration >= minDays && tour.duration <= maxDays)
        .toList();
    notifyListeners();
  }

  // Sort tours
  void sortTours(String sortBy) {
    switch (sortBy) {
      case 'price_low':
        _filteredTours.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        _filteredTours.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'duration':
        _filteredTours.sort((a, b) => a.duration.compareTo(b.duration));
        break;
    }
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _currentCategory = '';
    _filteredTours = List.from(_tours);
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear selected tour
  void clearSelectedTour() {
    _selectedTour = null;
    notifyListeners();
  }

  // Create new tour (admin only)
  Future<bool> createTour(Map<String, dynamic> tourData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.createTour(tourData);
      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchTours(); // Refresh list
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to create tour';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get unique categories from all tours
  List<String> getUniqueCategories() {
    Set<String> categories = {};
    for (var tour in _tours) {
      categories.addAll(tour.categories);
    }
    return categories.toList();
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:travel_tour_app/models/tour_model.dart';
// import 'package:travel_tour_app/services/api_service.dart';
// import 'package:travel_tour_app/services/cache_service.dart';
// import 'package:travel_tour_app/services/connectivity_service.dart';

// class TourProvider with ChangeNotifier {
//   final ApiService _apiService = ApiService();

//   List<TourModel> _tours = [];
//   List<TourModel> _filteredTours = [];
//   TourModel? _selectedTour;
//   bool _isLoading = false;
//   String? _error;
//   String _searchQuery = '';
//   String _currentCategory = '';

//   List<TourModel> get tours => _filteredTours;
//   List<TourModel> get allTours => _tours;
//   TourModel? get selectedTour => _selectedTour;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   String get searchQuery => _searchQuery;
//   String get currentCategory => _currentCategory;

//   // Fetch all tours with offline support
//   Future<void> fetchTours() async {
//     _isLoading = true;
//     _error = null;

//     try {
//       if (await ConnectivityService.hasInternet()) {
//         // Online - fetch from API
//         final response = await _apiService.getAllTours();
//         print('📡 Response status: ${response.statusCode}');
//         print('📡 Response body: ${response.body}');

//         if (response.body.isEmpty || response.body == 'null') {
//           _tours = [];
//         } else {
//           final List<dynamic> data = json.decode(response.body);
//           _tours = data.map((item) => TourModel.fromJson(item)).toList();
//           await CacheService.cacheTours(data); // Cache for offline
//           print('✅ Tours loaded: ${_tours.length}');
//         }
//       } else {
//         // Offline - load from cache
//         print('📱 Offline mode - loading from cache');
//         final cached = await CacheService.getCachedTours();
//         _tours = cached.map((item) => TourModel.fromJson(item)).toList();
//         print('✅ Loaded ${_tours.length} tours from cache');
//       }

//       _applyFilters();
//       _error = null;
//     } catch (e, stacktrace) {
//       print('❌ Error: $e');
//       print('📚 Stacktrace: $stacktrace');
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Get tour by ID - FIXED with WidgetsBinding
//   Future<void> fetchTourById(int id) async {
//     _isLoading = true;
//     _error = null;
//     // DON'T call notifyListeners() here during build

//     try {
//       if (await ConnectivityService.hasInternet()) {
//         final response = await _apiService.getTourById(id);
//         if (response.statusCode == 200) {
//           final Map<String, dynamic> data = json.decode(response.body);
//           _selectedTour = TourModel.fromJson(data);
//         }
//       } else {
//         // Find in cached tours
//         _selectedTour = _tours.firstWhere(
//           (tour) => tour.id == id,
//           orElse: () => throw Exception('Tour not found in cache'),
//         );
//       }

//       // Safely notify after build is complete
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _isLoading = false;
//         notifyListeners();
//       });
//     } catch (e) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _isLoading = false;
//         _error = e.toString();
//         notifyListeners();
//       });
//     }
//   }

//   // Search tours
//   Future<void> searchTours(String query) async {
//     _searchQuery = query;
//     _isLoading = true;
//     notifyListeners();

//     try {
//       if (query.isEmpty) {
//         _applyFilters();
//       } else {
//         if (await ConnectivityService.hasInternet()) {
//           final response = await _apiService.searchTours(query);
//           if (response.statusCode == 200) {
//             final List<dynamic> data = json.decode(response.body);
//             _filteredTours = data
//                 .map((item) => TourModel.fromJson(item))
//                 .toList();
//           }
//         } else {
//           // Offline search in cached tours
//           _filteredTours = _tours
//               .where(
//                 (tour) =>
//                     tour.title.toLowerCase().contains(query.toLowerCase()) ||
//                     tour.destination.toLowerCase().contains(
//                       query.toLowerCase(),
//                     ),
//               )
//               .toList();
//         }
//       }
//       _error = null;
//     } catch (e) {
//       _error = e.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // Filter by category
//   void filterByCategory(String category) {
//     print('🔍 Filtering by category: "$category"');
//     _currentCategory = category;
//     _applyFilters();
//     print('📊 Found ${_filteredTours.length} tours with category "$category"');
//     notifyListeners();
//   }

//   // Apply all filters (search + category)
//   void _applyFilters() {
//     var results = List<TourModel>.from(_tours);

//     // Apply category filter
//     if (_currentCategory.isNotEmpty) {
//       results = results
//           .where((tour) => tour.categories.contains(_currentCategory))
//           .toList();
//     }

//     // Apply search filter
//     if (_searchQuery.isNotEmpty) {
//       results = results
//           .where(
//             (tour) =>
//                 tour.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
//                 tour.destination.toLowerCase().contains(
//                   _searchQuery.toLowerCase(),
//                 ),
//           )
//           .toList();
//     }

//     _filteredTours = results;
//   }

//   // Filter by destination
//   void filterByDestination(String destination) {
//     if (destination.isEmpty) {
//       _applyFilters();
//     } else {
//       _filteredTours = _tours
//           .where(
//             (tour) => tour.destination.toLowerCase().contains(
//               destination.toLowerCase(),
//             ),
//           )
//           .toList();
//     }
//     notifyListeners();
//   }

//   // Filter by price range
//   void filterByPriceRange(double minPrice, double maxPrice) {
//     _filteredTours = _tours
//         .where((tour) => tour.price >= minPrice && tour.price <= maxPrice)
//         .toList();
//     notifyListeners();
//   }

//   // Filter by duration
//   void filterByDuration(int minDays, int maxDays) {
//     _filteredTours = _tours
//         .where((tour) => tour.duration >= minDays && tour.duration <= maxDays)
//         .toList();
//     notifyListeners();
//   }

//   // Sort tours
//   void sortTours(String sortBy) {
//     switch (sortBy) {
//       case 'price_low':
//         _filteredTours.sort((a, b) => a.price.compareTo(b.price));
//         break;
//       case 'price_high':
//         _filteredTours.sort((a, b) => b.price.compareTo(a.price));
//         break;
//       case 'duration':
//         _filteredTours.sort((a, b) => a.duration.compareTo(b.duration));
//         break;
//     }
//     notifyListeners();
//   }

//   // Clear all filters
//   void clearFilters() {
//     _searchQuery = '';
//     _currentCategory = '';
//     _filteredTours = List.from(_tours);
//     notifyListeners();
//   }

//   // Clear error
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }

//   // Clear selected tour
//   void clearSelectedTour() {
//     _selectedTour = null;
//     notifyListeners();
//   }

//   // Create new tour (admin only)
//   Future<bool> createTour(Map<String, dynamic> tourData) async {
//     _isLoading = true;
//     _error = null;
//     notifyListeners();

//     try {
//       final response = await _apiService.createTour(tourData);
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         await fetchTours(); // Refresh list
//         _isLoading = false;
//         notifyListeners();
//         return true;
//       } else {
//         _error = 'Failed to create tour';
//         _isLoading = false;
//         notifyListeners();
//         return false;
//       }
//     } catch (e) {
//       _error = e.toString();
//       _isLoading = false;
//       notifyListeners();
//       return false;
//     }
//   }

//   // Get unique categories from all tours
//   List<String> getUniqueCategories() {
//     Set<String> categories = {};
//     for (var tour in _tours) {
//       categories.addAll(tour.categories);
//     }
//     return categories.toList();
//   }
// }
