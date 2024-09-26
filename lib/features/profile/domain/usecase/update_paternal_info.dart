import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/profile/domain/repos/parental_info_repository.dart';
import 'package:safenest/features/profile/domain/entity/parental_info.dart';

class UpdateParentalInfoUseCase extends UsecaseWithParams<void, ParentalInfo> {
  const UpdateParentalInfoUseCase(this._repository);

  final ParentalInfoRepository _repository;

  @override
  ResultVoid call(ParentalInfo params) async => _repository.updateParentalInfo(params);
}