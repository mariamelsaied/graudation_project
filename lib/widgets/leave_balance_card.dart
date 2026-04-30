import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class LeaveBalanceCard extends StatelessWidget {
  final String title;
  final String days;
  final IconData icon;

  const LeaveBalanceCard({
    super.key,
    required this.title,
    required this.days,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsApp.secondaryblueColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: ColorsApp.blueColor, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: ColorsApp.blueColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: days,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " Days",
                  style: TextStyle(color: ColorsApp.greyColor, fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            "Remaining Balance",
            style: TextStyle(
              color: ColorsApp.greyColor.withOpacity(0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
