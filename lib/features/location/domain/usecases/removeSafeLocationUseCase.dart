import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/location/domain/repos/location_repository.dart';

class RemoveSafeLocationUseCase extends UsecaseWithParams<void, RemoveSafeLocationParams> {
  const RemoveSafeLocationUseCase(this._repository);

  final LocationRepository _repository;

  @override
  ResultVoid call(RemoveSafeLocationParams params) async => _repository.removeSafeLocation(params.childId, params.locationId);
}

class RemoveSafeLocationParams {
  final String childId;
  final String locationId;

  const RemoveSafeLocationParams({required this.childId, required this.locationId});
}