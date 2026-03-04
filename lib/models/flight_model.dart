class FlightModel {
  final int? id;
  final String airline;
  final String flightNumber;
  final FlightSchedule departure;
  final FlightSchedule arrival;
  final String duration;
  final int stops;
  final FlightPrice price;
  final int seatsAvailable;
  final String aircraft;
  final String? departureAirportCode;
  final String? arrivalAirportCode;

  FlightModel({
    this.id,
    required this.airline,
    required this.flightNumber,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.stops,
    required this.price,
    required this.seatsAvailable,
    required this.aircraft,
    this.departureAirportCode,
    this.arrivalAirportCode,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    print('🔧 Parsing flight: ${json['flightNumber']}');
    return FlightModel(
      id: json['id'],
      airline: json['airline'] ?? '',
      flightNumber: json['flightNumber'] ?? '',
      departure: FlightSchedule.fromJson(json['departure'] ?? {}),
      arrival: FlightSchedule.fromJson(json['arrival'] ?? {}),
      duration: json['duration'] ?? '',
      stops: json['stops'] ?? 0,
      price: FlightPrice.fromJson(json['price'] ?? {}),
      seatsAvailable: json['seatsAvailable'] ?? 0,
      aircraft: json['aircraft'] ?? '',
      departureAirportCode: json['departureAirportCode'],
      arrivalAirportCode: json['arrivalAirportCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'airline': airline,
      'flightNumber': flightNumber,
      'departure': departure.toJson(),
      'arrival': arrival.toJson(),
      'duration': duration,
      'stops': stops,
      'price': price.toJson(),
      'seatsAvailable': seatsAvailable,
      'aircraft': aircraft,
      'departureAirportCode': departureAirportCode,
      'arrivalAirportCode': arrivalAirportCode,
    };
  }

  String get formattedFlight => '$airline $flightNumber';
  String get route => '${departure.airport} → ${arrival.airport}';
  double get economyPrice => price.economy;
  double get businessPrice => price.business;
  double get firstClassPrice => price.firstClass;
}

class FlightSchedule {
  final String airport;
  final DateTime time;
  final DateTime date;

  FlightSchedule({
    required this.airport,
    required this.time,
    required this.date,
  });

  factory FlightSchedule.fromJson(Map<String, dynamic> json) {
    return FlightSchedule(
      airport: json['airport'],
      time: DateTime.parse(json['time']),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airport': airport,
      'time': time.toIso8601String(),
      'date': date.toIso8601String(),
    };
  }

  String get formattedTime {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get formattedDate => '${date.day}/${date.month}/${date.year}';
}

class FlightPrice {
  final double economy;
  final double business;
  final double firstClass;

  FlightPrice({
    required this.economy,
    required this.business,
    required this.firstClass,
  });

  factory FlightPrice.fromJson(Map<String, dynamic> json) {
    return FlightPrice(
      economy: (json['economy'] as num).toDouble(),
      business: (json['business'] as num).toDouble(),
      firstClass: (json['firstClass'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'economy': economy, 'business': business, 'firstClass': firstClass};
  }

  String get economyFormatted => '\$$economy';
  String get businessFormatted => '\$$business';
  String get firstClassFormatted => '\$$firstClass';
}
