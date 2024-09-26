import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/location/domain/entity/location.dart';
class LocationModel extends Location {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    required super.address,
    required super.type,
    super.createdAt,
    super.updatedAt,
  });

  LocationModel.fromMap(DataMap map)
      : super(
    latitude: map['latitude'] as double,
    longitude: map['longitude'] as double,
    address: map['address'] as String,
    type: map['type'] as String,
    createdAt: map['createdAt'] != null
        ? DateTime.parse(map['createdAt'] as String)
        : null,
    updatedAt: map['updatedAt'] != null
        ? DateTime.parse(map['updatedAt'] as String)
        : null,
  );

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  DataMap toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'type': type,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}