import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/notification/data/model/child_task_model.dart';
import 'package:safenest/features/notification/data/model/notification_preference_model.dart';

abstract class DigitalWellbeingRepository {
  ResultFuture<DigitalWellbeing> getDigitalWellbeing(String childId);
  ResultVoid updateDigitalWellbeing(DigitalWellbeing digitalWellbeing);
  ResultVoid setUsageLimit(String childId, String packageName, UsageLimit limit);
  ResultVoid removeUsageLimit(String childId, String packageName);
  ResultFuture<List<DigitalWellbeing>> getDigitalWellbeingHistory(String childId, DateTime startDate, DateTime endDate);
  ResultVoid setNotificationPreferences(String childId, NotificationPreferencesModel preferences);
  ResultVoid addChildTask(String childId, ChildTaskModel task);
  ResultVoid updateChildTask(String childId, ChildTaskModel task);
  ResultVoid removeChildTask(String childId, String taskId);
  ResultVoid cleanOldData();
}