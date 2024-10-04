import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:safenest/features/notification/domain/entity/notification.dart';
import 'package:safenest/features/notification/presentation/widgets/notification_card.dart';

class NotificationList extends StatelessWidget {
  final List<AppNotification> notifications;
  final Function(AppNotification) onNotificationTap;
  final Function(AppNotification) onNotificationDismiss;

  const NotificationList({
    super.key,
    required this.notifications,
    required this.onNotificationTap,
    required this.onNotificationDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(
                onDismissed: () => onNotificationDismiss(notification),
              ),
              children: [
                SlidableAction(
                  onPressed: (_) => onNotificationDismiss(notification),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: NotificationCard(
              notification: notification,
              onTap: () => onNotificationTap(notification),
              isUnread: index % 2 == 0, // Example: every other notification is unread
            ),
          ),
        );
      },
    );
  }

}