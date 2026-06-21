import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/helper/dio_helper.dart';
import 'package:graduation_app/cubit/task_state.dart';
import 'package:graduation_app/models/task_model.dart';
import 'package:graduation_app/services/secure_storage.dart';

class TaskStatsCubit extends Cubit<TaskStatsState> {
  TaskStatsCubit() : super(TaskStatsInitialState());

  final SecureStorage _storage = SecureStorage();
  static TaskStatsCubit get(context) => BlocProvider.of(context);

  TaskStatsModel? taskStats;
  List<TaskModel> tasks = []; 
  
  TaskModel? currentTaskDetails;
  Future<void> getTaskStats() async {
    emit(GetTaskStatsLoadingState());

    final String? token = await _storage.getToken();
    if (token == null) {
      emit(const GetTaskStatsErrorState("Access token is required."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/tasks/task-stats',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          taskStats = TaskStatsModel.fromJson(responseData['data']);
          emit(GetTaskStatsSuccessState(taskStats!));
        } else {
          emit(const GetTaskStatsErrorState("Failed to parse task statistics data"));
        }
      } else {
        emit(const GetTaskStatsErrorState("Failed to load task statistics"));
      }
    } on DioException catch (e) {
      final errorData = e.response?.data['message'];
      String errorMessage = "Error fetching task stats";

      if (errorData is List) {
        errorMessage = errorData.join(", ");
      } else if (errorData is String) {
        errorMessage = errorData;
      }
      emit(GetTaskStatsErrorState(errorMessage));
    } catch (e) {
      emit(GetTaskStatsErrorState(e.toString()));
    }
  }
  Future<void> getMyTasks({String filter = 'team-tasks', int page = 1, int limit = 10}) async {
    emit(GetTasksLoadingState());

    final String? token = await _storage.getToken();
    if (token == null) {
      emit(const GetTasksErrorState("Access token is required."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/tasks/my-tasks',
        queryParameters: {
          'filter': filter,
          'page': page,
          'limit': limit,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['status'] == 'success' && responseData['data']?['tasks'] != null) {
          final List<dynamic> fetchedTasks = responseData['data']['tasks'];
          
          tasks = fetchedTasks.map((item) => TaskModel.fromJson(item)).toList();
          
          emit(GetTasksSuccessState(List.from(tasks))); 
        } else {
          emit(const GetTasksErrorState("Failed to parse tasks list data"));
        }
      } else {
        emit(const GetTasksErrorState("Failed to load tasks"));
      }
    } on DioException catch (e) {
      final errorData = e.response?.data['message'];
      String errorMessage = "Error fetching tasks list";

      if (errorData is List) {
        errorMessage = errorData.join(", ");
      } else if (errorData is String) {
        errorMessage = errorData;
      }
      emit(GetTasksErrorState(errorMessage));
    } catch (e) {
      emit(GetTasksErrorState(e.toString()));
    }
  }

  Future<void> searchTasks(String title) async {
    if (title.trim().isEmpty) {
      getMyTasks();
      return;
    }

    emit(GetTasksLoadingState());

    final String? token = await _storage.getToken();
    if (token == null) {
      emit(const GetTasksErrorState("Access token is required."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/tasks/search',
        queryParameters: {'title': title},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['status'] == 'success' && responseData['data']?['results'] != null) {
          final List<dynamic> fetchedResults = responseData['data']['results'];
          
          tasks = fetchedResults.map((item) => TaskModel.fromJson(item)).toList();
          
          emit(GetTasksSuccessState(List.from(tasks)));
        } else {
          emit(const GetTasksErrorState("Failed to parse search results"));
        }
      } else {
        emit(const GetTasksErrorState("Failed to execute search"));
      }
    } on DioException catch (e) {
      final errorData = e.response?.data['message'];
      String errorMessage = "Error during search";

      if (errorData is List) {
        errorMessage = errorData.join(", ");
      } else if (errorData is String) {
        errorMessage = errorData;
      }
      emit(GetTasksErrorState(errorMessage));
    } catch (e) {
      emit(GetTasksErrorState(e.toString()));
    }
  }
  Future<void> getTaskDetails(String taskId) async {
    emit(GetTaskDetailsLoadingState());

    final String? token = await _storage.getToken();
    if (token == null) {
      emit(const GetTaskDetailsErrorState("Access token is required."));
      return;
    }

    try {
      final response = await DioHelper.dio.get(
        '/api/tasks/task/$taskId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['status'] == 'success' && responseData['data']?['tasks'] != null) {
          currentTaskDetails = TaskModel.fromJson(responseData['data']['tasks']);
          emit(GetTaskDetailsSuccessState(currentTaskDetails!));
        } else {
          emit(const GetTaskDetailsErrorState("Failed to parse task details data"));
        }
      } else {
        emit(const GetTaskDetailsErrorState("Failed to load task details"));
      }
    } on DioException catch (e) {
      final errorData = e.response?.data['message'];
      String errorMessage = "Error fetching task details";

      if (errorData is List) {
        errorMessage = errorData.join(", ");
      } else if (errorData is String) {
        errorMessage = errorData;
      }
      emit(GetTaskDetailsErrorState(errorMessage));
    } catch (e) {
      emit(GetTaskDetailsErrorState(e.toString()));
    }
  }

  Future<void> updateTaskStatus({required String taskId, String? documentPath}) async {
    emit(UpdateTaskStatusLoadingState());

    final String? token = await _storage.getToken();
    if (token == null) {
      emit(const UpdateTaskStatusErrorState("Access token is required."));
      return;
    }

    try {
      Map<String, dynamic> dataMap = {};
      if (documentPath != null && documentPath.isNotEmpty) {
        dataMap['document'] = await MultipartFile.fromFile(documentPath);
      }
      FormData formData = FormData.fromMap(dataMap);

      final response = await DioHelper.dio.patch(
        '/api/tasks/$taskId',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['status'] == 'success' && responseData['data']?['task'] != null) {
          
          final TaskModel updatedTask = TaskModel.fromJson(responseData['data']['task']);

          if (currentTaskDetails != null && currentTaskDetails!.id == taskId) {
            currentTaskDetails = updatedTask;
          }
          final index = tasks.indexWhere((t) => t.id == taskId);
          if (index != -1) {
            tasks[index] = updatedTask;
          }

          emit(UpdateTaskStatusSuccessState(updatedTask));
          emit(GetTasksSuccessState(List.from(tasks)));
        } else {
          emit(const UpdateTaskStatusErrorState("Failed to parse updated task data"));
        }
      } else {
        emit(const UpdateTaskStatusErrorState("Failed to update task status"));
      }
    } on DioException catch (e) {
      final errorData = e.response?.data['message'];
      String errorMessage = "Error updating task status";

      if (errorData is List) {
        errorMessage = errorData.join(", ");
      } else if (errorData is String) {
        errorMessage = errorData;
      }
      emit(UpdateTaskStatusErrorState(errorMessage));
    } catch (e) {
      emit(UpdateTaskStatusErrorState(e.toString()));
    }
  }
}