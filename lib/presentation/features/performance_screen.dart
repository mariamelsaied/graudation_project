import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/cubit/auth_cubit.dart';
import 'package:graduation_app/cubit/auth_state.dart';
import 'package:graduation_app/cubit/performance_cubit.dart';
import 'package:graduation_app/cubit/performance_state.dart';
import 'package:graduation_app/models/performance_model.dart';
import 'package:graduation_app/widgets/side_menu.dart';

class EmployeePerformanceScreen extends StatefulWidget {
  const EmployeePerformanceScreen({super.key});

  @override
  State<EmployeePerformanceScreen> createState() => _EmployeePerformanceScreenState();
}

class _EmployeePerformanceScreenState extends State<EmployeePerformanceScreen> {
  int selectedMonthIndex = DateTime.now().month - 1; 

  final List<String> months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  @override
  void initState() {
    super.initState();
    context.read<EmployeePerformanceCubit>().getEmployeePerformance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.pimaryColor,
      drawer: const SideMenu(currentPage: "Performance"),
      appBar: AppBar(
        backgroundColor: ColorsApp.pimaryColor,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: ColorsApp.WhiteColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Performance",
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
              }

              final String shortName = userName.isNotEmpty 
                  ? userName.trim().substring(0, 1).toUpperCase() 
                  : "E";

              return Padding(
                padding: const EdgeInsets.only(right: 12.0, top: 8.0, bottom: 8.0),
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
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(shortName, style: TextStyle(color: ColorsApp.WhiteColor, fontWeight: FontWeight.bold)),
                          ),
                        )
                      : Center(
                          child: Text(
                            shortName,
                            style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendarBar(),
          
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorsApp.pimaryColor, 
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: BlocBuilder<EmployeePerformanceCubit, EmployeePerformanceState>(
                builder: (context, state) {
                  if (state is EmployeePerformanceLoadingState) {
                    return Center(child: CircularProgressIndicator(color: ColorsApp.blueColor));
                  } else if (state is EmployeePerformanceSuccessState) {
                    return _buildPerformanceContent(state.performanceModel.data);
                  } else if (state is EmployeePerformanceErrorState) {
                    return _buildErrorWidget(state.errorMessage);
                  }
                  return Center(child: Text("No Data Available", style: TextStyle(color: ColorsApp.greyColor)));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCalendarBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: months.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            bool isSelected = index == selectedMonthIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedMonthIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? ColorsApp.blueColor : ColorsApp.calenderColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? ColorsApp.blueColor : Colors.white10,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    months[index],
                    style: TextStyle(
                      color: ColorsApp.WhiteColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
    );
  }
  Widget _buildPerformanceContent(PerformanceData data) {
    bool isNegative = data.percentageChange < 0;
    return RefreshIndicator(
      color: ColorsApp.blueColor,
      backgroundColor: ColorsApp.secondaryBlueColor,
      onRefresh: () async {
        context.read<EmployeePerformanceCubit>().getEmployeePerformance();
      },
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: ColorsApp.secondaryBlueColor, 
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current Period Summary",
                        style: TextStyle(color: ColorsApp.greyColor, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "${data.currentPeriod.from} / ${data.currentPeriod.to}",
                        style: TextStyle(color: ColorsApp.greyColor.withOpacity(0.7), fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        "${data.overallPerformance}",
                        style: TextStyle(color: ColorsApp.WhiteColor, fontSize: 44, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: data.performanceStatus.toLowerCase() == 'poor' 
                              ? ColorsApp.orangeColor.withOpacity(0.15) 
                              : ColorsApp.greenColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          data.performanceStatus,
                          style: TextStyle(
                            color: data.performanceStatus.toLowerCase() == 'poor' ? ColorsApp.orangeColor : ColorsApp.greenColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        isNegative ? Icons.trending_down : Icons.trending_up,
                        color: isNegative ? ColorsApp.pinkColor : ColorsApp.greenColor,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "${data.percentageChange}% Compared to last period",
                        style: TextStyle(
                          color: isNegative ? ColorsApp.pinkColor : ColorsApp.greenColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Performance Progress Chart",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsApp.WhiteColor),
          ),
          const SizedBox(height: 12),
          _buildLineChart(data.previousPeriods),
          const SizedBox(height: 24),
          Text(
            "Key Performance Indicators (KPIs)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorsApp.WhiteColor),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  title: "Attendance Score",
                  score: data.kpis.attendanceScore,
                  icon: Icons.calendar_today,
                  color: ColorsApp.blueColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildKpiCard(
                  title: "Task Score",
                  score: data.kpis.taskScore,
                  icon: Icons.assignment_turned_in,
                  color: ColorsApp.purpleColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildLineChart(List<PreviousPeriod> previousPeriods) {
    if (previousPeriods.isEmpty) {
      return Card(
        color: ColorsApp.secondaryBlueColor,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(child: Text("No chart data available", style: TextStyle(color: ColorsApp.greyColor))),
        ),
      );
    }

    List<PreviousPeriod> orientedData = previousPeriods.reversed.toList();

    List<FlSpot> spots = [];
    for (int i = 0; i < orientedData.length; i++) {
      spots.add(FlSpot(i.toDouble(), orientedData[i].overallPerformance.toDouble()));
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: ColorsApp.secondaryBlueColor,
      child: Padding(
        padding: const EdgeInsets.only(right: 24, left: 12, top: 24, bottom: 12),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index >= 0 && index < orientedData.length) {
                        String dateStr = orientedData[index].from.replaceFirst("2026-", "").replaceFirst("2025-", "");
                        
                        return SideTitleWidget(
                          meta: meta, 
                          space: 4,
                          child: Text(
                            dateStr, 
                            style: TextStyle(color: ColorsApp.greyColor, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 35,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          value.toInt().toString(),
                          style: TextStyle(color: ColorsApp.greyColor, fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (orientedData.length - 1).toDouble(),
              minY: 0,
              maxY: 100, 
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: ColorsApp.blueColor,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                      radius: 4,
                      color: ColorsApp.blueColor,
                      strokeWidth: 2,
                      strokeColor: ColorsApp.WhiteColor,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: ColorsApp.blueColor.withOpacity(0.15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard({required String title, required num score, required IconData icon, required Color color}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: ColorsApp.secondaryBlueColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 13, color: ColorsApp.greyColor, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text("$score", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: ColorsApp.WhiteColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: ColorsApp.redColor, size: 48),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(fontSize: 16, color: ColorsApp.greyColor)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<EmployeePerformanceCubit>().getEmployeePerformance(),
            style: ElevatedButton.styleFrom(backgroundColor: ColorsApp.blueColor),
            child: Text("Retry", style: TextStyle(color: ColorsApp.WhiteColor)),
          )
        ],
      ),
    );
  }
}