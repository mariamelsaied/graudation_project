import 'package:flutter/material.dart'; 
import 'package:graduation_app/models/auth_model.dart'; 

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final LoginResponse loginResponse;
  AuthSuccess(this.loginResponse);
}

final class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}