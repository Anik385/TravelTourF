class AirportModel {
  final String code; // IATA code
  final String name;
  final String city;
  final String country;

  AirportModel({
    required this.code,
    required this.name,
    required this.city,
    required this.country,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      code: json['code'],
      name: json['name'],
      city: json['city'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'city': city,
      'country': country,
    };
  }

  String get location => '$city, $country';
  String get displayText => '$code - $name';
}