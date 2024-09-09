import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/digital_wellbeing/domain/repository/digital_wellbeing_repository.dart';

class RemoveUsageLimitUseCase extends UsecaseWithParams<void, RemoveUsageLimitParams> {
  const RemoveUsageLimitUseCase(this._repository);

  final DigitalWellbeingRepository _repository;

  @override
  ResultVoid call(RemoveUsageLimitParams params) async =>
      _repository.removeUsageLimit(params.childId, params.packageName);
}

class RemoveUsageLimitParams {
  final String childId;
  final String packageName;

  RemoveUsageLimitParams({required this.childId, required this.packageName});
}