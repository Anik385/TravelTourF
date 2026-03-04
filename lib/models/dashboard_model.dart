class DashboardStats {
  final int totalUsers;
  final int totalTours;
  final int totalFlights;
  final int totalBookings;
  final double monthlyRevenue;
  final double yearlyRevenue;
  final List<RecentBooking> recentBookings;
  final List<PopularTour> popularTours;

  DashboardStats({
    required this.totalUsers,
    required this.totalTours,
    required this.totalFlights,
    required this.totalBookings,
    required this.monthlyRevenue,
    required this.yearlyRevenue,
    required this.recentBookings,
    required this.popularTours,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalUsers: json['totalUsers'],
      totalTours: json['totalTours'],
      totalFlights: json['totalFlights'],
      totalBookings: json['totalBookings'],
      monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
      yearlyRevenue: (json['yearlyRevenue'] as num).toDouble(),
      recentBookings: (json['recentBookings'] as List)
          .map((item) => RecentBooking.fromJson(item))
          .toList(),
      popularTours: (json['popularTours'] as List)
          .map((item) => PopularTour.fromJson(item))
          .toList(),
    );
  }
}

class RecentBooking {
  final String bookingReference;
  final String customerName;
  final String tourName;
  final double amount;
  final DateTime bookingDate;

  RecentBooking({
    required this.bookingReference,
    required this.customerName,
    required this.tourName,
    required this.amount,
    required this.bookingDate,
  });

  factory RecentBooking.fromJson(Map<String, dynamic> json) {
    return RecentBooking(
      bookingReference: json['bookingReference'],
      customerName: json['customerName'],
      tourName: json['tourName'],
      amount: (json['amount'] as num).toDouble(),
      bookingDate: DateTime.parse(json['bookingDate']),
    );
  }
}

class PopularTour {
  final String tourName;
  final int bookingsCount;
  final double totalRevenue;

  PopularTour({
    required this.tourName,
    required this.bookingsCount,
    required this.totalRevenue,
  });

  factory PopularTour.fromJson(Map<String, dynamic> json) {
    return PopularTour(
      tourName: json['tourName'],
      bookingsCount: json['bookingsCount'],
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
    );
  }
}

class BookingStats {
  final int totalBookings;
  final double totalRevenue;
  final int confirmedBookings;
  final int cancelledBookings;
  final double averageBookingValue;
  final Map<String, int> bookingsByStatus;

  BookingStats({
    required this.totalBookings,
    required this.totalRevenue,
    required this.confirmedBookings,
    required this.cancelledBookings,
    required this.averageBookingValue,
    required this.bookingsByStatus,
  });

  factory BookingStats.fromJson(Map<String, dynamic> json) {
    return BookingStats(
      totalBookings: json['totalBookings'],
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      confirmedBookings: json['confirmedBookings'],
      cancelledBookings: json['cancelledBookings'],
      averageBookingValue: (json['averageBookingValue'] as num).toDouble(),
      bookingsByStatus: Map<String, int>.from(json['bookingsByStatus']),
    );
  }
}