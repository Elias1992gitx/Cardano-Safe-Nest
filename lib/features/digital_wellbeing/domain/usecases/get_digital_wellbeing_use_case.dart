import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/digital_wellbeing/domain/repository/digital_wellbeing_repository.dart';

class GetDigitalWellbeingUseCase extends UsecaseWithParams<DigitalWellbeing, String> {
  const GetDigitalWellbeingUseCase(this._repository);

  final DigitalWellbeingRepository _repository;

  @override
  ResultFuture<DigitalWellbeing> call(String params) async => _repository.getDigitalWellbeing(params);
}