import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/digital_wellbeing/domain/repository/digital_wellbeing_repository.dart';

class GetDigitalWellbeingHistoryUseCase extends UsecaseWithParams<List<DigitalWellbeing>, GetDigitalWellbeingHistoryParams> {
  const GetDigitalWellbeingHistoryUseCase(this._repository);

  final DigitalWellbeingRepository _repository;

  @override
  ResultFuture<List<DigitalWellbeing>> call(GetDigitalWellbeingHistoryParams params) async =>
      _repository.getDigitalWellbeingHistory(params.childId, params.startDate, params.endDate);
}

class GetDigitalWellbeingHistoryParams {
  final String childId;
  final DateTime startDate;
  final DateTime endDate;

  const GetDigitalWellbeingHistoryParams({
    required this.childId,
    required this.startDate,
    required this.endDate,
  });
}