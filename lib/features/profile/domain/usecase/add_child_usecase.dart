import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/profile/domain/repos/parental_info_repository.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';

class AddChildUseCase extends UsecaseWithParams<void, Child> {
  const AddChildUseCase(this._repository);

  final ParentalInfoRepository _repository;

  @override
  ResultVoid call(Child params) async => _repository.addChild(params);
}