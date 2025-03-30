class ChallengeTarget {
  final int steps;
  final int distance;

  ChallengeTarget({required this.steps, required this.distance});

  factory ChallengeTarget.fromJson(Map<String, dynamic> json) {
    return ChallengeTarget(
      steps: json['steps'] as int,
      distance: json['distance'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
      'distance': distance,
    };
  }
}

class Challenge {
  final String title;
  final String desc;
  final String creator;
  final String visibility;
  final DateTime startDate;
  final List<String> participants;
  final double requiredStake;
  final String type;
  final String targetType;
  final DateTime deadline;
  final ChallengeTarget target;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Challenge({
    required this.title,
    required this.desc,
    required this.creator,
    required this.visibility,
    required this.startDate,
    required this.participants,
    required this.requiredStake,
    required this.type,
    required this.targetType,
    required this.deadline,
    required this.target,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      title: json['title'] as String,
      desc: json['desc'] as String,
      creator: json['creator'] as String,
      visibility: json['visibility'] as String,
      startDate: DateTime.parse(json['start_date']),
      participants: List<String>.from(json['participants']),
      requiredStake: (json['required_stake'] as num).toDouble(),
      type: json['type'] as String,
      targetType: json['targetType'] as String,
      deadline: DateTime.parse(json['deadline']),
      target: ChallengeTarget.fromJson(json['target']),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'creator': creator,
      'visibility': visibility,
      'startDate': startDate.toIso8601String(),
      'participants': participants,
      'requiredStake': requiredStake,
      'type': type,
      'targetType': targetType,
      'deadline': deadline.toIso8601String(),
      'target': target.toJson(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Challenge{title: $title, desc: $desc, creator: $creator, visibility: $visibility, startDate: $startDate, participants: $participants, requiredStake: $requiredStake, type: $type, targetType: $targetType, deadline: $deadline, target: $target, status: $status, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  static Challenge fromMap(Map<String, dynamic> map) {
    return Challenge(
      title: map['title'] as String,
      desc: map['desc'] as String,
      creator: map['creator'] as String,
      visibility: map['visibility'] as String,
      startDate: DateTime.parse(map['startDate']),
      participants: List<String>.from(map['participants']),
      requiredStake: (map['requiredStake'] as num).toDouble(),
      type: map['type'] as String,
      targetType: map['targetType'] as String,
      deadline: DateTime.parse(map['deadline']),
      target: ChallengeTarget.fromJson(map['target']),
      status: map['status'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
