import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';

class TaskCardState extends StatelessWidget {
  const TaskCardState({
    super.key,
    required this.title,
    required this.value,
    required this.trendText,
    required this.trendColor,
    required this.trendIcon,
  });

  final String title;
  final String value;
  final String trendText;
  final Color trendColor;
  final IconData trendIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ColorsApp.darknavyblueColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorsApp.darkblueColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(color: ColorsApp.lightgreyColor, fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: ColorsApp.WhiteColor,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(trendIcon, size: 14, color: trendColor),
              SizedBox(width: 3,),
              Text(
                trendText,
                style: TextStyle(color: trendColor, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
