import 'package:flutter/material.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/widgets/main_layout.dart';
import 'package:graduation_app/widgets/task_card.dart';
import 'package:graduation_app/widgets/task_card_state.dart';
import 'package:graduation_app/widgets/text_form_feild.dart';

class MyTasksScreen extends StatelessWidget {
  const MyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'My Tasks',
      child: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  TaskCardState(
                    title: "Due Today",
                    value: '3',
                    trendText: "+1 new",
                    trendColor: ColorsApp.greenColor,
                    trendIcon: Icons.trending_up,
                  ),
                  SizedBox(width: 10),
                  TaskCardState(
                    title: "Pending Review",
                    value: '5',
                    trendText: "Steady",
                    trendColor: ColorsApp.greyColor,
                    trendIcon: Icons.remove,
                  ),
                  SizedBox(width: 10),
                  TaskCardState(
                    title: 'Completed',
                    value: '12',
                    trendText: "+4 this Week",
                    trendColor: ColorsApp.greenColor,
                    trendIcon: Icons.add,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextFormFeild(text: 'Search Tasks...'),
            ),
            SizedBox(height: 5,),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 5,left: 16,right: 16,bottom: 5),
                children: [
                  TaskCard(title: "Prepare Q3 Review Slides", statusTask: 'IN PROGRESS', priority: "HIGH PRIORITY", date: "Oct 24, 2023", dataIcon: Icons.calendar_today_outlined, statusColor: ColorsApp.blueColor, priorityColor: ColorsApp.redColor, isCompleted: false),
                  TaskCard(title: "Update Employee Handbook", statusTask: "PENDING", priority: "MEDIUM PRIORITY", date: "Oct 28, 2023", dataIcon: Icons.calendar_today_outlined, statusColor: ColorsApp.yellowColor, priorityColor: ColorsApp.orangeColor, isCompleted: false),
                  TaskCard(title: "Review Q4 Hiring Plan", statusTask: "PENDING", priority: "HIGH PRIORITY", date: "Today", dataIcon: Icons.access_time, statusColor: ColorsApp.yellowColor, priorityColor: ColorsApp.redColor, isCompleted: false),
                  TaskCard(title: "Onboard New Designer", statusTask: 'COMPLETED', priority: "LOW PRIORITY", date: 'Done', dataIcon: Icons.check_circle_outline, statusColor: ColorsApp.greenColor, priorityColor: ColorsApp.greyColor, isCompleted: true)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
