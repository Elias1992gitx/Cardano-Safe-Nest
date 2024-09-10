import 'package:equatable/equatable.dart';

class NotificationPreferences extends Equatable {
  final bool dailySummary;
  final bool usageLimitExceeded;
  final bool screenTimeThreshold;
  final Duration screenTimeThresholdDuration;

  const NotificationPreferences({
    required this.dailySummary,
    required this.usageLimitExceeded,
    required this.screenTimeThreshold,
    required this.screenTimeThresholdDuration,
  });

  @override
  List<Object?> get props => [
    dailySummary,
    usageLimitExceeded,
    screenTimeThreshold,
    screenTimeThresholdDuration,
  ];
}