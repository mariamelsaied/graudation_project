import 'package:graduation_app/models/task_model.dart';

abstract class TaskStatsState {
  const TaskStatsState();
}

class TaskStatsInitialState extends TaskStatsState {}
class GetTaskStatsLoadingState extends TaskStatsState {}

class GetTaskStatsSuccessState extends TaskStatsState {
  final TaskStatsModel taskStats;
  const GetTaskStatsSuccessState(this.taskStats);
}

class GetTaskStatsErrorState extends TaskStatsState {
  final String errorMessage;
  const GetTaskStatsErrorState(this.errorMessage);
}

class GetTasksLoadingState extends TaskStatsState {}

class GetTasksSuccessState extends TaskStatsState {
  final List<TaskModel> tasks;
  const GetTasksSuccessState(this.tasks);
}

class GetTasksErrorState extends TaskStatsState {
  final String errorMessage;
  const GetTasksErrorState(this.errorMessage);
}


class GetTaskDetailsLoadingState extends TaskStatsState {}

class GetTaskDetailsSuccessState extends TaskStatsState {
  final TaskModel task;
  const GetTaskDetailsSuccessState(this.task);
}

class GetTaskDetailsErrorState extends TaskStatsState {
  final String errorMessage;
  const GetTaskDetailsErrorState(this.errorMessage);
}

class UpdateTaskStatusLoadingState extends TaskStatsState {}

class UpdateTaskStatusSuccessState extends TaskStatsState {
  final TaskModel updatedTask;
  const UpdateTaskStatusSuccessState(this.updatedTask);
}

class UpdateTaskStatusErrorState extends TaskStatsState {
  final String errorMessage;
  const UpdateTaskStatusErrorState(this.errorMessage);
}