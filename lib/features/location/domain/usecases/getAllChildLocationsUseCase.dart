import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/location/domain/repos/location_repository.dart';
import 'package:safenest/features/location/domain/entity/child_location.dart';

class GetAllChildLocationsUseCase
    extends UsecaseWithParams<List<ChildLocation>, String> {
  const GetAllChildLocationsUseCase(this._repository);

  final LocationRepository _repository;

  @override
  ResultFuture<List<ChildLocation>> call(String params) async =>
      _repository.getAllChildLocations(params);
}
