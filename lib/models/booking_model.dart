import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class BookingModel {
  final int? id;
  final String bookingReference;
  final int userId;
  final int? tourId;
  final int? flightId;
  final DateTime bookingDate;
  final DateTime travelDate;
  final int numberOfGuests;
  final double totalAmount;
  final String status;

  BookingModel({
    this.id,
    required this.bookingReference,
    required this.userId,
    this.tourId,
    this.flightId,
    required this.bookingDate,
    required this.travelDate,
    required this.numberOfGuests,
    required this.totalAmount,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      bookingReference: json['bookingReference'],
      userId: json['userId'],
      tourId: json['tourId'],
      flightId: json['flightId'],
      bookingDate: DateTime.parse(json['bookingDate']),
      travelDate: DateTime.parse(json['travelDate']),
      numberOfGuests: json['numberOfGuests'],
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingReference': bookingReference,
      'userId': userId,
      'tourId': tourId,
      'flightId': flightId,
      'bookingDate': bookingDate.toIso8601String(),
      'travelDate': travelDate.toIso8601String(),
      'numberOfGuests': numberOfGuests,
      'totalAmount': totalAmount,
      'status': status,
    };
  }

  String get formattedBookingDate => DateFormat('dd MMM yyyy').format(bookingDate);
  String get formattedTravelDate => DateFormat('dd MMM yyyy').format(travelDate);
  String get formattedAmount => '\$${totalAmount.toStringAsFixed(2)}';
  
  String get bookingType {
    if (tourId != null && flightId != null) return 'Tour + Flight';
    if (tourId != null) return 'Tour Package';
    if (flightId != null) return 'Flight Only';
    return 'Unknown';
  }

  Color get statusColor {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      case 'CANCELLED':
        return Colors.red;
      case 'COMPLETED':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String get statusText {
    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        return 'Confirmed';
      case 'PENDING':
        return 'Pending';
      case 'CANCELLED':
        return 'Cancelled';
      case 'COMPLETED':
        return 'Completed';
      default:
        return status;
    }
  }
}