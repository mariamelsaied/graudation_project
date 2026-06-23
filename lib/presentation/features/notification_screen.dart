import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_app/cubit/notification_cubit.dart';
import 'package:graduation_app/cubit/notification_state.dart';
import 'package:graduation_app/models/notification_model.dart';
import 'package:intl/intl.dart';
// import 'notification_cubit.dart';
// import 'notification_state.dart';
// import 'notification_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(key) {
    return BlocProvider(
      create: (context) => NotificationCubit()..getNotifications(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notification'),
          centerTitle: true,
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationError) {
              return Center(child: Text(state.errorMessage));
            } else if (state is NotificationSuccess) {
              if (state.notifications.isEmpty) {
                return const Center(child: Text('No Notification Found'));
              }
              return RefreshIndicator(
                onRefresh: () => context.read<NotificationCubit>().getNotifications(),
                child: ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return NotificationCard(notification: notification);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // تنسيق الوقت بشكل بسيط
    final timeStr = notification.createdAt != null 
        ? "${notification.createdAt!.hour}:${notification.createdAt!.minute}" 
        : "";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: notification.isRead ? Colors.white : Colors.blue.withOpacity(0.05), // تمييز المقروء
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: notification.sender?.avatar != null && notification.sender!.avatar.isNotEmpty
              ? NetworkImage(notification.sender!.avatar)
              : const AssetImage('assets/placeholder_avatar.png') as ImageProvider, // صورة افتراضية لو مفيش لينو
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              timeStr,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.message,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              if (notification.sender != null)
                Text(
                  "By: ${notification.sender!.fullName}",
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
        trailing: notification.type == "Leave" 
            ? const Icon(Icons.time_to_leave, color: Colors.orange) 
            : const Icon(Icons.notifications, color: Colors.blue),
      ),
    );
  }
}