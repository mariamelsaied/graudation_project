class PaginationInfo {
  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int limit;

  PaginationInfo({
    required this.totalRecords,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      totalRecords: json['totalRecords'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
      currentPage: json['currentPage'] ?? 1,
      limit: json['limit'] ?? 5,
    );
  }
}

class PayrollModel {
  final String id;
  final int month;
  final int year;
  final int baseSalary;
  final int netSalary;
  final int deductions;
  final int daysPresent;
  final int daysAbsent;
  final String status;

  PayrollModel({
    required this.id,
    required this.month,
    required this.year,
    required this.baseSalary,
    required this.netSalary,
    required this.deductions,
    required this.daysPresent,
    required this.daysAbsent,
    required this.status,
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json['_id'] ?? '',
      month: json['month'] ?? 0,
      year: json['year'] ?? 0,
      baseSalary: json['baseSalary'] ?? 0,
      netSalary: json['netSalary'] ?? 0,
      deductions: json['deductions'] ?? 0,
      daysPresent: json['daysPresent'] ?? 0,
      daysAbsent: json['daysAbsent'] ?? 0,
      status: json['status'] ?? 'Pending',
    );
  }
}

class PayrollResponse {
  final List<PayrollModel> payrolls;
  final PaginationInfo pagination;

  PayrollResponse({required this.payrolls, required this.pagination});

  factory PayrollResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return PayrollResponse(
      payrolls: (data['payrolls'] as List)
          .map((e) => PayrollModel.fromJson(e))
          .toList(),
      pagination: PaginationInfo.fromJson(json['pagination']),
    );
  }
}