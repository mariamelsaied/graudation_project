import '../models/leave_model.dart'; 

abstract class LeaveState {}

class LeaveInitialState extends LeaveState {}

class LeaveLoadingState extends LeaveState {}

class LeaveSuccessState extends LeaveState {
  final List<LeaveModel> leaves;
  final PaginationLeave pagination;

  LeaveSuccessState({required this.leaves, required this.pagination});
}

class LeaveErrorState extends LeaveState {
  final String message;
  LeaveErrorState(this.message);
}


class LeaveSubmitLoadingState extends LeaveState {}

class LeaveSubmitSuccessState extends LeaveState {
  final String message;
  LeaveSubmitSuccessState(this.message);
}

class LeaveSubmitErrorState extends LeaveState {
  final String message;
  LeaveSubmitErrorState(this.message);
}


class LeaveUpdateLoadingState extends LeaveState {}

class LeaveUpdateSuccessState extends LeaveState {
  final String message;
  LeaveUpdateSuccessState(this.message);
}

class LeaveUpdateErrorState extends LeaveState {
  final String message;
  LeaveUpdateErrorState(this.message);
}


class LeaveChartLoadingState extends LeaveState {}

class LeaveChartSuccessState extends LeaveState {
  final List<dynamic> chartData;

  LeaveChartSuccessState({required this.chartData});
}

class LeaveChartErrorState extends LeaveState {
  final String message;
  LeaveChartErrorState(this.message);
}

class LeaveBalanceLoadingState extends LeaveState {}

class LeaveBalanceSuccessState extends LeaveState {
  final Map<String, dynamic> balanceData;

  LeaveBalanceSuccessState({required this.balanceData});
}

class LeaveBalanceErrorState extends LeaveState {
  final String message;
  LeaveBalanceErrorState(this.message);
}



class LeaveDeleteLoadingState extends LeaveState {}

class LeaveDeleteSuccessState extends LeaveState {
  final String message;
  LeaveDeleteSuccessState(this.message);
}

class LeaveDeleteErrorState extends LeaveState {
  final String message;
  LeaveDeleteErrorState(this.message);
}