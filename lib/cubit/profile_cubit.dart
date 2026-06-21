import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/helper/dio_helper.dart';
import 'package:graduation_app/cubit/profile_state.dart';
import 'package:graduation_app/models/user_model.dart';
import 'package:graduation_app/services/secure_storage.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitialState());

  final SecureStorage _storage = SecureStorage();
  static ProfileCubit get(context) => BlocProvider.of(context);

  UserModel? currentUserModel;

  Future<void> getUserProfile() async {
    emit(GetProfileLoadingState());

    final String? token = await _storage.getToken();
    if (token == null) {
      emit(GetProfileErrorState("Access token is missing. Please log in again."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/auth/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 'success') {
          currentUserModel = UserModel.fromJson(responseData);
          emit(GetProfileSuccessState(currentUserModel!));
        } else {
          emit(GetProfileErrorState("Failed to load user profile data."));
        }
      } else {
        emit(GetProfileErrorState("Server responded with error status code."));
      }
    } on DioException catch (e) {
      final errorData = e.response?.data['message'];
      String errorMessage = "An error occurred while fetching user data";

      if (errorData is List) {
        errorMessage = errorData.join(", ");
      } else if (errorData is String) {
        errorMessage = errorData;
      }
      emit(GetProfileErrorState(errorMessage));
    } catch (e) {
      emit(GetProfileErrorState(e.toString()));
    }
  }
}