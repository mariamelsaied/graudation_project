import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/cubit/auth_cubit.dart';
import 'package:graduation_app/cubit/auth_state.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/cubit/attendance_cubit.dart';
import 'package:graduation_app/cubit/attendance_state.dart';
import 'package:graduation_app/widgets/attendance_chart.dart';
import 'package:graduation_app/widgets/attendance_history_list.dart';
import 'package:graduation_app/widgets/side_menu.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    return BlocProvider(
      create: (context) => AttendanceCubit()
        ..getMonthlyStats(month: now.month, year: now.year)
        ..getSixMonthsStats(month: now.month, year: now.year)
        ..getAttendanceLogs(page: 1), 
      child: const AttendanceScaffold(),
    );
  }
}

class AttendanceScaffold extends StatelessWidget {
  const AttendanceScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.darknavyblueColor,
      drawer: const SideMenu(currentPage: "Attendance"),
      appBar: AppBar(
          backgroundColor: ColorsApp.darknavyblueColor,
          elevation: 0,
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: ColorsApp.WhiteColor),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Text(
            "Attendance",
            style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_none, color: ColorsApp.WhiteColor),
              onPressed: () {},
            ),
            BlocBuilder<LoginCubit, AuthState>(
              builder: (context, state) {
                String? userImageUrl;
                String userName = "Employee";
                if (state is AuthSuccess) {
                  userImageUrl = state.loginResponse.data?.user?.general?.avatar;
                  userName = state.loginResponse.data?.user?.general?.firstName ?? "Employee";
                  debugPrint("✅ تم العثور على حالة AuthSuccess ورابط الصورة هو: $userImageUrl");
                } else {
                  debugPrint("⚠️ الحالة الحالية للـ LoginCubit هي: ${state.runtimeType} وليست AuthSuccess!");
                }

                final String shortName = userName.isNotEmpty 
                    ? userName.trim().substring(0, 1).toUpperCase() 
                    : "E";

                return Padding(
                  padding: const EdgeInsets.only(right: 12.0, top: 8.0, bottom: 8.0), // إعطاء مساحة مريحة على اليمين حافة الشاشة
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsApp.blueColor.withOpacity(0.2),
                    ),
                    clipBehavior: Clip.antiAlias, 
                    child: (userImageUrl != null && userImageUrl.trim().isNotEmpty)
                        ? Image.network(
                            userImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  shortName,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              shortName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      body: SafeArea(
        child: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            final cubit = AttendanceCubit.get(context);
            final stats = cubit.currentStats;
            final logs = cubit.attendanceLogs;
            final pagination = cubit.pagination;

            if (state is AttendanceLoadingState && stats == null) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const SizedBox(height: 20),
                  if (stats != null)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildStatCard(title: "On-time", count: stats.totalOnTimeCount.toString(), color: const Color(0xFF00D1FF)),
                          const SizedBox(width: 12),
                          _buildStatCard(title: "Late attend", count: stats.totalLateCount.toString(), color: const Color(0xFF00E676)),
                          const SizedBox(width: 12),
                          _buildStatCard(title: "Absent", count: stats.totalAbsentCount.toString(), color: Colors.grey, isStriped: true),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () async {
                        final selected = await showMonthPicker(context: context, initialDate: DateTime.now());
                        if (selected != null && context.mounted) {
                          context.read<AttendanceCubit>().getSixMonthsStats(month: selected.month, year: selected.year);
                        }
                      },
                      icon: const Icon(Icons.calendar_month, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const AttendanceChartWidget(),
                  
                  const SizedBox(height: 30),
                  AttendanceHistoryList(
                    logs: logs,
                    pagination: pagination,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String count, required Color color, bool isStriped = false}) {
    return Container(
      width: 160, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF161D2D), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: isStriped ? Colors.transparent : color, border: isStriped ? Border.all(color: Colors.grey) : null)),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ]),
          const SizedBox(height: 12),
          Text(count, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}