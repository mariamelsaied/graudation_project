import 'package:graduation_app/models/dashboard_stats_model.dart';

abstract class DashboardStates {}

class DashboardInitialState extends DashboardStates {}


class DashboardLoadingState extends DashboardStates {}
class DashboardSuccessState extends DashboardStates {
  final DashboardStatsModel statsModel;
  DashboardSuccessState(this.statsModel);
}
class DashboardErrorState extends DashboardStates {
  final String errorMessage;
  DashboardErrorState(this.errorMessage);
}


class WeeklyStatsLoadingState extends DashboardStates {}
class WeeklyStatsSuccessState extends DashboardStates {
  final List<WeeklyStatsItem> weeklyStats;
  WeeklyStatsSuccessState(this.weeklyStats);
}
class WeeklyStatsErrorState extends DashboardStates {
  final String errorMessage;
  WeeklyStatsErrorState(this.errorMessage);
}

class MyProjectsLoadingState extends DashboardStates {}
class MyProjectsSuccessState extends DashboardStates {
  final List<ProjectItem> projects;
  MyProjectsSuccessState(this.projects);
}
class MyProjectsErrorState extends DashboardStates {
  final String errorMessage;
  MyProjectsErrorState(this.errorMessage);
}


class RecentRequestsLoadingState extends DashboardStates {}
class RecentRequestsSuccessState extends DashboardStates {
  final List<RequestItem> requests;
  RecentRequestsSuccessState(this.requests);
}
class RecentRequestsErrorState extends DashboardStates {
  final String errorMessage;
  RecentRequestsErrorState(this.errorMessage);
}