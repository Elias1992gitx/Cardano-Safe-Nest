import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/digital_wellbeing/domain/repository/digital_wellbeing_repository.dart';

class CleanOldDataUseCase extends UsecaseWithoutParams<void> {
  const CleanOldDataUseCase(this._repository);

  final DigitalWellbeingRepository _repository;

  @override
  ResultVoid call() async => _repository.cleanOldData();
}