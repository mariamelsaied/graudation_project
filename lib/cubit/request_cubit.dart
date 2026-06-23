import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/helper/dio_helper.dart';
import 'package:graduation_app/cubit/request_state.dart';
import 'package:graduation_app/models/request_model.dart';
import 'package:graduation_app/services/secure_storage.dart';

class RequestCubit extends Cubit<RequestState> {
  RequestCubit() : super(RequestInitialState());

  final SecureStorage _storage = SecureStorage();
  static RequestCubit get(context) => BlocProvider.of(context);

  RequestStatsModel? monthlyStats;
  List<RequestModel> requests = []; 

  Future<void> createRequest({
    required String type,
    required String title,
    required String description,
    required String priority,
    String? filePath,
  }) async {
    emit(CreateRequestLoadingState());

    final String? token = await _storage.getToken();
    if (token == null) {
      emit(CreateRequestErrorState("Access token is required."));
      return;
    }

    try {
      Map<String, dynamic> requestData = {
        "type": type,
        "title": title,
        "description": description,
        "priority": priority,
      };

      if (filePath != null && filePath.isNotEmpty) {
        requestData['attachment'] = await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        );
      }

      final response = await DioHelper.dio.post(
        '/api/requests/create',
        data: FormData.fromMap(requestData),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final request = RequestModel.fromJson(response.data['data']['request']);
        
        requests.insert(0, request); 
        
        emit(CreateRequestSuccessState(request: request)); 
        emit(GetRequestsSuccessState(List.from(requests))); 
      }
    } on DioException catch (e) {
      final errorData = e.response?.data['message'];
      String errorMessage = "Error occurred";

      if (errorData is List) {
        errorMessage = errorData.join(", ");
      } else if (errorData is String) {
        errorMessage = errorData;
      }

      emit(CreateRequestErrorState(errorMessage));
    }
  }

  Future<void> getAllRequests({int page = 1, int limit = 10}) async {
    emit(GetRequestsLoadingState());

    final String? token = await _storage.getToken();
    
    try {
      final response = await DioHelper.dio.get(
        '/api/requests/history/me',
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']?['requests'] ?? [];
        
        requests = data.map((item) => RequestModel.fromJson(item)).toList();
        emit(GetRequestsSuccessState(List.from(requests)));
      } else {
        emit(GetRequestsErrorState("Failed to load request history"));
      }
    } on DioException catch (e) {
      final errorData = e.response?.data['message'];
      String errorMessage = "Error fetching data";

      if (errorData is List) {
        errorMessage = errorData.join(", ");
      } else if (errorData is String) {
        errorMessage = errorData;
      }

      emit(GetRequestsErrorState(errorMessage));
    }
  }

  Future<void> updateRequest({
    required String requestId,
    required String type,
    required String title,
    required String description,
    required String priority,
    dynamic attachmentFile, 
  }) async {
    emit(UpdateRequestLoadingState());

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final Map<String, dynamic> formDataMap = {
        'type': type,         
        'title': title,
        'description': description,
        'priority': priority, 
      };

      if (attachmentFile != null) {
        formDataMap['attachment'] = await MultipartFile.fromFile(
          attachmentFile.path,
          filename: attachmentFile.path.split('/').last,
        );
      }

      FormData formData = FormData.fromMap(formDataMap);

      final response = await DioHelper.dio.patch(
        '/api/requests/$requestId',
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic>? requestData = response.data['data']?['request'];
        RequestModel updatedRequest;

        if (requestData != null) {
          updatedRequest = RequestModel.fromJson(requestData);
        } else {
          updatedRequest = RequestModel.fromJson(response.data['data']);
        }

        final index = requests.indexWhere((element) => element.id == requestId);
        if (index != -1) {
          requests[index] = updatedRequest;
        }

        emit(UpdateRequestSuccessState(updatedRequest));
        emit(GetRequestsSuccessState(List.from(requests))); 
      } else {
        emit(UpdateRequestErrorState("Failed to update request"));
      }
    } on DioException catch (e) {
      final errorData = e.response?.data['message'];
      String errorMessage = "Error updating request";

      if (errorData is List) {
        errorMessage = errorData.join(", ");
      } else if (errorData is String) {
        errorMessage = errorData;
      }

      emit(UpdateRequestErrorState(errorMessage));
    } catch (e) {
      emit(UpdateRequestErrorState(e.toString()));
    }
  }

  Future<void> deleteRequest(String requestId) async {
    emit(DeleteRequestLoadingState());

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await DioHelper.dio.delete(
        '/api/requests/$requestId',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        requests.removeWhere((element) => element.id == requestId);

        emit(DeleteRequestSuccessState());
        emit(GetRequestsSuccessState(List.from(requests))); 
      } else {
        emit(DeleteRequestErrorState("Failed to delete request"));
      }
    } on DioException catch (e) {
      final errorData = e.response?.data['message'];
      String errorMessage = "Error deleting request";

      if (errorData is List) {
        errorMessage = errorData.join(", ");
      } else if (errorData is String) {
        errorMessage = errorData;
      }

      emit(DeleteRequestErrorState(errorMessage));
    } catch (e) {
      emit(DeleteRequestErrorState(e.toString()));
    }
  }

  // 🛠️ تحديث جلب الإحصائيات لتقبل الـ month والـ year ديناميكياً بناءً على التقويم المختار
  Future<void> getMonthlyStats({int? month, int? year}) async {
    emit(GetRequestStatsLoadingState());

    final String? token = await _storage.getToken();
    
    final now = DateTime.now();
    final int targetMonth = month ?? now.month;
    final int targetYear = year ?? now.year;

    try {
      final response = await DioHelper.dio.get(
        '/api/requests/monthly-stats/me',
        queryParameters: {
          'month': targetMonth,
          'year': targetYear,
        },
        options: Options(headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        monthlyStats = RequestStatsModel.fromJson(response.data);
        emit(GetRequestStatsSuccessState(monthlyStats!));
      } else {
        emit(GetRequestStatsErrorState("Failed to load statistics"));
      }
    } on DioException catch (e) {
      final errorData = e.response?.data['message'];
      String errorMessage = "Error fetching stats";

      if (errorData is List) {
        errorMessage = errorData.join(", ");
      } else if (errorData is String) {
        errorMessage = errorData;
      }

      emit(GetRequestStatsErrorState(errorMessage));
    } catch (e) {
      emit(GetRequestStatsErrorState(e.toString()));
    }
  }
}