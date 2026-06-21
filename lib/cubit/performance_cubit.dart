import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:graduation_app/core/helper/dio_helper.dart';
import 'package:graduation_app/cubit/performance_state.dart';
import 'package:graduation_app/models/performance_model.dart';
import 'package:graduation_app/services/secure_storage.dart'; 


class EmployeePerformanceCubit extends Cubit<EmployeePerformanceState> {
  EmployeePerformanceCubit() : super(EmployeePerformanceInitialState());

  final SecureStorage _storage = SecureStorage();

  static EmployeePerformanceCubit get(context) => BlocProvider.of(context);


  void getEmployeePerformance() async {
    emit(EmployeePerformanceLoadingState());

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      emit(EmployeePerformanceErrorState("Access token is required. Please log in."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/employeePerformance/',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final performanceResponse = EmployeePerformanceModel.fromJson(response.data);
        emit(EmployeePerformanceSuccessState(performanceModel: performanceResponse));
      } else {
        emit(EmployeePerformanceErrorState("Failed to load performance data"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        if (e.response?.data is Map && e.response?.data['message'] != null) {
          errorMessage = e.response?.data['message'];
        } else {
          errorMessage = e.response?.data.toString() ?? errorMessage;
        }
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(EmployeePerformanceErrorState(errorMessage));
    } catch (e) {
      emit(EmployeePerformanceErrorState(e.toString()));
    }
  }
}