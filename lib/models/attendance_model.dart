class AttendanceResponse {
  final String status;
  final AttendanceStats data;

  AttendanceResponse({required this.status, required this.data});

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      status: json['status'] ?? '',
      data: AttendanceStats.fromJson(json['data'] ?? {}),
    );
  }
}

class AttendanceStats {
  final int totalAttendanceRecords;
  final int totalOnTimeCount;
  final int totalLateCount;
  final int totalAbsentCount;
  final int totalDelayMinutes;
  final int attendanceRate;

  AttendanceStats({
    required this.totalAttendanceRecords,
    required this.totalOnTimeCount,
    required this.totalLateCount,
    required this.totalAbsentCount,
    required this.totalDelayMinutes,
    required this.attendanceRate,
  });

  factory AttendanceStats.fromJson(Map<String, dynamic> json) {
    return AttendanceStats(
      totalAttendanceRecords: json['totalAttendanceRecords'] ?? 0,
      totalOnTimeCount: json['totalOnTimeCount'] ?? 0,
      totalLateCount: json['totalLateCount'] ?? 0,
      totalAbsentCount: json['totalAbsentCount'] ?? 0,
      totalDelayMinutes: json['totalDelayMinutes'] ?? 0,
      attendanceRate: json['attendanceRate'] ?? 0,
    );
  }
}

class SixMonthsAttendanceResponse {
  final String status;
  final SixMonthsData data;

  SixMonthsAttendanceResponse({required this.status, required this.data});

  factory SixMonthsAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return SixMonthsAttendanceResponse(
      status: json['status'] ?? '',
      data: SixMonthsData.fromJson(json['data'] ?? {}),
    );
  }
}

class SixMonthsData {
  final OverallStats overallStats;
  final List<MonthlyStatItem> monthlyStats;

  SixMonthsData({required this.overallStats, required this.monthlyStats});

  factory SixMonthsData.fromJson(Map<String, dynamic> json) {
    var overallJson = json['overallStats'];
    Map<String, dynamic> finalOverallMap = {};
    
    if (overallJson is List && overallJson.isNotEmpty) {
      finalOverallMap = overallJson.first as Map<String, dynamic>;
    } else if (overallJson is Map<String, dynamic>) {
      finalOverallMap = overallJson;
    }

    return SixMonthsData(
      overallStats: OverallStats.fromJson(finalOverallMap),
      monthlyStats: (json['monthlyStats'] as List? ?? [])
          .map((item) => MonthlyStatItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class OverallStats {
  final int totalOnTime;
  final int totalLate;
  final int totalAbsent;

  OverallStats({
    required this.totalOnTime,
    required this.totalLate,
    required this.totalAbsent,
  });

  factory OverallStats.fromJson(Map<String, dynamic> json) {
    return OverallStats(
      totalOnTime: json['totalOnTime'] ?? json['totalOnTimeCount'] ?? 0,
      totalLate: json['totalLate'] ?? json['totalLateCount'] ?? 0,
      totalAbsent: json['totalAbsent'] ?? json['totalAbsentCount'] ?? 0,
    );
  }
}

class MonthlyStatItem {
  final int totalOnTime;
  final int totalLate;
  final int totalAbsent;
  final int year;
  final int month;
  final String monthName;

  MonthlyStatItem({
    required this.totalOnTime,
    required this.totalLate,
    required this.totalAbsent,
    required this.year,
    required this.month,
    required this.monthName,
  });

  factory MonthlyStatItem.fromJson(Map<String, dynamic> json) {
    return MonthlyStatItem(
      totalOnTime: json['totalOnTime'] ?? 0,
      totalLate: json['totalLate'] ?? 0,
      totalAbsent: json['totalAbsent'] ?? 0,
      year: json['year'] ?? 0,
      month: json['month'] ?? 0,
      monthName: json['monthName'] ?? '',
    );
  }
}
class AttendanceLogResponse {
  final String status;
  final List<AttendanceRecord> attendance;
  final Pagination pagination;

  AttendanceLogResponse({required this.status, required this.attendance, required this.pagination});

  factory AttendanceLogResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceLogResponse(
      status: json['status'] ?? '',
      attendance: (json['data']?['attendance'] as List? ?? [])
          .map((item) => AttendanceRecord.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class AttendanceRecord {
  final String date;
  final String status;
  final String checkIn;

  AttendanceRecord({required this.date, required this.status, required this.checkIn});

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      checkIn: json['checkIn'] ?? '',
    );
  }
}

class Pagination {
  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int limit;

  Pagination({required this.totalRecords, required this.totalPages, required this.currentPage, required this.limit});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalRecords: json['totalRecords'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      limit: json['limit'] ?? 0,
    );
  }
}