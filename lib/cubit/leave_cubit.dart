import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:graduation_app/core/helper/dio_helper.dart';
import 'package:graduation_app/services/secure_storage.dart'; 
import '../models/leave_model.dart';
import 'leave_state.dart';

class LeaveCubit extends Cubit<LeaveState> {
  LeaveCubit() : super(LeaveInitialState());

  final SecureStorage _storage = SecureStorage();

  static LeaveCubit get(context) => BlocProvider.of(context);

  void getLeaves({
    required int page,
    required String status,
  }) async {
    emit(LeaveLoadingState());

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      emit(LeaveErrorState("Access token is required. Please log in."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/leaves/employee/me',
        queryParameters: {
          'status': status == 'All' ? null : status,
          'page': page,
          'limit': 5,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 ) {
        final leaveResponse = LeaveResponseModel.fromJson(response.data);
        emit(LeaveSuccessState(
          leaves: leaveResponse.leaves,
          pagination: leaveResponse.pagination,
        ));
      } else {
        emit(LeaveErrorState("Failed to load leave data"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(LeaveErrorState(errorMessage));
    } catch (e) {
      emit(LeaveErrorState(e.toString()));
    }
  }

  Future<void> submitLeaveApplication({
    required String type,
    required String startDate,
    required String endDate,
    required String reason,
    String? filePath,
  }) async {
    emit(LeaveSubmitLoadingState());
    
    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      Map<String, dynamic> requestData = {
        'type': type,
        'startDate': startDate,
        'endDate': endDate,
        'reason': reason,
      };

      if (filePath != null) {
        requestData['attachment'] = await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        );
      }

      FormData formData = FormData.fromMap(requestData);

      final response = await DioHelper.dio.post(
        '/api/leaves/create', 
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(LeaveSubmitSuccessState("Leave request submitted successfully"));
      } else {
        emit(LeaveSubmitErrorState("Failed to submit leave application"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(LeaveSubmitErrorState(errorMessage));
    } catch (e) {
      emit(LeaveSubmitErrorState(e.toString()));
    }
  }
  Future<void> updateLeaveApplication({
    required String id, 
    required String type,
    required String startDate,
    required String endDate,
    required String reason,
    String? filePath,
  }) async {
    emit(LeaveUpdateLoadingState()); 
    
    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      Map<String, dynamic> requestData = {
        'type': type,
        'startDate': startDate,
        'endDate': endDate,
        'reason': reason,
      };

   
      if (filePath != null && !filePath.startsWith('http') && !filePath.startsWith('assets')) {
        requestData['attachment'] = await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        );
      }

      FormData formData = FormData.fromMap(requestData);

      final response = await DioHelper.dio.patch(
        '/api/leaves/$id', 
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(LeaveUpdateSuccessState("Leave request updated successfully"));
      } else {
        emit(LeaveUpdateErrorState("Failed to update leave application"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(LeaveUpdateErrorState(errorMessage));
    } catch (e) {
      emit(LeaveUpdateErrorState(e.toString()));
    }
  }


  Future<void> deleteLeaveApplication({required String id}) async {
    emit(LeaveDeleteLoadingState()); 

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await DioHelper.dio.delete(
        '/api/leaves/$id', 
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(LeaveDeleteSuccessState("Leave request deleted successfully"));
      } else {
        emit(LeaveDeleteErrorState("Failed to delete leave application"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? e.response?.data.toString() ?? "";
      }

  
      if (errorMessage.contains("Notification is not defined")) {
        emit(LeaveDeleteSuccessState("Leave request deleted successfully"));
      } else {
        emit(LeaveDeleteErrorState(errorMessage.isEmpty ? e.message ?? "Error" : errorMessage));
      }
    } catch (e) {
      emit(LeaveDeleteErrorState(e.toString()));
    }
  }

  void getYearlyChart({required int year}) async {
    emit(LeaveChartLoadingState());

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      emit(LeaveChartErrorState("Access token is required. Please log in."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/leaves/stats/yearly/me',
        queryParameters: {
          'year': year,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final List<dynamic> chartList = response.data['data']['yearlyOverview'] ?? [];
        emit(LeaveChartSuccessState(chartData: chartList));
      } else {
        emit(LeaveChartErrorState("Failed to load chart data"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(LeaveChartErrorState(errorMessage));
    } catch (e) {
      emit(LeaveChartErrorState(e.toString()));
    }
  }


  void getLeaveBalance() async {
    emit(LeaveBalanceLoadingState());

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {
      'Content-Type': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      emit(LeaveBalanceErrorState("Access token is required. Please log in."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/leaves/my-balance',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> balance = response.data['data'] ?? {};
        emit(LeaveBalanceSuccessState(balanceData: balance));
      } else {
        emit(LeaveBalanceErrorState("Failed to load leave balance"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(LeaveBalanceErrorState(errorMessage));
    } catch (e) {
      emit(LeaveBalanceErrorState(e.toString()));
    }
  }
}