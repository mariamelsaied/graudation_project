import 'package:graduation_app/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class GetProfileLoadingState extends ProfileState {}

class GetProfileSuccessState extends ProfileState {
  final UserModel userModel;
  GetProfileSuccessState(this.userModel);
}

class GetProfileErrorState extends ProfileState {
  final String errorMessage;
  GetProfileErrorState(this.errorMessage);
}