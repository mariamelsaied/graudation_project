 import 'package:flutter/material.dart';
import '../core/constants/colors_app.dart';

class TaskStateCardWidget extends StatelessWidget {
  final String title;
  final String statusText;
  final Color statusColor;
  final Color statusBgColor;
  final String priorityText;
  final Color priorityColor;
  final Color priorityBgColor;
  final String dateOrStatus;
  final IconData icon;
  final Color? dateColor;
  final bool hasAvatar;
  final bool isCompleted;

  const TaskStateCardWidget({
    Key? key,
    required this.title,
    required this.statusText,
    required this.statusColor,
    required this.statusBgColor,
    required this.priorityText,
    required this.priorityColor,
    required this.priorityBgColor,
    required this.dateOrStatus,
    required this.icon,
    this.dateColor,
    this.hasAvatar = false,
    this.isCompleted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ColorsApp.pimaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color:
                        isCompleted
                            ? ColorsApp.greyColor
                            : ColorsApp.WhiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: priorityBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  priorityText,
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: dateColor ?? ColorsApp.greyColor, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    dateOrStatus,
                    style: TextStyle(
                      color: dateColor ?? ColorsApp.greyColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}