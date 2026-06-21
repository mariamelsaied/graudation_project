class DashboardStatsModel {
  final String? status;
  final DashboardData? data;

  DashboardStatsModel({this.status, this.data});

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      status: json['status'],
      data: json['data'] != null ? DashboardData.fromJson(json['data']) : null,
    );
  }
}

class DashboardData {
  final TodayStatus? todayStatus;
  final int? leaveBalance;
  final ActiveTasks? activeTasks;
  final int? pendingRequests;

  DashboardData({
    this.todayStatus,
    this.leaveBalance,
    this.activeTasks,
    this.pendingRequests,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      todayStatus: json['todayStatus'] != null 
          ? TodayStatus.fromJson(json['todayStatus']) 
          : null,
      leaveBalance: json['leaveBalance'],
      activeTasks: json['activeTasks'] != null 
          ? ActiveTasks.fromJson(json['activeTasks']) 
          : null,
      pendingRequests: json['pendingRequests'],
    );
  }
}

class TodayStatus {
  final String? status;
  final String? checkIn;

  TodayStatus({this.status, this.checkIn});

  factory TodayStatus.fromJson(Map<String, dynamic> json) {
    return TodayStatus(
      status: json['status'],
      checkIn: json['checkIn'], 
    );
  }
}

class ActiveTasks {
  final int? count;
  final int? highPriorityCount;

  ActiveTasks({this.count, this.highPriorityCount});

  factory ActiveTasks.fromJson(Map<String, dynamic> json) {
    return ActiveTasks(
      count: json['count'],
      highPriorityCount: json['highPriorityCount'],
    );
  }
}


class WeeklyAttendanceModel {
  final String? status;
  final List<WeeklyStatsItem>? weeklyAttendanceStats;

  WeeklyAttendanceModel({this.status, this.weeklyAttendanceStats});

  factory WeeklyAttendanceModel.fromJson(Map<String, dynamic> json) {
    return WeeklyAttendanceModel(
      status: json['status'],
      weeklyAttendanceStats: json['data'] != null && json['data']['weeklyAttendenceStats'] != null
          ? (json['data']['weeklyAttendenceStats'] as List)
              .map((item) => WeeklyStatsItem.fromJson(item))
              .toList()
          : [],
    );
  }
}

class WeeklyStatsItem {
  final int? onTimeCount;
  final int? lateCount;
  final int? absentCount;
  final String? fullDate;
  final String? dayName;

  WeeklyStatsItem({
    this.onTimeCount,
    this.lateCount,
    this.absentCount,
    this.fullDate,
    this.dayName,
  });

  factory WeeklyStatsItem.fromJson(Map<String, dynamic> json) {
    return WeeklyStatsItem(
      onTimeCount: json['onTimeCount'],
      lateCount: json['lateCount'],
      absentCount: json['absentCount'],
      fullDate: json['fullDate'],
      dayName: json['dayName'],
    );
  }
}


class MyProjectsModel {
  final String? status;
  final ProjectsData? data;

  MyProjectsModel({this.status, this.data});

  factory MyProjectsModel.fromJson(Map<String, dynamic> json) {
    return MyProjectsModel(
      status: json['status'],
      data: json['data'] != null ? ProjectsData.fromJson(json['data']) : null,
    );
  }
}

class ProjectsData {
  final List<ProjectItem>? projects;

  ProjectsData({this.projects});

  factory ProjectsData.fromJson(Map<String, dynamic> json) {
    return ProjectsData(
      projects: json['projects'] != null
          ? (json['projects'] as List).map((i) => ProjectItem.fromJson(i)).toList()
          : [],
    );
  }
}

class ProjectItem {
  final String? id;
  final String? priority;
  final String? name;
  final String? description;
  final DateTime? deadline;
  final List<AssignedUser>? assignedTo;
  final int? projectProgress;

  ProjectItem({
    this.id,
    this.priority,
    this.name,
    this.description,
    this.deadline,
    this.assignedTo,
    this.projectProgress,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      id: json['_id'],
      priority: json['priority'],
      name: json['name'],
      description: json['description'],
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      projectProgress: json['projectProgress'],
      assignedTo: json['assignedTo'] != null
          ? (json['assignedTo'] as List).map((i) => AssignedUser.fromJson(i)).toList()
          : [],
    );
  }
}

class AssignedUser {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? avatar;

  AssignedUser({this.id, this.firstName, this.lastName, this.avatar});

  factory AssignedUser.fromJson(Map<String, dynamic> json) {
    return AssignedUser(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
    );
  }
}


class RecentRequestsModel {
  final String? status;
  final RecentRequestsData? data;

  RecentRequestsModel({this.status, this.data});

  factory RecentRequestsModel.fromJson(Map<String, dynamic> json) {
    return RecentRequestsModel(
      status: json['status'],
      data: json['data'] != null ? RecentRequestsData.fromJson(json['data']) : null,
    );
  }
}

class RecentRequestsData {
  final List<RequestItem>? requests;
  final RecentRequestsPagination? pagination;

  RecentRequestsData({this.requests, this.pagination});

  factory RecentRequestsData.fromJson(Map<String, dynamic> json) {
    return RecentRequestsData(
      requests: json['requests'] != null
          ? (json['requests'] as List).map((i) => RequestItem.fromJson(i)).toList()
          : [],
      pagination: json['pagination'] != null 
          ? RecentRequestsPagination.fromJson(json['pagination']) 
          : null,
    );
  }
}

class RequestItem {
  final String? id;
  final String? type;
  final String? status;
  final DateTime? createdAt;

  RequestItem({this.id, this.type, this.status, this.createdAt});

  factory RequestItem.fromJson(Map<String, dynamic> json) {
    return RequestItem(
      id: json['_id'],
      type: json['type'],
      status: json['status'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

class RecentRequestsPagination {
  final int? totalRecords;
  final int? currentPage;
  final int? totalPages;
  final int? limit;

  RecentRequestsPagination({this.totalRecords, this.currentPage, this.totalPages, this.limit});

  factory RecentRequestsPagination.fromJson(Map<String, dynamic> json) {
    return RecentRequestsPagination(
      limit: json['limit'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalRecords: json['totalRecords'],
    );
  }
}