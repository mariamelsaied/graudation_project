class RequestModel {
  final String? id;
  final String? employeeId;
  final String? type;
  final String? title;
  final String? description;
  final String? status;
  final String? priority;
  final String? createdAt;
  final String? updatedAt;
  final HrResponseModel? hrResponse;

  RequestModel({
    this.id,
    this.employeeId,
    this.type,
    this.title,
    this.description,
    this.status,
    this.priority,
    this.createdAt,
    this.updatedAt,
    this.hrResponse,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['_id'] as String?,
      employeeId: json['employeeId'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      priority: json['priority'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      hrResponse: json['hrResponse'] != null 
          ? HrResponseModel.fromJson(json['hrResponse'] as Map<String, dynamic>) 
          : null,
    );
  }
}

class HrResponseModel {
  final String? text;
  final List<dynamic>? attachments;

  HrResponseModel({this.text, this.attachments});

  factory HrResponseModel.fromJson(Map<String, dynamic> json) {
    return HrResponseModel(
      text: json['text'] as String?,
      attachments: json['attachments'] as List<dynamic>?,
    );
  }
}

class RequestStatsModel {
  final int total;
  final int approved;
  final int pending;
  final int rejected;

  RequestStatsModel({
    required this.total,
    required this.approved,
    required this.pending,
    required this.rejected,
  });

  factory RequestStatsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    
    return RequestStatsModel(
      total: int.tryParse(data['totalRequests']?.toString() ?? '0') ?? 0,
      approved: int.tryParse(data['approvedCount']?.toString() ?? '0') ?? 0,
      pending: int.tryParse(data['pendingCount']?.toString() ?? '0') ?? 0,
      rejected: int.tryParse(data['rejectedCount']?.toString() ?? '0') ?? 0,
    );
  }
}