import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';

Widget buildTaskItem({
    required String title,
    required String status,
    required Color statusColor,
    required String desc,
    required String days,
    required double progress,
    required Color progressColor,
  }) {
    return Container(
      width: 260, 
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsApp.greyColor.withOpacity(0.15), 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style:  TextStyle(color:ColorsApp.WhiteColor, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(desc, style: TextStyle(color: ColorsApp.greyColor, fontSize: 11)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Icon(Icons.account_circle, color: ColorsApp.greyColor, size: 20),
              Text(days, style:  TextStyle(color: ColorsApp.greyColor, fontSize: 10)),
            ],
          ),
           SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: ColorsApp.darkGreyColor,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }