import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SafeLocation extends Equatable {
  final String id;
  final String name;
  final GeoPoint location;
  final double radius;

  const SafeLocation({
    required this.id,
    required this.name,
    required this.location,
    required this.radius,
  });

  @override
  List<Object?> get props => [id, name, location, radius];
}