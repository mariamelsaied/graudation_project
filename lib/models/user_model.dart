class UserModel {
  final String status;
  final UserData? data;

  UserModel({required this.status, this.data});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'] ?? '',
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final UserDetails? user;

  UserData({this.user});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: json['user'] != null ? UserDetails.fromJson(json['user']) : null,
    );
  }
}

class UserDetails {
  final String id;
  final GeneralInfo general;
  final ExperienceInfo? experience;
  final EmployeeInfo? employee;
  final String createdAt;
  final String updatedAt;

  UserDetails({
    required this.id,
    required this.general,
    this.experience,
    this.employee,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['_id'] ?? '',
      general: GeneralInfo.fromJson(json['general'] ?? {}),
      experience: json['experience'] != null ? ExperienceInfo.fromJson(json['experience']) : null,
      employee: json['employee'] != null ? EmployeeInfo.fromJson(json['employee']) : null,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

class GeneralInfo {
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String rfidTag;
  final String phone;
  final String gender;
  final String address;
  final String avatar;

  GeneralInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.rfidTag,
    required this.phone,
    required this.gender,
    required this.address,
    required this.avatar,
  });

  factory GeneralInfo.fromJson(Map<String, dynamic> json) {
    return GeneralInfo(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      rfidTag: json['rfidTag'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}

class ExperienceInfo {
  final String company;
  final String position;
  final String jobType;
  final int baseSalary;
  final String startDate;
  final String endDate;

  ExperienceInfo({
    required this.company,
    required this.position,
    required this.jobType,
    required this.baseSalary,
    required this.startDate,
    required this.endDate,
  });

  factory ExperienceInfo.fromJson(Map<String, dynamic> json) {
    return ExperienceInfo(
      company: json['company'] ?? '',
      position: json['position'] ?? '',
      jobType: json['jobType'] ?? '',
      baseSalary: json['baseSalary'] ?? 0,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }
}

class EmployeeInfo {
  final LeaveBalance leaveBalance;
  final String jobTitle;
  final String department;
  final String workLocation;
  final String jobType;
  final String joiningDate;
  final int baseSalary;
  final String status;
  final int workingHours;

  EmployeeInfo({
    required this.leaveBalance,
    required this.jobTitle,
    required this.department,
    required this.workLocation,
    required this.jobType,
    required this.joiningDate,
    required this.baseSalary,
    required this.status,
    required this.workingHours,
  });

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      leaveBalance: LeaveBalance.fromJson(json['leaveBalance'] ?? {}),
      jobTitle: json['jobTitle'] ?? '',
      department: json['department'] ?? '',
      workLocation: json['workLocation'] ?? '',
      jobType: json['jobType'] ?? '',
      joiningDate: json['joiningDate'] ?? '',
      baseSalary: json['baseSalary'] ?? 0,
      status: json['status'] ?? '',
      workingHours: json['workingHours'] ?? 0,
    );
  }
}

class LeaveBalance {
  final int annual;
  final int sick;
  final int casual;

  LeaveBalance({required this.annual, required this.sick, required this.casual});

  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      annual: json['annual'] ?? 0,
      sick: json['sick'] ?? 0,
      casual: json['casual'] ?? 0,
    );
  }
}