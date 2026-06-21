import 'package:equatable/equatable.dart';


class TaskStatsModel extends Equatable {
  final int dueToday;
  final int pendingReview;
  final CompletedStats completed;

  const TaskStatsModel({
    required this.dueToday,
    required this.pendingReview,
    required this.completed,
  });

  factory TaskStatsModel.fromJson(Map<String, dynamic> json) {
    return TaskStatsModel(
      dueToday: json['dueToday'] ?? 0,
      pendingReview: json['pendingReview'] ?? 0,
      completed: CompletedStats.fromJson(json['completed'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dueToday': dueToday,
      'pendingReview': pendingReview,
      'completed': completed.toJson(),
    };
  }

  @override
  List<Object?> get props => [dueToday, pendingReview, completed];
}

class CompletedStats extends Equatable {
  final int total;
  final int thisWeek;

  const CompletedStats({
    required this.total,
    required this.thisWeek,
  });

  factory CompletedStats.fromJson(Map<String, dynamic> json) {
    return CompletedStats(
      total: json['total'] ?? 0,
      thisWeek: json['thisWeek'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'thisWeek': thisWeek,
    };
  }

  @override
  List<Object?> get props => [total, thisWeek];
}


class TaskModel extends Equatable {
  final String id;
  final String projectId;
  final String title;
  final List<AssignedTo> assignedTo;
  final String status;
  final String priority;
  final String deadline;
  final String acceptance;
  final String document;
  final String createdAt;
  final String updatedAt;
  final String completedAt;

  const TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.assignedTo,
    required this.status,
    required this.priority,
    required this.deadline,
    required this.acceptance,
    required this.document,
    required this.createdAt,
    required this.updatedAt,
    required this.completedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'] ?? '',
      projectId: json['projectId'] ?? '',
      title: json['title'] ?? '',
      assignedTo: (json['assignedTo'] as List?)
              ?.map((item) => AssignedTo.fromJson(item))
              .toList() ?? [],
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      deadline: json['deadline'] ?? '',
      acceptance: json['acceptance'] ?? '',
      document: json['document'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      completedAt: json['completedAt'] ?? '',
    );
  }

  TaskModel copyWith({
    String? id,
    String? projectId,
    String? title,
    List<AssignedTo>? assignedTo,
    String? status,
    String? priority,
    String? deadline,
    String? acceptance,
    String? document,
    String? createdAt,
    String? updatedAt,
    String? completedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      assignedTo: assignedTo ?? this.assignedTo,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      acceptance: acceptance ?? this.acceptance,
      document: document ?? this.document,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        title,
        assignedTo,
        status,
        priority,
        deadline,
        acceptance,
        document,
        createdAt,
        updatedAt,
        completedAt,
      ];
}

class AssignedTo extends Equatable {
  final String id;
  final GeneralInfo general;
  final EmployeeInfo employee;

  const AssignedTo({
    required this.id,
    required this.general,
    required this.employee,
  });

  factory AssignedTo.fromJson(Map<String, dynamic> json) {
    return AssignedTo(
      id: json['_id'] ?? '',
      general: GeneralInfo.fromJson(json['general'] ?? {}),
      employee: EmployeeInfo.fromJson(json['employee'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [id, general, employee];
}

class GeneralInfo extends Equatable {
  final String firstName;
  final String lastName;
  final String avatar;

  const GeneralInfo({
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory GeneralInfo.fromJson(Map<String, dynamic> json) {
    return GeneralInfo(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  @override
  List<Object?> get props => [firstName, lastName, avatar];
}

class EmployeeInfo extends Equatable {
  final String jobTitle;

  const EmployeeInfo({required this.jobTitle});

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      jobTitle: json['jobTitle'] ?? '',
    );
  }

  @override
  List<Object?> get props => [jobTitle];
}