import 'dart:io';
import 'package:app_usage/app_usage.dart' as app_usage_package;
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/digital_wellbeing/data/model/digital_wellbeing_model.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/notification/data/model/notification_preference_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class DigitalWellbeingLocalDataSource {
  Future<DigitalWellbeingModel> getCurrentUserDigitalWellbeing();
  Future<void> saveCurrentUserDigitalWellbeing(
      DigitalWellbeingModel digitalWellbeing);
  Future<List<DigitalWellbeingModel>> getDigitalWellbeingHistory(
      DateTime startDate, DateTime endDate);
  Future<void> setUsageLimit(String packageName, UsageLimitModel limit);  Future<void> removeUsageLimit(String packageName);
  Future<Map<String, UsageLimitModel>> getUsageLimits();
  }

class DigitalWellbeingLocalDataSourceImpl
    implements DigitalWellbeingLocalDataSource {
  final SharedPreferences sharedPreferences;

  DigitalWellbeingLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<DigitalWellbeingModel> getCurrentUserDigitalWellbeing() async {
    if (Platform.isAndroid) {
      try {
        final endDate = DateTime.now();
        final startDate = endDate.subtract(const Duration(days: 1));

        final usageStats =
            await app_usage_package.AppUsage().getAppUsage(startDate, endDate);

        final appUsages = <String, AppUsage>{};
        for (var stat in usageStats) {
          appUsages[stat.packageName] = AppUsage(
            packageName: stat.packageName,
            appName: stat.appName,
            usageTime: stat.usage,
            openCount: 0, // AppUsage package doesn't provide open count
          );
        }

        final totalScreenTime = usageStats.fold<Duration>(
          Duration.zero,
          (total, stat) => total + stat.usage,
        );

        final usageLimits = await getUsageLimits();

        final digitalWellbeing = DigitalWellbeingModel(
          childId: 'current_user',
          appUsages: appUsages,
          totalScreenTime: totalScreenTime,
          date: endDate,
          usageLimits: usageLimits,
          history: await getDigitalWellbeingHistory(startDate, endDate),
          notificationPreferences: NotificationPreferencesModel.empty(),
          childTasks: [],
        );

        await saveCurrentUserDigitalWellbeing(digitalWellbeing);

        return digitalWellbeing;
      } catch (e) {
        throw Exception('Failed to get app usage: $e');
      }
    } else if (Platform.isIOS) {
      // iOS implementation
      throw UnimplementedError('iOS app usage tracking not implemented');
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  @override
  Future<void> saveCurrentUserDigitalWellbeing(
      DigitalWellbeingModel digitalWellbeing) async {
    final jsonString = json.encode(digitalWellbeing.toMap());
    await sharedPreferences.setString(
        'current_user_digital_wellbeing', jsonString);

    final historyKey =
        'digital_wellbeing_history_${digitalWellbeing.date.toIso8601String().split('T')[0]}';
    await sharedPreferences.setString(historyKey, jsonString);
  }

  @override
  Future<List<DigitalWellbeingModel>> getDigitalWellbeingHistory(
      DateTime startDate, DateTime endDate) async {
    final history = <DigitalWellbeingModel>[];
    for (var date = startDate;
        date.isBefore(endDate.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      final historyKey =
          'digital_wellbeing_history_${date.toIso8601String().split('T')[0]}';
      final jsonString = sharedPreferences.getString(historyKey);
      if (jsonString != null) {
        history.add(DigitalWellbeingModel.fromMap(json.decode(jsonString)));
      }
    }
    return history;
  }

  @override
  Future<void> setUsageLimit(String packageName, UsageLimitModel limit) async {
    final limits = await getUsageLimits();
    limits[packageName] = limit;
    await sharedPreferences.setString('usage_limits',
        json.encode(limits.map((key, value) => MapEntry(key, value.toMap()))));
  }

  @override
  Future<void> removeUsageLimit(String packageName) async {
    final limits = await getUsageLimits();
    limits.remove(packageName);
    await sharedPreferences.setString('usage_limits',
        json.encode(limits.map((key, value) => MapEntry(key, value.toMap()))));
  }

  @override
  Future<Map<String, UsageLimitModel>> getUsageLimits() async {
    final jsonString = sharedPreferences.getString('usage_limits');
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return jsonMap
          .map((key, value) => MapEntry(key, UsageLimitModel.fromMap(value)));
    }
    return {};
  }
}
