import 'package:flutter/material.dart';

@immutable
sealed class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}


final class ForgetPasswordLoading extends ForgetPasswordState {}

final class ForgetPasswordEmailSent extends ForgetPasswordState {}

final class ForgetPasswordOtpVerified extends ForgetPasswordState {}


final class ForgetPasswordResetSuccess extends ForgetPasswordState {}

final class ForgetPasswordFailure extends ForgetPasswordState {
  final String errorMessage;
  ForgetPasswordFailure(this.errorMessage);
}