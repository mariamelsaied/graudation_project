import 'package:graduation_app/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {
  final List<NotificationItem> notifications;
  final int unreadCount;

  NotificationSuccess({
    required this.notifications, 
    required this.unreadCount,
  });
}

class NotificationError extends NotificationState {
  final String errorMessage;
  NotificationError(this.errorMessage);
}