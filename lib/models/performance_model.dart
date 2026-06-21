class EmployeePerformanceModel {
  final String status;
  final PerformanceData data;

  EmployeePerformanceModel({required this.status, required this.data});

  factory EmployeePerformanceModel.fromJson(Map<String, dynamic> json) {
    return EmployeePerformanceModel(
      status: json['status'] ?? '',
      data: PerformanceData.fromJson(json['data'] ?? {}),
    );
  }
}

class PerformanceData {
  final Period currentPeriod;
  final Kpis kpis;
  final num overallPerformance;
  final String performanceStatus;
  final num percentageChange;
  final List<PreviousPeriod> previousPeriods;

  PerformanceData({
    required this.currentPeriod,
    required this.kpis,
    required this.overallPerformance,
    required this.performanceStatus,
    required this.percentageChange,
    required this.previousPeriods,
  });

  factory PerformanceData.fromJson(Map<String, dynamic> json) {
    var list = json['previousPeriods'] as List?;
    List<PreviousPeriod> previousList = list != null
        ? list.map((i) => PreviousPeriod.fromJson(i)).toList()
        : [];

    return PerformanceData(
      currentPeriod: Period.fromJson(json['currentPeriod'] ?? {}),
      kpis: Kpis.fromJson(json['kpis'] ?? {}),
      overallPerformance: json['overallPerformance'] ?? 0,
      performanceStatus: json['performanceStatus'] ?? '',
      percentageChange: json['percentageChange'] ?? 0,
      previousPeriods: previousList,
    );
  }
}

class Period {
  final String from;
  final String to;

  Period({required this.from, required this.to});

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      from: json['from'] ?? '',
      to: json['to'] ?? '',
    );
  }
}

class Kpis {
  final num attendanceScore;
  final num taskScore;

  Kpis({required this.attendanceScore, required this.taskScore});

  factory Kpis.fromJson(Map<String, dynamic> json) {
    return Kpis(
      attendanceScore: json['attendanceScore'] ?? 0,
      taskScore: json['taskScore'] ?? 0,
    );
  }
}

class PreviousPeriod {
  final String from;
  final String to;
  final num overallPerformance;
  final String performanceStatus;
  final num percentageChange;

  PreviousPeriod({
    required this.from,
    required this.to,
    required this.overallPerformance,
    required this.performanceStatus,
    required this.percentageChange,
  });

  factory PreviousPeriod.fromJson(Map<String, dynamic> json) {
    return PreviousPeriod(
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      overallPerformance: json['overallPerformance'] ?? 0,
      performanceStatus: json['performanceStatus'] ?? '',
      percentageChange: json['percentageChange'] ?? 0,
    );
  }
}