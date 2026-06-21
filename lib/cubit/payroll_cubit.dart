import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/helper/dio_helper.dart';
import 'package:graduation_app/models/payroll_model.dart';
import 'package:graduation_app/services/secure_storage.dart';
import 'payroll_state.dart';

class PayrollCubit extends Cubit<PayrollState> {
  PayrollCubit() : super(PayrollInitialState());

  final SecureStorage storage = SecureStorage(); 

  static PayrollCubit get(context) => BlocProvider.of<PayrollCubit>(context);

  Future<void> getPayrolls({required int page, int limit = 5, String? status}) async {
    emit(PayrollLoadingState());
    final queryParams = '?page=$page&limit=$limit${status != null && status != "All" ? "&status=$status" : ""}';

    try {
      final token = await storage.getToken();
      final response = await DioHelper.dio.get(
        '/api/payroll/employees/me$queryParams',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final payrollResponse = PayrollResponse.fromJson(response.data);
        
        emit(PayrollSuccessState(
          payrolls: payrollResponse.payrolls,
          pagination: payrollResponse.pagination,
        ));
      } else {
        emit(PayrollErrorState(message: "Failed to load payrolls"));
      }
    } on DioException catch (e) {
      String errorMessage = "عذراً، حدث خطأ ما";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      emit(PayrollErrorState(message: errorMessage));
    } catch (e) {
      emit(PayrollErrorState(message: e.toString()));
    }
  }

  Future<void> getYearlyChart({required int year}) async {
    emit(PayrollChartLoadingState()); 

    try {
      final token = await storage.getToken();
      final response = await DioHelper.dio.get(
        '/api/payroll/dashboard/yearly/me?year=$year', 
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> chartData = response.data['data']['yearlyOverview'];
        emit(PayrollChartSuccessState(chartData: chartData));
      } else {
        emit(PayrollChartErrorState(message: "Failed to load chart data"));
      }
    } on DioException catch (e) {
      String errorMessage = "خطأ في جلب بيانات الرسم البياني";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      emit(PayrollChartErrorState(message: errorMessage));
    } catch (e) {
      emit(PayrollChartErrorState(message: e.toString()));
    }
  }

  Future<void> getMonthlySummary({required int month, required int year}) async {
    emit(PayrollMonthlySummaryLoadingState());

    try {
      final token = await storage.getToken();
      final response = await DioHelper.dio.get(
        '/api/payroll/dashboard/monthly/me?month=$month&year=$year',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> summaryData = response.data['data'];
        emit(PayrollMonthlySummarySuccessState(summaryData: summaryData));
      } else {
        emit(PayrollMonthlySummaryErrorState(message: "Failed to load monthly summary"));
      }
    } on DioException catch (e) {
      String errorMessage = "خطأ في جلب بيانات الملخص الشهري";
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      }
      emit(PayrollMonthlySummaryErrorState(message: errorMessage));
    } catch (e) {
      emit(PayrollMonthlySummaryErrorState(message: e.toString()));
    }
  }
}