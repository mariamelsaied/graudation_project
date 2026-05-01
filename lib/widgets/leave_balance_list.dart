import 'package:flutter/material.dart';
import 'leave_balance_card.dart';

class LeaveBalanceList extends StatelessWidget {
  const LeaveBalanceList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          LeaveBalanceCard(
            title: "ANNUAL",
            days: "12",
            icon: Icons.calendar_today_outlined,
          ),
          SizedBox(width: 12),
          LeaveBalanceCard(
            title: "SICK",
            days: "05",
            icon: Icons.shopping_bag_outlined,
          ),
          SizedBox(width: 12),
          LeaveBalanceCard(
            title: "PERSONAL",
            days: "03",
            icon: Icons.person_outline,
          ),
        ],
      ),
    );
  }
}
