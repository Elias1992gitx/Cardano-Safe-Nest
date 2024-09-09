import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/location/domain/repos/location_repository.dart';
import 'package:safenest/features/location/domain/entity/child_location.dart';

class CheckIfLocationIsSafeUseCase extends UsecaseWithParams<bool, CheckIfLocationIsSafeParams> {
  const CheckIfLocationIsSafeUseCase(this._repository);

  final LocationRepository _repository;

  @override
  ResultFuture<bool> call(CheckIfLocationIsSafeParams params) async => _repository.checkIfLocationIsSafe(params.childId, params.location);
}

class CheckIfLocationIsSafeParams {
  final String childId;
  final ChildLocation location;

  const CheckIfLocationIsSafeParams({required this.childId, required this.location});
}