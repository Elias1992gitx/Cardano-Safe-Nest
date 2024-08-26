import 'package:dartz/dartz.dart';
import 'package:safenest/core/errors/failure.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/location/domain/entity/location.dart';

abstract class LocationRepository {
  ResultFuture<List<Location>> getAllChildLocations(String userId);
  ResultVoid addSafeLocation(String userId, Location location);
  ResultVoid removeSafeLocation(String userId, Location location);
  ResultFuture<bool> checkIfLocationIsSafe(String userId, Location location);
  ResultFuture<List<Location>> getSafeLocations(String userId);
}