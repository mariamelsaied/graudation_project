class ForgetPasswordResponse {
  final String? status;
  final String? message;

  ForgetPasswordResponse({this.status, this.message});

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}