import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/cubit/attendance_cubit.dart';
import 'package:graduation_app/cubit/attendance_state.dart';

class AttendanceChartWidget extends StatelessWidget {
  const AttendanceChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        final chartData = AttendanceCubit.get(context).currentSixMonthsData;

        if (chartData == null || chartData.monthlyStats.isEmpty) {
          return const SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        return Container(
          height: 350,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF161D2D),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceEvenly,
                    maxY: 20,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 ||
                                index >= chartData.monthlyStats.length)
                              return const SizedBox();
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                chartData.monthlyStats[index].monthName
                                    .substring(0, 3),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 5,
                      getDrawingHorizontalLine:
                          (value) => const FlLine(
                            color: Colors.white10,
                            strokeWidth: 1,
                          ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(chartData.monthlyStats.length, (
                      index,
                    ) {
                      final item = chartData.monthlyStats[index];
                      return BarChartGroupData(
                        x: index,
                        groupVertically: false,
                        barRods: [
                          BarChartRodData(
                            toY: item.totalOnTime.toDouble(),
                            color: const Color(0xFF00D1FF),
                            width: 12,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                          BarChartRodData(
                            toY: item.totalLate.toDouble(),
                            color: const Color(0xFF00E676),
                            width: 12,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                          BarChartRodData(
                            toY: item.totalAbsent.toDouble(),
                            color: Colors.grey,
                            width: 12,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _indicator(const Color(0xFF00D1FF), "On-time"),
                  const SizedBox(width: 15),
                  _indicator(const Color(0xFF00E676), "Late"),
                  const SizedBox(width: 15),
                  _indicator(Colors.grey, "Absent"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _indicator(Color color, String text) => Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}
