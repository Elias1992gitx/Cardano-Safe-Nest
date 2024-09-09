import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';

class DigitalWellbeingModel extends DigitalWellbeing {
  const DigitalWellbeingModel({
    required super.childId,
    required super.appUsages,
    required super.totalScreenTime,
    required super.date,
    super.usageLimits,
  });

  DigitalWellbeingModel.fromMap(DataMap map)
      : super(
    childId: map['childId'] as String,
    appUsages: (map['appUsages'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
        key,
        AppUsage(
          packageName: value['packageName'] as String,
          appName: value['appName'] as String,
          usageTime: Duration(milliseconds: value['usageTime'] as int),
          openCount: value['openCount'] as int,
        ),
      ),
    ),
    totalScreenTime: Duration(milliseconds: map['totalScreenTime'] as int),
    date: DateTime.parse(map['date'] as String),
    usageLimits: map['usageLimits'] != null
        ? (map['usageLimits'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
        key,
        UsageLimit(
          packageName: value['packageName'] as String,
          dailyLimit: Duration(milliseconds: value['dailyLimit'] as int),
          isEnabled: value['isEnabled'] as bool,
        ),
      ),
    )
        : null,
  );

  DataMap toMap() {
    return {
      'childId': childId,
      'appUsages': appUsages.map(
            (key, value) => MapEntry(
          key,
          {
            'packageName': value.packageName,
            'appName': value.appName,
            'usageTime': value.usageTime.inMilliseconds,
            'openCount': value.openCount,
          },
        ),
      ),
      'totalScreenTime': totalScreenTime.inMilliseconds,
      'date': date.toIso8601String(),
      'usageLimits': usageLimits?.map(
            (key, value) => MapEntry(
          key,
          {
            'packageName': value.packageName,
            'dailyLimit': value.dailyLimit.inMilliseconds,
            'isEnabled': value.isEnabled,
          },
        ),
      ),
    };
  }

  factory DigitalWellbeingModel.fromEntity(DigitalWellbeing entity) {
    return DigitalWellbeingModel(
      childId: entity.childId,
      appUsages: entity.appUsages,
      totalScreenTime: entity.totalScreenTime,
      date: entity.date,
      usageLimits: entity.usageLimits,
    );
  }
}