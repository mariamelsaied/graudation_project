// 1. كلاس الاستجابة الرئيسي
class LeaveResponseModel {
  final List<LeaveModel> leaves;
  final PaginationLeave pagination;

  LeaveResponseModel({required this.leaves, required this.pagination});

  factory LeaveResponseModel.fromJson(Map<String, dynamic> json) {
    return LeaveResponseModel(
      leaves: json['data'] != null 
          ? (json['data'] as List).map((i) => LeaveModel.fromJson(i)).toList()
          : [],
      pagination: PaginationLeave.fromJson(json['pagination'] ?? {}),
    );
  }
}

class LeaveModel {
  final String id;
  final String type;
  final String startDate;
  final String endDate;
  final int duration;
  final String status;
  final String reason;
  final String? attachment; 

  LeaveModel({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.status,
    required this.reason,
    this.attachment, 
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      duration: json['duration'] ?? 1,
      status: json['status'] ?? 'Pending',
      reason: json['reason'] ?? '',
      attachment: json['attachment'], 
    );
  }
}
class PaginationLeave {
  final int currentPage;
  final int totalPages;
  final int totalRecords; 

  PaginationLeave({
    required this.currentPage, 
    required this.totalPages, 
    required this.totalRecords,
  });

  factory PaginationLeave.fromJson(Map<String, dynamic> json) {
    return PaginationLeave(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalRecords: json['totalRecords'] ?? 0, 
    );
  }
}

// class HrAdminModel {
//   String? sId;
//   String? firstName;
//   String? lastName;

//   HrAdminModel({this.sId, this.firstName, this.lastName});

//   HrAdminModel.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     firstName = json['firstName'];
//     lastName = json['lastName'];
//   }
// }
