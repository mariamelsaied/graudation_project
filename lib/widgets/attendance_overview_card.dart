// import 'package:flutter/material.dart';
// import 'package:graduation_app/core/constants/colors_app.dart';
// import 'package:graduation_app/models/attendance_day_data.dart';

// class AttendanceOverviewCard extends StatelessWidget {
//   const AttendanceOverviewCard({
//     super.key,
//     required this.attendanceFuture,
//     required this.onRetry,
//   });

//   final Future<List<AttendanceDayData>> attendanceFuture;
//   final VoidCallback onRetry;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
//       decoration: BoxDecoration(
//         color: ColorsApp.attendanceCardColor,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Weekly Attendance',
//                       style: TextStyle(
//                         color: ColorsApp.WhiteColor,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       'Check-in / Check-out overview',
//                       style: TextStyle(
//                         color: ColorsApp.greyColor,
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//                LegendDot(label: 'On-time', color: ColorsApp.blueColor),
//                SizedBox(width: 12),
//               LegendDot(label: 'Hours', color: ColorsApp.greenColor),
//             ],
//           ),
//           const SizedBox(height: 14),
//           FutureBuilder<List<AttendanceDayData>>(
//             future: attendanceFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const SizedBox(
//                   height: 190,
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }

//               if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
//                 return SizedBox(
//                   height: 190,
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Could not load attendance data',
//                           style: TextStyle(
//                             color: ColorsApp.WhiteColor,
//                             fontSize: 12,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         TextButton(
//                           onPressed: onRetry,
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }

//               return AttendanceChart(data: snapshot.data!);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AttendanceChart extends StatelessWidget {
//   const AttendanceChart({required this.data});

//   final List<AttendanceDayData> data;

//   @override
//   Widget build(BuildContext context) {
//     const maxValue = 10.0;
//     const chartHeight = 140.0;

//     return SizedBox(
//       height: 190,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           SizedBox(
//             width: 26,
//             height: chartHeight,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: List.generate(
//                 6,
//                 (index) {
//                   final value = 10 - (index * 2);
//                   return Text(
//                     '${value}h',
//                     style: TextStyle(
//                       color: ColorsApp.greyColor,
//                       fontSize: 10,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: data.map((day) {
//                 return Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       SizedBox(
//                         height: chartHeight,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             _Bar(
//                               height: (day.onTime / maxValue) * chartHeight,
//                               color: ColorsApp.blueColor,
//                             ),
//                             const SizedBox(width: 3),
//                             _Bar(
//                               height: (day.hours / maxValue) * chartHeight,
//                               color: ColorsApp.greenColor,
//                             ),
//                             const SizedBox(width: 3),
//                             _Bar(
//                               height: (day.target / maxValue) * chartHeight,
//                               color: ColorsApp.greyColor.withOpacity(0.5),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         day.label,
//                         style: TextStyle(
//                           color: ColorsApp.greyColor,
//                           fontSize: 10,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Bar extends StatelessWidget {
//   const _Bar({required this.height, required this.color});

//   final double height;
//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 14,
//       height: height,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(8),
//       ),
//     );
//   }
// }

// class LegendDot extends StatelessWidget {
//   const LegendDot({required this.label, required this.color});

//   final String label;
//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 6,
//           height: 6,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 4),
//         Text(
//           label,
//           style: TextStyle(
//             color: ColorsApp.greyColor,
//             fontSize: 10,
//           ),
//         ),
//       ],
//     );
//   }
// }
