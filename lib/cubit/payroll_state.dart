abstract class PayrollState {}

class PayrollInitialState extends PayrollState {}

// --- 1. حالات الـ List والـ Tabs السفلى ---
class PayrollLoadingState extends PayrollState {}
class PayrollSuccessState extends PayrollState {
  final List<dynamic> payrolls;
  final dynamic pagination;
  PayrollSuccessState({required this.payrolls, this.pagination});
}
class PayrollErrorState extends PayrollState {
  final String message;
  PayrollErrorState({required this.message});
}


class PayrollChartLoadingState extends PayrollState {}
class PayrollChartSuccessState extends PayrollState {
  final List<dynamic> chartData;
  PayrollChartSuccessState({required this.chartData});
}
class PayrollChartErrorState extends PayrollState {
  final String message;
  PayrollChartErrorState({required this.message});
}
class PayrollMonthlySummaryLoadingState extends PayrollState {}
class PayrollMonthlySummarySuccessState extends PayrollState {
  final Map<String, dynamic> summaryData;
  PayrollMonthlySummarySuccessState({required this.summaryData});
}
class PayrollMonthlySummaryErrorState extends PayrollState {
  final String message;
  PayrollMonthlySummaryErrorState({required this.message});
}