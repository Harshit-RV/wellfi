// ignore_for_file: file_names

class DailyActivity {
  final DateTime date;
  final int steps;
  final double distance;

  DailyActivity({
    required this.date,
    this.steps = 0,
    this.distance = 0.0,
  });

  factory DailyActivity.fromJson(Map<String, dynamic> json) {
    return DailyActivity(
      date: DateTime.parse(json['date']),
      steps: json['steps'] ?? 0,
      distance: (json['distance'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'steps': steps,
      'distance': distance,
    };
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? walletAddress;
  final List<DailyActivity> activityData;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.walletAddress,
    this.activityData = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      walletAddress: json['walletAddress'],
      activityData: (json['activityData'] as List)
          .map((item) => DailyActivity.fromJson(item))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'walletAddress': walletAddress,
      'activityData': activityData.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, walletAddress: $walletAddress, activityData: $activityData, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
