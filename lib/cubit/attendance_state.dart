import 'package:graduation_app/models/attendance_model.dart';

abstract class AttendanceState {}

class AttendanceInitialState extends AttendanceState {}

class AttendanceLoadingState extends AttendanceState {}

class AttendanceSuccessState extends AttendanceState {
  final AttendanceStats? stats;
  final SixMonthsData? sixMonthsData;
  final List<AttendanceRecord>? attendanceLogs;
  final Pagination? pagination;

  AttendanceSuccessState({
    this.stats, 
    this.sixMonthsData, 
    this.attendanceLogs, 
    this.pagination
  });
}

class AttendanceErrorState extends AttendanceState {
  final String errorMessage;
  AttendanceErrorState(this.errorMessage);
}