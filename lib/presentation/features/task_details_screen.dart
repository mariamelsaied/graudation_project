import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/cubit/task_cubit.dart';
import 'package:graduation_app/cubit/task_state.dart';
import 'package:url_launcher/url_launcher.dart'; 

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;
  const TaskDetailsScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskStatsCubit>().getTaskDetails(widget.taskId);
  }
  Future<void> _launchURL(String urlPath) async {
    final Uri url = Uri.parse(urlPath);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the document link.')),
      );
    }
  }

  String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return 'N/A';
    try {
      return isoDate.split('T')[0];
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.blackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Task Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<TaskStatsCubit, TaskStatsState>(
        builder: (context, state) {
          final cubit = TaskStatsCubit.get(context);
          final task = cubit.currentTaskDetails;

          // 1. حالة التحميل (Loading)
          if (state is GetTaskDetailsLoadingState && task == null) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          // 2. حالة حدوث خطأ (Error)
          if (state is GetTaskDetailsErrorState && task == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  state.errorMessage,
                  // textAlign: Center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }

          // 3. عدم وجود بيانات
          if (task == null) {
            return Center(
              child: Text(
                "No task data available",
                style: TextStyle(color: ColorsApp.greyColor, fontSize: 16),
              ),
            );
          }

          // 4. عرض البيانات بنجاح (Success)
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // عنوان التاسك الرئيسي
                Text(
                  task.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // شارات الحالة والأولوية (Status & Priority Badges)
                Row(
                  children: [
                    _buildBadge(
                      task.status.toUpperCase(),
                      task.status.toLowerCase() == 'completed' ? Colors.green : ColorsApp.blueColor,
                    ),
                    const SizedBox(width: 10),
                    _buildBadge(
                      "${task.priority.toUpperCase()} PRIORITY",
                      task.priority.toLowerCase() == 'high' ? Colors.red : ColorsApp.orangeColor,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Divider(color: Colors.grey, thickness: 0.3),
                const SizedBox(height: 16),

                // تفاصيل التواريخ والـ Deadlines الحركية
                _buildInfoRow(Icons.calendar_today_rounded, "Deadline", _formatDate(task.deadline)),
                const SizedBox(height: 14),
                _buildInfoRow(Icons.create_rounded, "Created At", _formatDate(task.createdAt)),
                const SizedBox(height: 14),
                if (task.completedAt.isNotEmpty) ...[
                  _buildInfoRow(Icons.check_circle_outline_rounded, "Completed At", _formatDate(task.completedAt)),
                  const SizedBox(height: 14),
                ],
                _buildInfoRow(Icons.assignment_turned_in_outlined, "Acceptance Status", task.acceptance.isEmpty ? "None" : task.acceptance),
                
                const SizedBox(height: 24),
                const Divider(color: Colors.grey, thickness: 0.3),
                const SizedBox(height: 16),

                // عرض جزء الـ Document المرفق إن وجد
                if (task.document.isNotEmpty) ...[
                  const Text(
                    "Attachment Document",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => _launchURL(task.document),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: ColorsApp.secondaryBlueColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ColorsApp.blueColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.description_rounded, color: Colors.redAccent, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Task Attachment File",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Click to open external link",
                                  style: TextStyle(color: ColorsApp.greyColor, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.open_in_new_rounded, color: Colors.white54, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // أعضاء الفريق المعينين للمهمة (Assigned Team Members)
                const Text(
                  "Assigned Team Members",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                task.assignedTo.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "No members assigned to this subtask.",
                          style: TextStyle(color: ColorsApp.greyColor, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: task.assignedTo.length,
                        itemBuilder: (context, index) {
                          final member = task.assignedTo[index];
                          return Card(
                            color: ColorsApp.secondaryBlueColor.withOpacity(0.2),
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: ColorsApp.greyColor.withOpacity(0.3),
                                backgroundImage: member.general.avatar.isNotEmpty
                                    ? NetworkImage(member.general.avatar)
                                    : const AssetImage('assets/images/profile.png') as ImageProvider,
                              ),
                              title: Text(
                                "${member.general.firstName} ${member.general.lastName}".trim(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  member.employee.jobTitle,
                                  style: TextStyle(color: ColorsApp.greyColor, fontSize: 13),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // ودجت بناء الـ Badge الملون للحالة والأولوية
  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
      ),
    );
  }

  // ودجت بناء أسطر البيانات الثابتة بشكل منسق مع الأيقونات
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: ColorsApp.blueColor, size: 20),
        const SizedBox(width: 12),
        Text(
          "$title: ",
          style: TextStyle(color: ColorsApp.greyColor, fontSize: 14, fontWeight: FontWeight.w400),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}