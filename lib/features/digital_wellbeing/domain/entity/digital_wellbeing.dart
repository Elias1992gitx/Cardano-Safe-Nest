import 'package:equatable/equatable.dart';

class DigitalWellbeing extends Equatable {
  const DigitalWellbeing({
    required this.childId,
    required this.appUsages,
    required this.totalScreenTime,
    required this.date,
    required this.history,
    this.usageLimits,
  });

  final String childId;
  final Map<String, AppUsage> appUsages;
  final Duration totalScreenTime;
  final DateTime date;
  final Map<String, UsageLimit>? usageLimits;
  final List<DigitalWellbeing> history;

  @override
  List<Object?> get props => [
    childId,
    appUsages,
    totalScreenTime,
    history,
    date,
    usageLimits,
  ];
}

class AppUsage {
  final String packageName;
  final String appName;
  final Duration usageTime;
  final int openCount;

  AppUsage({
    required this.packageName,
    required this.appName,
    required this.usageTime,
    required this.openCount,
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