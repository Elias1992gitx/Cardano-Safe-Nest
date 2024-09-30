import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/location/domain/entity/child_location.dart';
import 'package:safenest/features/location/domain/entity/safe_location.dart';

abstract class LocationRepository {
  ResultFuture<List<ChildLocation>> getAllChildLocations(String parentId);
  ResultFuture<ChildLocation> getChildLocation(String childId);
  ResultVoid updateChildLocation(ChildLocation childLocation);

  ResultFuture<List<SafeLocation>> getSafeLocations(String childId);
  ResultVoid addSafeLocation(String childId, SafeLocation location);
  ResultVoid removeSafeLocation(String childId, String locationId);
  ResultFuture<bool> checkIfLocationIsSafe(String childId, ChildLocation location);

  ResultFuture<List<String>> getGeofencingAlerts(String childId);
  ResultVoid addGeofencingAlert(String childId, String alert);
  ResultVoid removeGeofencingAlert(String childId, String alertId);
}