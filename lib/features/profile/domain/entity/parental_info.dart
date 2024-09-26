// lib/features/profile/domain/entity/parental_info.dart
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';

class ParentalInfo extends Equatable {
  final List<Child> children;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final bool emailNotifications;
  final bool smsNotifications;
  final String notificationFrequency;
  final LatLng homeLocation;
  final String homeAddress;
  final String pin;

  const ParentalInfo({
    required this.children,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.emailNotifications,
    required this.smsNotifications,
    required this.notificationFrequency,
    required this.homeLocation,
    required this.homeAddress,
    required this.pin,
  });

  ParentalInfo copyWith({
    List<Child>? children,
    String? emergencyContactName,
    String? emergencyContactPhone,
    bool? emailNotifications,
    bool? smsNotifications,
    String? notificationFrequency,
    LatLng? homeLocation,
    String? homeAddress,
    String? pin,
  }) {
    return ParentalInfo(
      children: children ?? this.children,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      notificationFrequency:
          notificationFrequency ?? this.notificationFrequency,
      homeLocation: homeLocation ?? this.homeLocation,
      homeAddress: homeAddress ?? this.homeAddress,
      pin: pin ?? this.pin,
    );
  }

  @override
  List<Object?> get props => [
        children,
        emergencyContactName,
        emergencyContactPhone,
        emailNotifications,
        smsNotifications,
        notificationFrequency,
        homeLocation,
        homeAddress,
        pin,
      ];
}
