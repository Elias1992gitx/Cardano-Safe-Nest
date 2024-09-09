import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';

abstract class DigitalWellbeingRepository {
  ResultFuture<DigitalWellbeing> getDigitalWellbeing(String childId);
  ResultVoid updateDigitalWellbeing(DigitalWellbeing digitalWellbeing);
  ResultVoid setUsageLimit(String childId, String packageName, UsageLimit limit);
  ResultVoid removeUsageLimit(String childId, String packageName);
  ResultFuture<List<DigitalWellbeing>> getDigitalWellbeingHistory(String childId, DateTime startDate, DateTime endDate);
  ResultVoid cleanOldData();
}