import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:travel_tour_app/models/dashboard_model.dart';
import 'package:travel_tour_app/services/api_service.dart';

class AdminProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  DashboardStats? _dashboardStats;
  BookingStats? _bookingStats;
  bool _isLoading = false;
  String? _error;

  DashboardStats? get dashboardStats => _dashboardStats;
  BookingStats? get bookingStats => _bookingStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch dashboard stats
  Future<void> fetchDashboardStats() async {
    if (_isLoading) return; // Prevent multiple simultaneous calls
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getDashboardStats();
      _dashboardStats = DashboardStats.fromJson(jsonDecode(response.body));
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch booking stats
  Future<void> fetchBookingStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getBookingStats();
      _bookingStats = BookingStats.fromJson(jsonDecode(response.body));
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch sales report
  Future<String> fetchSalesReport(DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getSalesReport(startDate, endDate);
      _isLoading = false;
      notifyListeners();
      return response.body;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Fetch popular tours report
  Future<String> fetchPopularToursReport() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getPopularToursReport();
      _isLoading = false;
      notifyListeners();
      return response.body;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Fetch revenue report
  Future<String> fetchRevenueReport({int? year, int? month}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getRevenueReport(year, month);
      _isLoading = false;
      notifyListeners();
      return response.body;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Clear all data
  void clearData() {
    _dashboardStats = null;
    _bookingStats = null;
    _error = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
