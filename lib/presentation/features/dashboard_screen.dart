import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/core/constants/strings.dart';
import 'package:graduation_app/cubit/auth_cubit.dart';
import 'package:graduation_app/cubit/auth_state.dart';
import 'package:graduation_app/cubit/dashboard_cubit.dart'; 
import 'package:graduation_app/cubit/dashboard_states.dart';
import 'package:graduation_app/widgets/item_card.dart';
import 'package:graduation_app/widgets/request_item.dart';
import 'package:graduation_app/widgets/side_menu.dart';
import 'package:graduation_app/widgets/task_item.dart'; 

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime? rangeStart;
  DateTime? rangeEnd;
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().getDashboardStats();
    context.read<DashboardCubit>().getWeeklyAttendanceStats();
    context.read<DashboardCubit>().getMyProjects(); 
    context.read<DashboardCubit>().getRecentRequests(); 
  }


  String getRemainingDays(DateTime? deadline) {
    if (deadline == null) return 'No deadline';
    final now = DateTime.now();
    final difference = deadline.difference(DateTime(now.year, now.month, now.day)).inDays;
    
    if (difference < 0) {
      return 'Overdue';
    } else if (difference == 0) {
      return 'Today';
    } else {
      return '$difference days left';
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'accept':
        return ColorsApp.greenColor;
      case 'rejected':
      case 'reject':
        return ColorsApp.redColor;
      case 'pending':
      default:
        return ColorsApp.yellowColor;
    }
  }

  String getRequestImage(String title) {
    final t = title.toLowerCase();
    if (t.contains('payroll')) {
      return "assets/images/Container.png";
    } else if (t.contains('it') || t.contains('complaint')) {
      return "assets/images/Icon.png";
    } else {
      return "assets/images/equipment2.png";
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(currentPage: "Dashboard"),
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
          "Dashboard",
          style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: ColorsApp.WhiteColor),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: BlocBuilder<LoginCubit, AuthState>(
              builder: (context, state) {
                String? avatarUrl;
                if (state is AuthSuccess) {
                  avatarUrl = state.loginResponse.data?.user?.general?.avatar;
                }

                return CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                      ? NetworkImage(avatarUrl)
                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorsApp.darknavyblueColor, ColorsApp.midnightBlueColor],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hello!", style: TextStyle(color: ColorsApp.greyColor)),
                  BlocBuilder<LoginCubit, AuthState>(
                builder: (context, state) {
                  String userName = "Employee";
                  if (state is AuthSuccess) {
                    userName = state.loginResponse.data?.user?.general?.firstName ?? "Employee";
                  }

                  return Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
                  const SizedBox(height: 10),
                  BlocBuilder<DashboardCubit, DashboardStates>(
                    buildWhen: (previous, current) => 
                        current is DashboardLoadingState || 
                        current is DashboardSuccessState || 
                        current is DashboardErrorState,
                    builder: (context, state) {
                      if (state is DashboardLoadingState) {
                        return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (state is DashboardErrorState) {
                        return Center(
                          child: Text(
                            state.errorMessage,
                            style: TextStyle(color: ColorsApp.redColor, fontSize: 14),
                          ),
                        );
                      } else if (state is DashboardSuccessState) {
                        final dashboardData = state.statsModel.data;
      
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            double aspectRatio = constraints.maxWidth < 360 ? 1.1 : 1.2;
      
                            return GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 6,
                              childAspectRatio: aspectRatio,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                itemCard(
                                  "Today's Status",
                                  dashboardData?.todayStatus?.status ?? "Absent",
                                  dashboardData?.todayStatus?.checkIn ?? "Not Checked In",
                                  ColorsApp.blueColor,
                                  Image.asset('assets/images/time.png', fit: BoxFit.contain),
                                ),
                                itemCard(
                                  "Leave Balance",
                                  "${dashboardData?.leaveBalance ?? 0} Days",
                                  "Annual Leave Quota",
                                  ColorsApp.purpleColor,
                                  Image.asset("assets/images/umberella.png", fit: BoxFit.contain),
                                ),
                                itemCard(
                                  "Active Tasks",
                                  dashboardData?.activeTasks?.count?.toString().padLeft(2, '0') ?? "00",
                                  "High Priority: ${dashboardData?.activeTasks?.highPriorityCount ?? 0}",
                                  ColorsApp.orangeColor,
                                  Image.asset('assets/images/report.png', fit: BoxFit.contain),
                                ),
                                itemCard(
                                  "Pending Requests",
                                  dashboardData?.pendingRequests?.toString().padLeft(2, '0') ?? "00",
                                  "Waiting approval",
                                  ColorsApp.pinkColor,
                                  Image.asset('assets/images/request.png', fit: BoxFit.contain),
                                ),
                              ],
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorsApp.darknavyblueColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ColorsApp.greyColor.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weekly Attendance',
                                  style: TextStyle(
                                    color: ColorsApp.WhiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "On Time vs Late Overview",
                                  style: TextStyle(color: ColorsApp.greyColor, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 12, height: 12,
                              decoration: BoxDecoration(color: ColorsApp.blueColor, borderRadius: BorderRadius.circular(3)),
                            ),
                            const SizedBox(width: 6),
                            Text("On Time", style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 12)),
                            const SizedBox(width: 16),
                            Container(
                              width: 12, height: 12,
                              decoration: BoxDecoration(color: ColorsApp.purpleColor, borderRadius: BorderRadius.circular(3)),
                            ),
                            const SizedBox(width: 6),
                            Text("Late", style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 24),
      
                        SizedBox(
                          height: 200,
                          child: BlocBuilder<DashboardCubit, DashboardStates>(
                            buildWhen: (previous, current) =>
                                current is WeeklyStatsLoadingState ||
                                current is WeeklyStatsSuccessState ||
                                current is WeeklyStatsErrorState,
                            builder: (context, state) {
                              if (state is WeeklyStatsLoadingState) {
                                  return const Center(child: CircularProgressIndicator());
                              } else if (state is WeeklyStatsErrorState) {
                                return Center(
                                  child: Text(
                                    state.errorMessage,
                                    style: TextStyle(color: ColorsApp.redColor, fontSize: 12),
                                  ),
                                );
                              }
      
                              final cubit = context.read<DashboardCubit>();
                              final chartList = cubit.weeklyAttendanceList;
      
                              if (chartList.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No attendance data available",
                                    style: TextStyle(color: ColorsApp.greyColor),
                                  ),
                                );
                              }
      
                              double calculatedMaxY = chartList
                                  .map((e) => (e.onTimeCount ?? 0) + (e.lateCount ?? 0))
                                  .reduce((a, b) => a > b ? a : b)
                                  .toDouble();
      
                              return BarChart(
                                BarChartData(
                                  maxY: calculatedMaxY == 0 ? 5 : calculatedMaxY + 1,
                                  gridData: const FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                  barTouchData: BarTouchData(
                                    enabled: true,
                                    touchTooltipData: BarTouchTooltipData(
                                      getTooltipColor: (group) => ColorsApp.darknavyblueColor,
                                      tooltipBorder: BorderSide(color: ColorsApp.greyColor.withOpacity(0.3)),
                                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                        final item = chartList[group.x.toInt()];
                                        return BarTooltipItem(
                                          "${item.dayName}\nOn Time: ${item.onTimeCount}\nLate: ${item.lateCount}",
                                          const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                        );
                                      },
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 22,
                                        interval: 1, // يضمن عدم تكرار الأرقام بشكل عشوائي
                                        getTitlesWidget: (value, meta) => Text(
                                          '${value.toInt()}',
                                          style: TextStyle(color: ColorsApp.greyColor, fontSize: 11),
                                        ),
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          int index = value.toInt();
                                          if (index >= 0 && index < chartList.length) {
                                            String dayName = chartList[index].dayName ?? '';
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Text(
                                                dayName.length > 3 ? dayName.substring(0, 3) : dayName,
                                                style: TextStyle(color: ColorsApp.greyColor, fontSize: 11, fontWeight: FontWeight.w500),
                                              ),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                  ),
                                  barGroups: List.generate(
                                    chartList.length,
                                    (index) {
                                      final item = chartList[index];
                                      double onTime = (item.onTimeCount ?? 0).toDouble();
                                      double late = (item.lateCount ?? 0).toDouble();
      
                                      return BarChartGroupData(
                                        x: index,
                                        barRods: [
                                          BarChartRodData(
                                            toY: onTime + late,
                                            width: 14,
                                            color: ColorsApp.blueColor,
                                            borderRadius: BorderRadius.circular(6), // حواف دائرية ناعمة وشيك للعمود
                                            rodStackItems: [
                                              BarChartRodStackItem(0, onTime, ColorsApp.blueColor),
                                              BarChartRodStackItem(onTime, onTime + late, ColorsApp.purpleColor),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorsApp.darknavyblueColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Tasks',
                              style: TextStyle(
                                color: ColorsApp.WhiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'View All',
                                style: TextStyle(color: ColorsApp.blueColor, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        BlocBuilder<DashboardCubit, DashboardStates>(
                          buildWhen: (previous, current) =>
                              current is MyProjectsLoadingState ||
                              current is MyProjectsSuccessState ||
                              current is MyProjectsErrorState,
                          builder: (context, state) {
                            if (state is MyProjectsLoadingState) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (state is MyProjectsErrorState) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Text(
                                    state.errorMessage,
                                    style: TextStyle(color: ColorsApp.redColor, fontSize: 12),
                                  ),
                                ),
                              );
                            }
      
                            final projectsList = context.read<DashboardCubit>().myProjectsList;
      
                            if (projectsList.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Text(
                                    "No tasks assigned to you",
                                    style: TextStyle(color: ColorsApp.greyColor, fontSize: 13),
                                  ),
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(projectsList.length, (index) {
                                  final project = projectsList[index];
                                  bool isHigh = project.priority?.toUpperCase() == 'HIGH';
                                  Color statusColor = isHigh ? ColorsApp.orangeColor : ColorsApp.greenColor;
                                  double progressValue = (project.projectProgress ?? 0) / 100.0;
                                  return Padding(
                                    padding: EdgeInsets.only(right: index == projectsList.length - 1 ? 0 : 10.0),
                                    child: TaskItem(
                                      title: project.name ?? 'No Title',
                                      status: project.priority ?? 'Normal',
                                      statusColor: statusColor,
                                      desc: project.description ?? 'No Description provided',
                                      days: getRemainingDays(project.deadline),
                                      progress: progressValue,
                                      progressColor: ColorsApp.blueColor,
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorsApp.darknavyblueColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recent Requests",
                              style: TextStyle(
                                color: ColorsApp.WhiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "View All",
                                style: TextStyle(color: ColorsApp.blueColor, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<DashboardCubit, DashboardStates>(
                          buildWhen: (previous, current) => 
                              current is RecentRequestsLoadingState || 
                              current is RecentRequestsSuccessState || 
                              current is RecentRequestsErrorState,
                          builder: (context, state) {
                            if (state is RecentRequestsLoadingState) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (state is RecentRequestsErrorState) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    state.errorMessage,
                                    style: TextStyle(color: ColorsApp.redColor, fontSize: 12),
                                  ),
                                ),
                              );
                            }
                            
                            final requestsList = context.read<DashboardCubit>().recentRequestsList;
      
                            if (requestsList.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    "No recent requests found",
                                    style: TextStyle(color: ColorsApp.greyColor, fontSize: 13),
                                  ),
                                ),
                              );
                            }
      
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: requestsList.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final request = requestsList[index];
                                
                                return RequestItem(
                                  bgColor: ColorsApp.greyColor.withOpacity(0.1), 
                                  statusColor: getStatusColor(request.status ?? 'Pending'),
                                  status: request.status ?? 'Pending',
                                  date: request.createdAt != null 
                                      ? "${request.createdAt!.year}-${request.createdAt!.month.toString().padLeft(2, '0')}-${request.createdAt!.day.toString().padLeft(2, '0')}" 
                                      : 'No Date',
                                  title: request.type ?? 'Unknown Request',
                                  image: Image.asset(getRequestImage(request.type ?? '')),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
     floatingActionButton: FloatingActionButton(
  backgroundColor: ColorsApp.darknavyblueColor, 
  shape: const CircleBorder(
  ),
  elevation: 6, 
  onPressed: () {
    Navigator.pushNamed(context, Strings.chatbot);
  },
  child: SizedBox( 
    width: double.infinity,
    height: double.infinity,
    child: Image.asset(
      'assets/images/staffly.png', 
      fit: BoxFit.cover,
    ),
  ),
),
    );
  }
}