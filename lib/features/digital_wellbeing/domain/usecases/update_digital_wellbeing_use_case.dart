import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/digital_wellbeing/domain/repository/digital_wellbeing_repository.dart';

class UpdateDigitalWellbeingUseCase extends UsecaseWithParams<void, DigitalWellbeing> {
  const UpdateDigitalWellbeingUseCase(this._repository);

  final DigitalWellbeingRepository _repository;

  @override
  ResultVoid call(DigitalWellbeing params) async => _repository.updateDigitalWellbeing(params);
}