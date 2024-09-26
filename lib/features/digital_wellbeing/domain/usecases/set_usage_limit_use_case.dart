import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/digital_wellbeing/domain/repository/digital_wellbeing_repository.dart';

class SetUsageLimitUseCase extends UsecaseWithParams<void, SetUsageLimitParams> {
  const SetUsageLimitUseCase(this._repository);

  final DigitalWellbeingRepository _repository;

  @override
  ResultVoid call(SetUsageLimitParams params) async => _repository.setUsageLimit(
    params.childId,
    params.packageName,
    params.limit,
  );
}

class SetUsageLimitParams {
  final String childId;
  final String packageName;
  final UsageLimit limit;

  SetUsageLimitParams({
    required this.childId,
    required this.packageName,
    required this.limit,
  });
}