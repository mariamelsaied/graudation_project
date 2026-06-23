import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/helper/dio_helper.dart';
import 'package:graduation_app/cubit/attendance_state.dart';
import 'package:graduation_app/models/attendance_model.dart'; 
import 'package:graduation_app/services/secure_storage.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitialState());

  final SecureStorage _storage = SecureStorage();
  
  AttendanceStats? currentStats; 
  SixMonthsData? currentSixMonthsData; 
  List<AttendanceRecord>? attendanceLogs;
  Pagination? pagination;

  static AttendanceCubit get(context) => BlocProvider.of(context);

  void getMonthlyStats({required int month, required int year}) async {
    // نطلق حالة الـ Loading دائماً عند طلب شهر جديد لتحديث الكروت في الـ UI
    emit(AttendanceLoadingState());

    final String? token = await _storage.getToken();
    try {
      final response = await DioHelper.dio.get(
        '/api/attendance/stats/monthly/me',
        queryParameters: {'month': month, 'year': year},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final attendanceResponse = AttendanceResponse.fromJson(response.data);
        currentStats = attendanceResponse.data;
        
        emit(AttendanceSuccessState(
          stats: currentStats, 
          sixMonthsData: currentSixMonthsData,
          attendanceLogs: attendanceLogs,
          pagination: pagination
        ));
      }
    } catch (e) {
      emit(AttendanceErrorState(e.toString()));
    }
  }

  void getSixMonthsStats({required int month, required int year}) async {
    final String? token = await _storage.getToken();
    try {
      final response = await DioHelper.dio.get(
        '/api/attendance/stats-six-months/me',
        queryParameters: {'month': month, 'year': year},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final res = SixMonthsAttendanceResponse.fromJson(response.data);
        currentSixMonthsData = res.data;
        
        emit(AttendanceSuccessState(
          stats: currentStats, 
          sixMonthsData: currentSixMonthsData,
          attendanceLogs: attendanceLogs,
          pagination: pagination
        ));
      }
    } catch (e) {
      print("❌ ERROR (Chart): $e");
    }
  }

  Future<void> getAttendanceLogs({int page = 1, int limit = 10}) async {
    final String? token = await _storage.getToken();
    try {
      final response = await DioHelper.dio.get(
        '/api/attendance/employee/me',
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final res = AttendanceLogResponse.fromJson(response.data);
        attendanceLogs = res.attendance;
        pagination = res.pagination;

        emit(AttendanceSuccessState(
          stats: currentStats,
          sixMonthsData: currentSixMonthsData,
          attendanceLogs: attendanceLogs,
          pagination: pagination,
        ));
      }
    } catch (e) {
      emit(AttendanceErrorState(e.toString()));
    }
  }
}