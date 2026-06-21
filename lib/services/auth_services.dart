import 'package:graduation_app/core/helper/dio_helper.dart';
import 'package:graduation_app/models/auth_model.dart';
import 'package:graduation_app/models/forget_password_model.dart';

class AuthService {
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioHelper.postData(
        url: '/api/auth/login',
        data: {'email': email, 'password': password},
      );
      print("Full Server Response: ${response.data}");
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
  Future<ForgetPasswordResponse> sendOtp(String email) async {
    final response = await DioHelper.postData(
      url: '/api/auth/forget-Password',
      data: {'email': email},
    );
    return ForgetPasswordResponse.fromJson(response.data);
  }
  Future<ForgetPasswordResponse> verifyOtp(String email, String otp) async {
    final response = await DioHelper.postData(
      url: '/api/auth/verify-reset-code',
      data: {'email': email, 'resetCode': otp},
    );
    return ForgetPasswordResponse.fromJson(response.data);
  }
  Future<ForgetPasswordResponse> resetPassword(
    String email,
    String password,
  ) async {
    final response = await DioHelper.postData(
      url: '/api/auth/reset-password',
      data: {'email': email, 'newPassword': password},
    );
    return ForgetPasswordResponse.fromJson(response.data);
  }
}
