import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/location/domain/entity/safe_location.dart';

class SafeLocationModel extends SafeLocation {
  const SafeLocationModel({
    required super.id,
    required super.name,
    required super.location,
    required super.radius,
  });

  factory SafeLocationModel.fromMap(DataMap map) {
    return SafeLocationModel(
      id: map['id'] as String,
      name: map['name'] as String,
      location: map['location'] as GeoPoint,
      radius: map['radius'] as double,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'radius': radius,
    };
  }

  factory SafeLocationModel.fromEntity(SafeLocation entity) {
    return SafeLocationModel(
      id: entity.id,
      name: entity.name,
      location: entity.location,
      radius: entity.radius,
    );
  }
}