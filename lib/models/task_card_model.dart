class TaskCardModel {
  final String title;
  final String description;
  final String status;
  final double progress;
  final String daysLeft;

  TaskCardModel({
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    required this.daysLeft,
  });
}