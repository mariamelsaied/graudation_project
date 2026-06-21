import 'package:flutter/material.dart';
import 'leave_balance_card.dart';

class LeaveBalanceList extends StatelessWidget {
  final Map<String, dynamic> balanceData;

  const LeaveBalanceList({
    super.key,
    required this.balanceData,
  });

  @override
  Widget build(BuildContext context) {
    final String annualDays = (balanceData['annual'] ?? 0).toString();
    final String sickDays = (balanceData['sick'] ?? 0).toString();
    final String casualDays = (balanceData['casual'] ?? 0).toString();

    return SizedBox(
      height: 135,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), 
        children: [
          LeaveBalanceCard(
            title: "ANNUAL",
            days: annualDays.padLeft(2, '0'), 
            icon: Icons.calendar_today_outlined,
          ),
          const SizedBox(width: 12),
          LeaveBalanceCard(
            title: "SICK",
            days: sickDays.padLeft(2, '0'),
            icon: Icons.sick_outlined, 
          ),
          const SizedBox(width: 12),
          LeaveBalanceCard(
            title: "CASUAL",
            days: casualDays.padLeft(2, '0'),
            icon: Icons.person_outline,
          ),
          
        ],
      ),
    );
  }
}