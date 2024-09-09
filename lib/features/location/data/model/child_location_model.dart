import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/location/data/model/safe_location_model.dart';
import 'package:safenest/features/location/domain/entity/child_location.dart';

class ChildLocationModel extends ChildLocation {
  const ChildLocationModel({
    required super.childId,
    required super.location,
    required super.timestamp,
    required super.isInSafeZone,
    super.nearestSafeZone,
  });

  factory ChildLocationModel.fromMap(DataMap map) {
    return ChildLocationModel(
      childId: map['childId'] as String,
      location: map['location'] as GeoPoint,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isInSafeZone: map['isInSafeZone'] as bool,
      nearestSafeZone: map['nearestSafeZone'] != null
          ? SafeLocationModel.fromMap(map['nearestSafeZone'] as DataMap)
          : null,
    );
  }

  DataMap toMap() {
    return {
      'childId': childId,
      'location': location,
      'timestamp': Timestamp.fromDate(timestamp),
      'isInSafeZone': isInSafeZone,
      'nearestSafeZone': nearestSafeZone != null ? (nearestSafeZone as SafeLocationModel).toMap() : null,
    };
  }

  factory ChildLocationModel.fromEntity(ChildLocation entity) {
    return ChildLocationModel(
      childId: entity.childId,
      location: entity.location,
      timestamp: entity.timestamp,
      isInSafeZone: entity.isInSafeZone,
      nearestSafeZone: entity.nearestSafeZone != null
          ? SafeLocationModel.fromEntity(entity.nearestSafeZone!)
          : null,
    );
  }
}