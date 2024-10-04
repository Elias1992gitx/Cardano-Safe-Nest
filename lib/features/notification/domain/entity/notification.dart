import 'package:equatable/equatable.dart';

enum AppNotificationType { info, warning, alert }

class AppNotification extends Equatable {
  final String id;
  final String title;
  final String description;
  final AppNotificationType type;
  final DateTime timestamp;

  const AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, title, description, type, timestamp];
}