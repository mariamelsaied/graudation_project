import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:graduation_app/core/constants/colors_app.dart';
import 'package:graduation_app/widgets/item_card.dart';
import 'package:graduation_app/widgets/main_layout.dart';
import 'package:graduation_app/widgets/request_item.dart';
import 'package:graduation_app/widgets/task_item.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<double> weeklyHours = [8, 7.5, 9, 8.5, 7];

  DateTime? rangeStart;
  DateTime? rangeEnd;
  DateTime focusedDay = DateTime.now();

  String formatMonthYear(DateTime date) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${months[date.month - 1]} ${date.year}";
  }

  void showCalendar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorsApp.calenderColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ColorsApp.WhiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    "Select Range",
                    style: TextStyle(
                      color: ColorsApp.WhiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),
                  Flexible(
                    child: SingleChildScrollView(
                      child: TableCalendar(
                        firstDay: DateTime(2020),
                        lastDay: DateTime(2030),
                        focusedDay: focusedDay,
                        rangeStartDay: rangeStart,
                        rangeEndDay: rangeEnd,
                        calendarFormat: CalendarFormat.month,
                        rangeSelectionMode: RangeSelectionMode.toggledOn,
                        rowHeight: 45,
                        daysOfWeekHeight: 30,
                        calendarStyle: CalendarStyle(
                          weekendTextStyle: TextStyle(
                            color: ColorsApp.WhiteColor,
                            fontSize: 14,
                          ),
                          defaultTextStyle: TextStyle(
                            color: ColorsApp.WhiteColor,
                            fontSize: 14,
                          ),
                          rangeHighlightColor: ColorsApp.blueColor.withOpacity(
                            0.2,
                          ),
                          rangeStartDecoration: BoxDecoration(
                            color: ColorsApp.blueColor,
                            shape: BoxShape.circle,
                          ),
                          rangeEndDecoration: BoxDecoration(
                            color: ColorsApp.blueColor,
                            shape: BoxShape.circle,
                          ),
                          withinRangeTextStyle: TextStyle(
                            color: ColorsApp.WhiteColor,
                          ),
                          outsideTextStyle: TextStyle(
                            color: ColorsApp.WhiteColor,
                          ),
                          outsideDaysVisible: false,
                        ),

                        headerStyle: HeaderStyle(
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            color: ColorsApp.WhiteColor,
                            fontSize: 16,
                          ),
                          formatButtonVisible: false,
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: ColorsApp.WhiteColor,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: ColorsApp.WhiteColor,
                          ),
                        ),

                        onRangeSelected: (start, end, focused) {
                          setState(() {
                            rangeStart = start;
                            rangeEnd = end;
                            focusedDay = focused;
                          });
                          setStateModal(() {});
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsApp.blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Confirm Selection",
                        style: TextStyle(color: ColorsApp.WhiteColor),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Dashboard',
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello!", style: TextStyle(color: ColorsApp.greyColor)),
                SizedBox(height: 10),
                Text(
                  'Jones Hawkins',
                  style: TextStyle(
                    color: ColorsApp.WhiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: showCalendar,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ColorsApp.greyColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 18,
                          color: ColorsApp.WhiteColor,
                        ),
                        SizedBox(width: 6),
                        Text(
                          rangeStart == null
                              ? "Select Date Range"
                              : rangeEnd == null
                              ? formatMonthYear(rangeStart!)
                              : "${formatMonthYear(rangeStart!)} - ${formatMonthYear(rangeEnd!)}",
                          style: TextStyle(color: ColorsApp.WhiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmall = constraints.maxWidth < 360;
                    return GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: isSmall ? 1 : 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: isSmall ? 1.6 : 1.3,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        itemCard(
                          "Today's Status",
                          "On Time",
                          "Checked in at 09:02 AM",
                          ColorsApp.blueColor,
                          Image.asset('assets/images/time.png'),
                        ),
                        itemCard(
                          "Leave Balance",
                          "12 Days",
                          "Annual Leave Quota",
                          ColorsApp.purpleColor,
                          Image.asset("assets/images/umberella.png"),
                        ),
                        itemCard(
                          "Active Tasks",
                          "05",
                          "High Priority",
                          ColorsApp.orangeColor,
                          Image.asset('assets/images/report.png'),
                        ),
                        itemCard(
                          "Pending Requests",
                          "02",
                          "Waiting approval",
                          ColorsApp.pinkColor,
                          Image.asset('assets/images/request.png'),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorsApp.darknavyblueColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Attendance',
                        style: TextStyle(
                          color: ColorsApp.WhiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Check-in / Check-out Overview",
                        style: TextStyle(
                          color: ColorsApp.greyColor,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 14),
                      SizedBox(
                        height: 220,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: BarChart(
                            BarChartData(
                              maxY: 10,
                              barTouchData: BarTouchData(enabled: false),
                              gridData: FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    interval: 2,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt()}h',
                                        style: TextStyle(
                                          color: ColorsApp.greyColor,
                                          fontSize: 11,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const days = [
                                        'Mon',
                                        'Tue',
                                        'Wed',
                                        'Thu',
                                        'Fri',
                                      ];
                                      final index = value.toInt();
                                      if (index < 0 || index >= days.length) {
                                        return const SizedBox.shrink();
                                      }
                                      return Text(
                                        days[index],
                                        style: TextStyle(
                                          color: ColorsApp.greyColor,
                                          fontSize: 11,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              barGroups: List.generate(weeklyHours.length, (
                                index,
                              ) {
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: weeklyHours[index],
                                      width: 16,
                                      borderRadius: BorderRadius.circular(6),
                                      color: ColorsApp.blueColor,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorsApp.darknavyblueColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Tasks',
                            style: TextStyle(
                              color: ColorsApp.WhiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: ColorsApp.blueColor,
                                fontSize: 10,
                              ),
                            ),
                          ), //My Tasks screen
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            buildTaskItem(
                              title: 'Prototyping',
                              status: 'HIGH',
                              statusColor: ColorsApp.orangeColor,
                              desc:
                                  'Create wireframes for mobile app dashboard redesign.',
                              days: '2 days left',
                              progress: 0.8,
                              progressColor: ColorsApp.blueColor,
                            ),
                            SizedBox(width: 10),
                            buildTaskItem(
                              title: 'Asset Export',
                              status: 'Normal',
                              statusColor: ColorsApp.greenColor,
                              desc:
                                  'Prepare assets for development handoff meeting.',
                              days: '5 days left',
                              progress: 0.3,
                              progressColor: ColorsApp.purpleColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorsApp.darknavyblueColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent Requests",
                            style: TextStyle(
                              color: ColorsApp.WhiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "View All",
                              style: TextStyle(
                                color: ColorsApp.blueColor,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      RequestItem(
                        bgColor: ColorsApp.orangeColor,
                        statusColor: ColorsApp.yellowColor,
                        status: "Pending",
                        date: "Oct 24, 2025",
                        title: "Sick Leave",
                        image: Image.asset("assets/images/sick.png"),
                      ),
                      SizedBox(height: 16),
                      RequestItem(
                        bgColor: ColorsApp.blueColor,
                        statusColor: ColorsApp.greenColor,
                        status: 'Approved',
                        date: 'Oct 20, 2025',
                        title: 'Wi-Fi Request',
                        image: Image.asset("assets/images/Icon.png"),
                      ),
                      SizedBox(height: 16),
                      RequestItem(
                        bgColor: ColorsApp.purpleColor,
                        statusColor: ColorsApp.redColor,
                        status: 'Rejected',
                        date: 'Oct 15, 2025',
                        title: 'New Equipment',
                        image: Image.asset("assets/images/equipment2.png"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
