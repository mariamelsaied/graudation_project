import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/cubit/auth_state.dart';
import 'package:graduation_app/models/auth_model.dart';
import 'package:graduation_app/services/auth_services.dart';
import 'package:graduation_app/services/secure_storage.dart';

class LoginCubit extends Cubit<AuthState> {
  final AuthService authService = AuthService();
  final SecureStorage storage = SecureStorage();

  LoginCubit() : super(AuthInitial());
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final response = await authService.login(
        email: email,
        password: password,
      );

      if (response.status == "success") {
        final String? userRole = response.data?.user?.general?.role;
        if (userRole?.toUpperCase() == "HR") {
          emit(
            AuthFailure("This app is for employees only. HR access is denied."),
          );
          return;
        }

        if (userRole?.toUpperCase() == "EMPLOYEE") {
          if (response.data?.accessToken != null) {
            await storage.saveToken(response.data!.accessToken!);

            final String? firstName = response.data?.user?.general?.firstName;
            final String? avatarUrl = response.data?.user?.general?.avatar; 

            debugPrint("Attempting to save firstName: $firstName, avatar: $avatarUrl");

            if (firstName != null && firstName.isNotEmpty) {
              await storage.write(key: "user_name", value: firstName);
              debugPrint("Name saved successfully!");
            } else {
              debugPrint("Warning: firstName is null or empty in server response");
            }

            if (avatarUrl != null && avatarUrl.isNotEmpty) {
              await storage.write(key: "user_image", value: avatarUrl);
              debugPrint("Avatar URL saved successfully!");
            } else {
              await storage.delete(key: "user_image");
              debugPrint("Warning: avatar is null or empty, clearing previous reference.");
            }
          }
          emit(AuthSuccess(response));
        } else {
          emit(AuthFailure("Unauthorized access."));
        }
      } else {
        emit(AuthFailure(response.message ?? "Invalid email or password"));
      }
    } catch (e) {
      emit(AuthFailure("Connection error or server issues"));
    }
  }

  Future<void> checkAutoLogin() async {
    final token = await storage.getToken();
    final name = await storage.read(key: "user_name");
    final image = await storage.read(key: "user_image"); 

    if (token != null) {
      final mockJson = {
        "status": "success",
        "message": "Auto Login",
        "data": {
          "accessToken": token,
          "user": {
            "general": {
              "firstName": name ?? "Employee", 
              "avatar": image, 
              "role": "EMPLOYEE"
            },
          },
        },
      };
      emit(AuthSuccess(LoginResponse.fromJson(mockJson)));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> logout() async {
    await storage.deleteToken();
    await storage.delete(key: "user_name");
    await storage.delete(key: "user_image"); 
    emit(AuthInitial());
  }
}