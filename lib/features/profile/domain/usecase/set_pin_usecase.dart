import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/profile/domain/repos/parental_info_repository.dart';

class SetPinUseCase extends UsecaseWithParams<void, String> {
  const SetPinUseCase(this._repository);

  final ParentalInfoRepository _repository;

  @override
  ResultVoid call(String params) async => _repository.setPin(params);
}