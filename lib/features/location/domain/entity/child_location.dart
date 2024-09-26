import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safenest/features/location/domain/entity/safe_location.dart';

class ChildLocation extends Equatable {
  final String childId;
  final GeoPoint location;
  final DateTime timestamp;
  final bool isInSafeZone;
  final SafeLocation? nearestSafeZone;

  const ChildLocation({
    required this.childId,
    required this.location,
    required this.timestamp,
    required this.isInSafeZone,
    this.nearestSafeZone,
  });

  @override
  List<Object?> get props => [childId, location, timestamp, isInSafeZone, nearestSafeZone];
}