import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:safenest/features/notification/data/model/child_task_model.dart';
import 'package:safenest/features/notification/data/model/notification_preference_model.dart';
import 'package:safenest/features/notification/domain/entity/child_task.dart';
import 'package:safenest/features/notification/domain/entity/notification_preference.dart';

class DigitalWellbeing extends Equatable {
  const DigitalWellbeing({
    required this.childId,
    required this.appUsages,
    required this.totalScreenTime,
    required this.date,
    required this.history,
    this.usageLimits,
    required this.notificationPreferences,
    required this.childTasks,
  });

  final String childId;
  final Map<String, AppUsage> appUsages;
  final Duration totalScreenTime;
  final DateTime date;
  final Map<String, UsageLimit>? usageLimits;
  final List<DigitalWellbeing> history;
  final NotificationPreferencesModel notificationPreferences;
  final List<ChildTaskModel> childTasks;

  @override
  List<Object?> get props => [
    childId,
    appUsages,
    totalScreenTime,
    history,
    date,
    usageLimits,
    notificationPreferences,
    childTasks,
  ];
}

class AppUsage {
  final String packageName;
  final String appName;
  final Duration usageTime;
  final int openCount;
  final Uint8List? iconData;

  AppUsage({
    required this.packageName,
    required this.appName,
    required this.usageTime,
    required this.openCount,
    this.iconData,
  });
}

class UsageLimit {
  final String packageName;
  final Duration dailyLimit;
  final bool isEnabled;

  UsageLimit({
    required this.packageName,
    required this.dailyLimit,
    required this.isEnabled,
  });
}