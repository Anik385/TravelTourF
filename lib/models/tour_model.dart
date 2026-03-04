import 'package:travel_tour_app/models/itinerary_day_model.dart';

class TourModel {
  final int? id;
  final String title;
  final String destination;
  final int duration;
  final double price;
  final String description;
  final List<String> images;
  final List<String> inclusions;
  final List<ItineraryDayModel> itinerary;
  final bool isActive;
  final List<String> categories;

  TourModel({
    this.id,
    required this.title,
    required this.destination,
    required this.duration,
    required this.price,
    required this.description,
    required this.images,
    required this.inclusions,
    required this.itinerary,
    required this.isActive,
    required this.categories,
  });

  factory TourModel.fromJson(Map<String, dynamic> json) {
    return TourModel(
      id: json['id'],
      title: json['title'],
      destination: json['destination'],
      duration: json['duration'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      images: List<String>.from(json['images'] ?? []),
      inclusions: List<String>.from(json['inclusions'] ?? []),
      itinerary:
          (json['itinerary'] as List?)
              ?.map((item) => ItineraryDayModel.fromJson(item))
              .toList() ??
          [],
      isActive: json['isActive'] ?? true,
      categories: List<String>.from(json['categories'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'destination': destination,
      'duration': duration,
      'price': price,
      'description': description,
      'images': images,
      'inclusions': inclusions,
      'itinerary': itinerary.map((item) => item.toJson()).toList(),
      'isActive': isActive,
      'categories': categories,
    };
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
  String get durationText => '$duration ${duration == 1 ? 'day' : 'days'}';
}
