import 'package:graduation_app/models/performance_model.dart';


abstract class EmployeePerformanceState {}

class EmployeePerformanceInitialState extends EmployeePerformanceState {}

class EmployeePerformanceLoadingState extends EmployeePerformanceState {}

class EmployeePerformanceSuccessState extends EmployeePerformanceState {
  final EmployeePerformanceModel performanceModel;

  EmployeePerformanceSuccessState({required this.performanceModel});
}

class EmployeePerformanceErrorState extends EmployeePerformanceState {
  final String errorMessage;

  EmployeePerformanceErrorState(this.errorMessage);
}