import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/notification/domain/entity/notification_preference.dart';

class NotificationPreferencesModel extends NotificationPreferences {
  const NotificationPreferencesModel({
    required super.dailySummary,
    required super.usageLimitExceeded,
    required super.screenTimeThreshold,
    required super.screenTimeThresholdDuration,
  });

  NotificationPreferencesModel.fromMap(DataMap map)
      : super(
    dailySummary: map['dailySummary'] as bool,
    usageLimitExceeded: map['usageLimitExceeded'] as bool,
    screenTimeThreshold: map['screenTimeThreshold'] as bool,
    screenTimeThresholdDuration: Duration(milliseconds: map['screenTimeThresholdDuration'] as int),
  );

  DataMap toMap() {
    return {
      'dailySummary': dailySummary,
      'usageLimitExceeded': usageLimitExceeded,
      'screenTimeThreshold': screenTimeThreshold,
      'screenTimeThresholdDuration': screenTimeThresholdDuration.inMilliseconds,
    };
  }

  factory NotificationPreferencesModel.fromEntity(NotificationPreferences entity) {
    return NotificationPreferencesModel(
      dailySummary: entity.dailySummary,
      usageLimitExceeded: entity.usageLimitExceeded,
      screenTimeThreshold: entity.screenTimeThreshold,
      screenTimeThresholdDuration: entity.screenTimeThresholdDuration,
    );
  }
}