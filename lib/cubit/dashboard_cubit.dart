import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dio/dio';
import 'package:graduation_app/core/helper/dio_helper.dart';
import 'package:graduation_app/services/secure_storage.dart';
import 'package:graduation_app/cubit/dashboard_states.dart';
import 'package:graduation_app/models/dashboard_stats_model.dart';

class DashboardCubit extends Cubit<DashboardStates> {
  DashboardCubit() : super(DashboardInitialState());

  final SecureStorage _storage = SecureStorage();
  static DashboardCubit get(context) => BlocProvider.of(context);

  DashboardStatsModel? statsModel;

  List<WeeklyStatsItem> weeklyAttendanceList = [];

  List<ProjectItem> myProjectsList = [];

  List<RequestItem> recentRequestsList = [];


  void getDashboardStats() async {
    emit(DashboardLoadingState());
    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {};
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      emit(DashboardErrorState("Access token is required. Please log in."));
      return;
    }

    try {
      FormData formData = FormData.fromMap({'acceptance': 'accept'});
      final response = await DioHelper.dio.get(
        '/api/employeeDashboard/dashboard-stats',
        data: formData, 
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
    
        statsModel = DashboardStatsModel.fromJson(response.data);
        emit(DashboardSuccessState(statsModel!));
      } else {
        emit(DashboardErrorState("Failed to load dashboard statistics"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(DashboardErrorState(errorMessage));
    } catch (e) {
      emit(DashboardErrorState(e.toString()));
    }
  }


  void getWeeklyAttendanceStats() async {
    emit(WeeklyStatsLoadingState());

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {};
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      emit(WeeklyStatsErrorState("Access token is required. Please log in."));
      return;
    }

    const int targetDay = 25;
    const int targetMonth = 3;
    const int targetYear = 2026;

    try {
      final response = await DioHelper.dio.get(
        '/api/employeeDashboard/stats/weekly/me', 
        queryParameters: {
          'day': targetDay,
          'month': targetMonth,
          'year': targetYear,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final weeklyModel = WeeklyAttendanceModel.fromJson(response.data);
        weeklyAttendanceList = weeklyModel.weeklyAttendanceStats ?? [];
        emit(WeeklyStatsSuccessState(weeklyAttendanceList));
      } else {
        emit(WeeklyStatsErrorState("Failed to load weekly statistics"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(WeeklyStatsErrorState(errorMessage));
    } catch (e) {
      emit(WeeklyStatsErrorState(e.toString()));
    }
  }

  void getMyProjects() async {
    emit(MyProjectsLoadingState());

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {};
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      emit(MyProjectsErrorState("Access token is required. Please log in."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/employeeDashboard/my-projects',
        queryParameters: {
          'page': 1,
          'limit': 5,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final projectsModel = MyProjectsModel.fromJson(response.data);
        myProjectsList = projectsModel.data?.projects ?? [];
        emit(MyProjectsSuccessState(myProjectsList));
      } else {
        emit(MyProjectsErrorState("Failed to load projects"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(MyProjectsErrorState(errorMessage));
    } catch (e) {
      emit(MyProjectsErrorState(e.toString()));
    }
  }


  void getRecentRequests() async {
    emit(RecentRequestsLoadingState());

    final String? token = await _storage.getToken();
    final Map<String, dynamic> headers = {};
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    } else {
      emit(RecentRequestsErrorState("Access token is required. Please log in."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/employeeDashboard/recent-requests',
        queryParameters: {
          'page': 1,
          'limit': 5,
        },
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final recentRequestsModel = RecentRequestsModel.fromJson(response.data);
        recentRequestsList = recentRequestsModel.data?.requests ?? [];
        emit(RecentRequestsSuccessState(recentRequestsList));
      } else {
        emit(RecentRequestsErrorState("Failed to load recent requests"));
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else {
        errorMessage = e.message ?? errorMessage;
      }
      emit(RecentRequestsErrorState(errorMessage));
    } catch (e) {
      emit(RecentRequestsErrorState(e.toString()));
    }
  }
}