import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/location/domain/repos/location_repository.dart';
import 'package:safenest/features/location/domain/entity/safe_location.dart';

class GetSafeLocationsUseCase extends UsecaseWithParams<List<SafeLocation>, String> {
  const GetSafeLocationsUseCase(this._repository);

  final LocationRepository _repository;

  @override
  ResultFuture<List<SafeLocation>> call(String params) async => _repository.getSafeLocations(params);
}