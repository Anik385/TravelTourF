class ItineraryDayModel {
  final int day;
  final String title;
  final String description;

  ItineraryDayModel({
    required this.day,
    required this.title,
    required this.description,
  });

  factory ItineraryDayModel.fromJson(Map<String, dynamic> json) {
    return ItineraryDayModel(
      day: json['day'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'title': title,
      'description': description,
    };
  }
}