import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:graduation_app/widgets/main_layout.dart';
import 'package:graduation_app/widgets/payroll_stats_card.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Payroll',
      child: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  PayrollStatsCard(title: "Basic Salary", amount: "20000"),
                  SizedBox(width: 12),
                  PayrollStatsCard(title: "Bonuses", amount: "5000"),
                  SizedBox(width: 12),
                  PayrollStatsCard(title: "Deductions", amount: "2000"),
                  SizedBox(width: 12),
                  PayrollStatsCard(title: "Net Salary", amount: "3000"),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF141A21),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///////////////
                ],
              ),
              
            ),
          ],
        ),
      ),
      
    );

    
  }
}
