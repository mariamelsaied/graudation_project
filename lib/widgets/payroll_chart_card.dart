import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PayrollChartCard extends StatelessWidget {
  final List<dynamic> chartData;

  const PayrollChartCard({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF161D2D),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Payroll cost overview",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5,),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 340, 
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: 850, 
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    minY: 0,
                    maxY: _getMaxY(), 
                    barTouchData: _buildBarTouchData(), 
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: _getGridInterval(), 
                      getDrawingHorizontalLine: (v) {
                        return FlLine(
                          color: Colors.white.withOpacity(0.05),
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    titlesData: _buildChartTitles(),
                    borderData: FlBorderData(show: false),
                    barGroups: _buildChartDataGroups(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendCircle(const Color(0xFF00D1FF), "Net Salaries", true),
              const SizedBox(width: 24),
              _buildLegendCircle(Colors.white.withOpacity(0.2), "Deduction", false),
            ],
          ),
        ],
      ),
    );
  }

  BarTouchData _buildBarTouchData() {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        getTooltipColor: (_) => const Color(0xFF0F172A).withOpacity(0.95),
        tooltipPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        tooltipMargin: 8,
        fitInsideHorizontally: true,
        fitInsideVertically: true,   
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          const months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
          ];
          String currentMonth = months[group.x.toInt() % 12];
          
          final monthlyData = _getMonthlyData(group.x.toInt() + 1);
          double net = monthlyData['net']!;
          double ded = monthlyData['ded']!;

          return BarTooltipItem(
            '$currentMonth 2026\n\n', 
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            children: [
              const TextSpan(text: 'Net Salaries  ', style: TextStyle(color: Colors.white60, fontSize: 12)),
              TextSpan(text: '\$${net.toStringAsFixed(2)}\n', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              const TextSpan(text: 'Deduction     ', style: TextStyle(color: Colors.white60, fontSize: 12)),
              TextSpan(text: '\$${ded.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          );
        },
      ),
    );
  }
  Map<String, double> _getMonthlyData(int monthNumber) {
    double netSalary = 0.0;
    double dedSalary = 0.0;

    for (var item in chartData) {
      if (item['month'] == monthNumber) {
        netSalary = (item['netSalaries'] ?? 0).toDouble();
        dedSalary = (item['deductions'] ?? 0).toDouble();
        break;
      }
    }

    return {'net': netSalary, 'ded': dedSalary};
  }
  List<BarChartGroupData> _buildChartDataGroups() {
    return List.generate(12, (i) {
      final monthlyData = _getMonthlyData(i + 1); 
      double netValue = monthlyData['net']!;
      double dedValue = monthlyData['ded']!;

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: netValue,
            width: 28, 
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFF23A6FE), Color(0xFF00D1FF)],
            ),
          ),
          BarChartRodData(
            toY: dedValue,
            width: 28,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.18),
              ],
            ),
          ),
        ],
        barsSpace: 4, 
      );
    });
  }

  double _getMaxY() {
    double maxVal = 5000;
    for (int i = 1; i <= 12; i++) {
      final data = _getMonthlyData(i);
      if (data['net']! > maxVal) maxVal = data['net']!;
      if (data['ded']! > maxVal) maxVal = data['ded']!;
    }
    return maxVal + 3000; 
  }
  double _getGridInterval() {
    return _getMaxY() / 4;
  }
  FlTitlesData _buildChartTitles() {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(),
      topTitles: const AxisTitles(),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 45,
          interval: _getGridInterval(), 
          getTitlesWidget: (v, _) {
            if (v == 0) return const Text('0', style: TextStyle(color: Colors.grey, fontSize: 11));
            return Text('${(v / 1000).toStringAsFixed(0)}k', style: const TextStyle(color: Colors.grey, fontSize: 11));
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (v, _) {
            const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(months[v.toInt() % 12], style: const TextStyle(color: Colors.grey, fontSize: 11)),
            );
          },
        ),
      ),
    );
  }
  Widget _buildLegendCircle(Color c, String label, bool isCircle) {
    return Row(
      children: [
        Container(
          width: 8, 
          height: 8, 
          decoration: BoxDecoration(
            color: c, 
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8), 
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}