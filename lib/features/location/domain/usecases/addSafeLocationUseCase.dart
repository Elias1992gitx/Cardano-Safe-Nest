import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/location/domain/repos/location_repository.dart';
import 'package:safenest/features/location/domain/entity/safe_location.dart';

class AddSafeLocationUseCase extends UsecaseWithParams<void, AddSafeLocationParams> {
  const AddSafeLocationUseCase(this._repository);

  final LocationRepository _repository;

  @override
  ResultVoid call(AddSafeLocationParams params) async => _repository.addSafeLocation(params.childId, params.location);
}

class AddSafeLocationParams {
  final String childId;
  final SafeLocation location;

  const AddSafeLocationParams({required this.childId, required this.location});
}