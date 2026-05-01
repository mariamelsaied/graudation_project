// import 'dart:convert';
// import 'dart:io';

// import 'package:graduation_app/models/attendance_day_data.dart';

// class AttendanceService {
//   const AttendanceService();

//   Future<List<AttendanceDayData>> fetchWeeklyAttendance() async {
//     final uri = Uri.parse(
//       'https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=usd&days=7&interval=daily',
//     );

//     final client = HttpClient();
//     try {
//       final request = await client.getUrl(uri);
//       request.headers.set(HttpHeaders.acceptHeader, 'application/json');

//       final response = await request.close();
//       if (response.statusCode != HttpStatus.ok) {
//         throw Exception('Failed to load attendance data');
//       }

//       final raw = await response.transform(utf8.decoder).join();
//       final decoded = jsonDecode(raw) as Map<String, dynamic>;

//       final prices = (decoded['prices'] as List<dynamic>?) ?? <dynamic>[];
//       final volumes = (decoded['total_volumes'] as List<dynamic>?) ?? <dynamic>[];

//       if (prices.isEmpty || volumes.isEmpty) {
//         throw Exception('No data available');
//       }

//       final length = prices.length < volumes.length ? prices.length : volumes.length;
//       final start = length > 6 ? length - 6 : 0;

//       final selectedPrices = prices.sublist(start, length);
//       final selectedVolumes = volumes.sublist(start, length);

//       final priceValues = selectedPrices
//           .map((e) => (e as List<dynamic>)[1] as num)
//           .map((e) => e.toDouble())
//           .toList();

//       final volumeValues = selectedVolumes
//           .map((e) => (e as List<dynamic>)[1] as num)
//           .map((e) => e.toDouble())
//           .toList();

//       final result = <AttendanceDayData>[];
//       for (var i = 0; i < selectedPrices.length; i++) {
//         final timestamp = (selectedPrices[i] as List<dynamic>)[0] as num;
//         final date = DateTime.fromMillisecondsSinceEpoch(
//           timestamp.toInt(),
//           isUtc: true,
//         ).toLocal();

//         final onTime = _normalize(priceValues[i], priceValues, min: 2, max: 10);
//         final hours = _normalize(volumeValues[i], volumeValues, min: 2, max: 10);

//         result.add(
//           AttendanceDayData(
//             label: '${_weekdayShort(date.weekday)} ${date.day}',
//             onTime: onTime,
//             hours: hours,
//             target: ((onTime + hours) / 2).clamp(2, 10),
//           ),
//         );
//       }

//       return result;
//     } finally {
//       client.close();
//     }
//   }

//   double _normalize(double value, List<double> values, {double min = 0, double max = 10}) {
//     final minValue = values.reduce((a, b) => a < b ? a : b);
//     final maxValue = values.reduce((a, b) => a > b ? a : b);

//     if ((maxValue - minValue).abs() < 0.0001) {
//       return (min + max) / 2;
//     }

//     final normalized = (value - minValue) / (maxValue - minValue);
//     return min + normalized * (max - min);
//   }

//   String _weekdayShort(int weekday) {
//     switch (weekday) {
//       case DateTime.monday:
//         return 'Mon';
//       case DateTime.tuesday:
//         return 'Tue';
//       case DateTime.wednesday:
//         return 'Wed';
//       case DateTime.thursday:
//         return 'Thu';
//       case DateTime.friday:
//         return 'Fri';
//       case DateTime.saturday:
//         return 'Sat';
//       case DateTime.sunday:
//         return 'Sun';
//       default:
//         return '';
//     }
//   }
// }
