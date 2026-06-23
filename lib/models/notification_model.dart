class NotificationResponse {
  final String status;
  final List<NotificationItem> notifications;
  final Pagination? pagination;
  final int unreadCount;

  NotificationResponse({
    required this.status,
    required this.notifications,
    this.pagination,
    required this.unreadCount,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      status: json['status'] ?? '',
      notifications: (json['data']['notifications'] as List? ?? [])
          .map((i) => NotificationItem.fromJson(i))
          .toList(),
      pagination: json['pagination'] != null 
          ? Pagination.fromJson(json['pagination']) 
          : null,
      unreadCount: json['data']['unreadCount'] ?? 0, 
    );
  }
}

class NotificationItem {
  final String id;
  final Sender? sender;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String relatedId;
  final DateTime? createdAt;

  NotificationItem({
    required this.id,
    this.sender,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.relatedId,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'] ?? '',
      sender: json['sender'] != null ? Sender.fromJson(json['sender']) : null,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      isRead: json['isRead'] ?? false,
      relatedId: json['relatedId'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }
}

class Sender {
  final String id;
  final String firstName;
  final String lastName;
  final String avatar;

  Sender({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    final general = json['general'] ?? {};
    return Sender(
      id: json['_id'] ?? '',
      firstName: general['firstName'] ?? '',
      lastName: general['lastName'] ?? '',
      avatar: general['avatar'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}

class Pagination {
  final int totalRecords;
  final int totalPages;
  final int currentPage;
  final int limit;

  Pagination({
    required this.totalRecords,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalRecords: json['totalRecords'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }
}