class User {
  final String name;
  final String email;
  final String phone;
  final DateTime joinDate;
  final int reports;
  final String status;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.joinDate,
    required this.reports,
    required this.status,
  });
}

class EmergencyReport {
  final String userName;
  final String location;
  final String emergencyType;
  final String time;
  final String status;
  final String address;

  EmergencyReport({
    required this.userName,
    required this.location,
    required this.emergencyType,
    required this.time,
    required this.status,
    required this.address,
  });
}

class Alert {
  final String title;
  final String region;
  final String severity;
  final String time;
  final String description;

  Alert({
    required this.title,
    required this.region,
    required this.severity,
    required this.time,
    required this.description,
  });
}
