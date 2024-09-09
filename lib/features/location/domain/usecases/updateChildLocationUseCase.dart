import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/location/domain/repos/location_repository.dart';
import 'package:safenest/features/location/domain/entity/child_location.dart';

class UpdateChildLocationUseCase extends UsecaseWithParams<void, ChildLocation> {
  const UpdateChildLocationUseCase(this._repository);

  final LocationRepository _repository;

  @override
  ResultVoid call(ChildLocation params) async => _repository.updateChildLocation(params);
}