import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.statusTask,
    required this.priority,
    required this.date,
    required this.dataIcon,
    required this.statusColor,
    required this.priorityColor,
    required this.isCompleted,
  });

  final String title;
  final String statusTask;
  final String priority;
  final String date;
  final IconData dataIcon;
  final Color statusColor;
  final Color priorityColor;
  final bool isCompleted;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsApp.darknavyblueColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorsApp.WhiteColor.withOpacity(0.05)),
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
                    color: isCompleted
                        ? ColorsApp.greyColor
                        : ColorsApp.WhiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Icon(Icons.more_vert, color: ColorsApp.greyColor),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              buildTag(statusTask, statusColor.withOpacity(0.15), statusColor),
              SizedBox(width: 8),
              buildTag(
                priority,
                priorityColor.withOpacity(0.15),
                priorityColor,
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(dataIcon,size: 16,color: isCompleted? ColorsApp.greenColor: ColorsApp.greyColor,),
                  SizedBox(width: 4,),
                  Text(date,style: TextStyle(color: ColorsApp.greyColor,fontSize: 13),)
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
