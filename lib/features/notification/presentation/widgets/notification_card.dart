import 'package:flutter/material.dart';
import 'package:safenest/features/notification/domain/entity/notification.dart';
import 'package:safenest/core/extensions/context_extensions.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;
  final bool isUnread;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onTap,
    this.isUnread = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor(notification.type);
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Card(
        elevation: 1, // Decreased elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3), // Decreased border radius
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(3), // Match the Card's border radius
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3), // Match the Card's border radius
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.theme.colorScheme.surface,
                  accentColor.withOpacity(0.02), // Decreased opacity for subtlety
                ],
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12), // Slightly reduced padding
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAvatar(accentColor),
                      const SizedBox(width: 12), // Slightly reduced spacing
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15, // Slightly reduced font size
                              ),
                            ),
                            const SizedBox(height: 2), // Reduced spacing
                            Text(
                              notification.description,
                              style: const TextStyle(fontSize: 13), // Slightly reduced font size
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTimestamp(notification.timestamp),
                              style: TextStyle(
                                fontSize: 11, // Slightly reduced font size
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUnread)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 6, // Slightly smaller unread indicator
                      height: 6,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Color accentColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getNotificationIcon(),
        color: accentColor,
        size: 24,
      ),
    );
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case AppNotificationType.info:
        return Icons.info_outline;
      case AppNotificationType.warning:
        return Icons.warning_amber_outlined;
      case AppNotificationType.alert:
        return Icons.error_outline;
    }
  }

  Color _getAccentColor(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.info:
        return Colors.blue;
      case AppNotificationType.warning:
        return Colors.orange;
      case AppNotificationType.alert:
        return Colors.red;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}