import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/cubit/auth_cubit.dart';
import 'package:graduation_app/cubit/auth_state.dart';
import 'package:graduation_app/cubit/task_cubit.dart';
import 'package:graduation_app/cubit/task_state.dart';
import 'package:graduation_app/models/task_model.dart';
import 'package:graduation_app/widgets/CustomTabsWidget.dart';
import 'package:graduation_app/widgets/SearchBarWidget.dart';
import 'package:graduation_app/widgets/SummaryCardWidget.dart';
import 'package:graduation_app/widgets/TaskStateCardWidget.dart';
import 'package:graduation_app/widgets/side_menu.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({Key? key}) : super(key: key);

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> {
  bool isMyTasksSelected = true;
  int _currentPage = 1;
  final int _totalPages = 10;
  String _searchText = '';

  String get _currentFilter => isMyTasksSelected ? 'my-tasks' : 'all-tasks';

  @override
  void initState() {
    super.initState();
    final cubit = context.read<TaskStatsCubit>();
    cubit.getTaskStats();
    cubit.getMyTasks(filter: _currentFilter, page: _currentPage);
  }

  void _changePage(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
    context.read<TaskStatsCubit>().getMyTasks(
      filter: _currentFilter,
      page: newPage,
    );
  }

  void _onTabChanged(bool isMyTasks) {
    setState(() {
      isMyTasksSelected = isMyTasks;
      _currentPage = 1;
    });
    context.read<TaskStatsCubit>().getMyTasks(filter: _currentFilter, page: 1);
  }

  List<int> _getVisiblePages() {
    int startPage = _currentPage - 1;
    if (startPage < 1) startPage = 1;

    int endPage = startPage + 2;
    if (endPage > _totalPages) {
      endPage = _totalPages;
      startPage = _totalPages - 2;
    }

    List<int> visiblePages = [];
    for (int i = startPage; i <= endPage; i++) {
      visiblePages.add(i);
    }
    return visiblePages;
  }

  void _showUploadDocumentDialog(BuildContext context, String taskId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorsApp.secondaryBlueColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomContext) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Upload Task Document",
                style: TextStyle(
                  color: ColorsApp.WhiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "To set this task as 'On-going', you must attach the required document for HR review.",
                textAlign: TextAlign.center,
                style: TextStyle(color: ColorsApp.greyColor, fontSize: 14),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsApp.blueColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.upload_file, color: ColorsApp.WhiteColor),
                label: Text(
                  "Select & Submit Document",
                  style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 16),
                ),
                onPressed: () async {
                  try {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.any, allowMultiple: false);

                    if (result != null && result.files.single.path != null) {
                      String filePath = result.files.single.path!;
                      Navigator.pop(bottomContext);
                      context.read<TaskStatsCubit>().updateTaskStatus(
                        taskId: taskId,
                        documentPath: filePath,
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error picking file: $e'),
                        backgroundColor: ColorsApp.redColor,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _mapTaskToWidget(TaskModel task) {
    String priorityText = '${task.priority.toUpperCase()} PRIORITY';
    Color priorityColor = ColorsApp.greyColor;
    Color priorityBgColor = ColorsApp.secondaryBlueColor;

    if (task.priority.toLowerCase() == 'high') {
      priorityColor = ColorsApp.pinkColor;
      priorityBgColor = ColorsApp.redColor.withOpacity(0.2);
    } else if (task.priority.toLowerCase() == 'medium') {
      priorityColor = ColorsApp.orangeColor;
      priorityBgColor = ColorsApp.brownColor;
    }

    String statusText = task.status.toUpperCase();
    Color statusColor = ColorsApp.blueColor;
    Color statusBgColor = ColorsApp.darkblueColor;
    bool isCompleted = false;
    IconData icon = Icons.calendar_today;

    if (task.status.toLowerCase() == 'pending') {
      statusColor = ColorsApp.yellowColor;
      statusBgColor = ColorsApp.yellowColor.withOpacity(0.1);
    } else if (task.status.toLowerCase() == 'on-going' ||
        task.status.toLowerCase() == 'todo') {
      statusColor = ColorsApp.greyColor;
      statusBgColor = ColorsApp.secondaryBlueColor;
      icon = Icons.access_time;
    } else if (task.status.toLowerCase() == 'completed') {
      statusColor = ColorsApp.greenColor;
      statusBgColor = ColorsApp.darkGreenColor;
      icon = Icons.check_circle_outline;
      isCompleted = true;
    }

    String formattedDate = 'Done';
    if (!isCompleted && task.deadline.isNotEmpty) {
      try {
        DateTime parsedDate = DateTime.parse(task.deadline);
        formattedDate =
            "${_getMonthName(parsedDate.month)} ${parsedDate.day}, ${parsedDate.year}";
      } catch (_) {
        formattedDate = 'Today';
      }
    }

    final bool isTaskCompleted = task.status.toLowerCase() == 'completed';

    return Stack(
      children: [
        TaskStateCardWidget(
          title: task.title,
          statusText: statusText,
          statusColor: statusColor,
          statusBgColor: statusBgColor,
          priorityText: priorityText,
          priorityColor: priorityColor,
          priorityBgColor: priorityBgColor,
          dateOrStatus: formattedDate,
          icon: icon,
          isCompleted: isCompleted,
          hasAvatar:
              task.assignedTo.isNotEmpty &&
              task.assignedTo[0].general.avatar.isNotEmpty,
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                color: ColorsApp.secondaryBlueColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: ColorsApp.greyColor, size: 22),
              enabled: !isTaskCompleted,
              onSelected: (value) {
                if (value == 'going') {
                  _showUploadDocumentDialog(context, task.id);
                }
              },
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'going',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: ColorsApp.blueColor,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Submit',
                            style: TextStyle(
                              color: ColorsApp.WhiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
            ),
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.darknavyblueColor,
      drawer: const SideMenu(currentPage: "My Tasks"),
      appBar: AppBar(
        backgroundColor: ColorsApp.darknavyblueColor,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu, color: ColorsApp.WhiteColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
        title: Text(
          "My Tasks",
          style: TextStyle(
            color: ColorsApp.WhiteColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0, right: 8.0),
            child: Badge(
              isLabelVisible: true,
              backgroundColor: ColorsApp.redColor,
              smallSize: 9,
              alignment: AlignmentDirectional(0.5, -0.5),
              child: IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: ColorsApp.WhiteColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/notification');
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: BlocBuilder<LoginCubit, AuthState>(
              builder: (context, state) {
                String? avatarUrl;
                if (state is AuthSuccess) {
                  avatarUrl = state.loginResponse.data?.user?.general?.avatar;
                }

                return CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[800],
                  backgroundImage:
                      (avatarUrl != null && avatarUrl.isNotEmpty)
                          ? NetworkImage(avatarUrl)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                );
              },
            ),
          ),
        ],
      ),
      body: BlocListener<TaskStatsCubit, TaskStatsState>(
        listenWhen:
            (previous, current) =>
                current is UpdateTaskStatusSuccessState ||
                current is UpdateTaskStatusErrorState,
        listener: (context, state) {
          if (state is UpdateTaskStatusSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Document uploaded & Task updated to On-going!'),
                backgroundColor: Colors.green,
              ),
            );
            context.read<TaskStatsCubit>().getTaskStats();
            context.read<TaskStatsCubit>().getMyTasks(
              filter: _currentFilter,
              page: _currentPage,
            );
          } else if (state is UpdateTaskStatusErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: ColorsApp.redColor,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<TaskStatsCubit, TaskStatsState>(
                builder: (context, state) {
                  final cubit = TaskStatsCubit.get(context);
                  final stats = cubit.taskStats;

                  if (state is GetTaskStatsLoadingState && stats == null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CircularProgressIndicator(
                          color: ColorsApp.blueColor,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SummaryCardWidget(
                          title: 'Due Today',
                          count:
                              stats != null ? stats.dueToday.toString() : '0',
                        ),
                        const SizedBox(width: 12),
                        SummaryCardWidget(
                          title: 'Pending Review',
                          count:
                              stats != null
                                  ? stats.pendingReview.toString()
                                  : '0',
                        ),
                        const SizedBox(width: 12),
                        SummaryCardWidget(
                          title: 'Completed',
                          count:
                              stats != null
                                  ? stats.completed.total.toString()
                                  : '0',
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              SearchBarWidget(
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                  context.read<TaskStatsCubit>().searchTasks(value);
                },
              ),
              const SizedBox(height: 24),

              CustomTabsWidget(
                isMyTasksSelected: isMyTasksSelected,
                onTabChanged: _onTabChanged,
              ),
              const SizedBox(height: 24),

              BlocBuilder<TaskStatsCubit, TaskStatsState>(
                builder: (context, state) {
                  final cubit = TaskStatsCubit.get(context);
                  List<TaskModel> filteredTasks = cubit.tasks;

                  bool isUpdating = state is UpdateTaskStatusLoadingState;

                  if (state is GetTasksLoadingState && cubit.tasks.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: CircularProgressIndicator(
                          color: ColorsApp.blueColor,
                        ),
                      ),
                    );
                  }

                  if (filteredTasks.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          _searchText.isEmpty
                              ? 'No tasks found'
                              : 'No tasks found for "$_searchText"',
                          style: TextStyle(
                            color: ColorsApp.greyColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredTasks.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final currentTask = filteredTasks[index];
                          return _mapTaskToWidget(currentTask);
                        },
                      ),
                      if (isUpdating)
                        Positioned.fill(
                          child: Container(
                            color: ColorsApp.blackColor.withOpacity(0.4),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ColorsApp.blueColor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 32),
              if (_searchText.isEmpty)
                BlocBuilder<TaskStatsCubit, TaskStatsState>(
                  builder: (context, state) {
                    final cubit = TaskStatsCubit.get(context);
                    return Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: ColorsApp.greyColor,
                              fontSize: 14,
                            ),
                            children: [
                              const TextSpan(text: 'Showing: '),
                              TextSpan(
                                text: cubit.tasks.length.toString(),
                                style: TextStyle(
                                  color: ColorsApp.blueColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(text: ' tasks on this page'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.chevron_left,
                                color: ColorsApp.greyColor,
                              ),
                              onPressed:
                                  _currentPage > 1
                                      ? () => _changePage(_currentPage - 1)
                                      : null,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  _getVisiblePages().map((page) {
                                    return _buildPageNumber(page);
                                  }).toList(),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.chevron_right,
                                color: ColorsApp.greyColor,
                              ),
                              onPressed:
                                  _currentPage < _totalPages
                                      ? () => _changePage(_currentPage + 1)
                                      : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageNumber(int page) {
    bool isActive = _currentPage == page;
    return GestureDetector(
      onTap: () => _changePage(page),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? ColorsApp.blueColor : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          page.toString(),
          style: TextStyle(
            color: isActive ? ColorsApp.WhiteColor : ColorsApp.greyColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
