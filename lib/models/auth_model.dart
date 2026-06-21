class LoginResponse {
  final String? status;
  final String? message;
  final LoginData? data;

  LoginResponse({this.status, this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }
}

class LoginData {
  final String? accessToken;
  final String? refreshToken;
  final UserModel? user;

  LoginData({this.accessToken, this.refreshToken, this.user});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}

class UserModel {
  final String? id;
  final General? general;

  UserModel({this.id, this.general});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String?,
      general: json['general'] != null ? General.fromJson(json['general']) : null,
    );
  }
}

class General {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? role;
  final String? avatar; 

  General({
    this.firstName,
    this.lastName,
    this.email,
    this.role,
    this.avatar,
  });

  factory General.fromJson(Map<String, dynamic> json) {
    return General(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      avatar: json['avatar'] as String?, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'avatar': avatar,
    };
  }
}