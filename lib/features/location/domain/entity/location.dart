import 'package:equatable/equatable.dart';

class Location extends Equatable {
  const Location({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

  const Location.empty()
      : this(
    latitude: 0.0,
    longitude: 0.0,
    address: '',
    type: '',
  );

  final double latitude;
  final double longitude;
  final String address;
  final String type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Location{latitude: $latitude, longitude: $longitude, address: $address, type: $type}';
  }

  @override
  List<Object?> get props => [latitude, longitude, address, type, createdAt, updatedAt];
}