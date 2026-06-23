import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/cubit/auth_cubit.dart';
import 'package:graduation_app/cubit/auth_state.dart';
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
      create:
          (context) =>
              AttendanceCubit()
                ..getMonthlyStats(month: now.month, year: now.year)
                ..getSixMonthsStats(month: now.month, year: now.year)
                ..getAttendanceLogs(page: 1),
      child: const AttendanceScaffold(),
    );
  }
}

class AttendanceScaffold extends StatefulWidget {
  const AttendanceScaffold({super.key});

  @override
  State<AttendanceScaffold> createState() => _AttendanceScaffoldState();
}

class _AttendanceScaffoldState extends State<AttendanceScaffold> {
  DateTime _selectedDate = DateTime.now();

  final List<String> _shortMonthsNames = [
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: ColorsApp.blueColor,
              onPrimary: Colors.white,
              surface: ColorsApp.secondaryBlueColor,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      if (mounted) {
        // استدعاء جلب البيانات للشهر والسنة المحددين معاً لتحديث الكروت والـ Chart فوراً
        AttendanceCubit.get(
          context,
        ).getMonthlyStats(month: _selectedDate.month, year: _selectedDate.year);
        AttendanceCubit.get(context).getSixMonthsStats(
          month: _selectedDate.month,
          year: _selectedDate.year,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${_selectedDate.day} ${_shortMonthsNames[_selectedDate.month - 1]} ${_selectedDate.year}";

    return Scaffold(
      backgroundColor: ColorsApp.darknavyblueColor,
      drawer: const SideMenu(currentPage: "Attendance"),
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
          "My Attendance",
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
      body: SafeArea(
        child: BlocBuilder<AttendanceCubit, AttendanceState>(
          builder: (context, state) {
            final cubit = AttendanceCubit.get(context);
            final stats = cubit.currentStats;
            final logs = cubit.attendanceLogs;
            final pagination = cubit.pagination;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  if (state is AttendanceLoadingState)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  else if (stats != null)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildStatCard(
                            title: "On-time",
                            count: stats.totalOnTimeCount.toString(),
                            color: const Color(0xFF00D1FF),
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            title: "Late attend",
                            count: stats.totalLateCount.toString(),
                            color: const Color(0xFF00E676),
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            title: "Absent",
                            count: stats.totalAbsentCount.toString(),
                            color: Colors.grey,
                            isStriped: true,
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161D2D),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: ColorsApp.blueColor,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const AttendanceChartWidget(),

                  const SizedBox(height: 30),
                  AttendanceHistoryList(logs: logs, pagination: pagination),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String count,
    required Color color,
    bool isStriped = false,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161D2D),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isStriped ? Colors.transparent : color,
                  border: isStriped ? Border.all(color: Colors.grey) : null,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
