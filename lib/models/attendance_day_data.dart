class AttendanceDayData {
  const AttendanceDayData({
    required this.label,
    required this.onTime,
    required this.hours,
    required this.target,
  });

  final String label;
  final double onTime;
  final double hours;
  final double target;
}
