import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/cubit/forget_password_state.dart';
import 'package:graduation_app/services/auth_services.dart'; 

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthService authService = AuthService();

  ForgetPasswordCubit() : super(ForgetPasswordInitial());
  Future<void> sendOtp(String email) async {
    emit(ForgetPasswordLoading());
    try {
      final response = await authService.sendOtp(email);
      if (response.status == "success") {
        emit(ForgetPasswordEmailSent());
      } else {
        emit(ForgetPasswordFailure(response.message ?? "حدث خطأ ما"));
      }
    } catch (e) {
      emit(ForgetPasswordFailure("خطأ في الاتصال بالسيرفر"));
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(ForgetPasswordLoading());
    try {
      final response = await authService.verifyOtp(email, otp);
      if (response.status == "success") {
        emit(ForgetPasswordOtpVerified());
      } else {
        emit(ForgetPasswordFailure(response.message ?? "الكود غير صحيح"));
      }
    } catch (e) {
      emit(ForgetPasswordFailure("فشل التحقق من الكود"));
    }
  }
  Future<void> resetPassword(String email, String newPassword) async {
    emit(ForgetPasswordLoading());
    try {
      final response = await authService.resetPassword(email, newPassword);
      if (response.status == "success") {
        emit(ForgetPasswordResetSuccess());
      } else {
        emit(ForgetPasswordFailure(response.message ?? "فشل تغيير كلمة المرور"));
      }
    } catch (e) {
      emit(ForgetPasswordFailure("حدث خطأ أثناء إعادة التعيين"));
    }
  }
}