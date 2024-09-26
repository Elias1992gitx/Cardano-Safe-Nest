import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';
import 'package:safenest/features/profile/domain/entity/parental_info.dart';
import 'package:safenest/features/profile/data/models/child_model.dart';

class ParentalInfoModel extends ParentalInfo {
  const ParentalInfoModel({
    required super.children,
    required super.emergencyContactName,
    required super.emergencyContactPhone,
    required super.emailNotifications,
    required super.smsNotifications,
    required super.notificationFrequency,
    required super.homeLocation,
    required super.homeAddress,
    required super.pin,
  });

  ParentalInfoModel.fromMap(DataMap map)
      : super(
    children: (map['children'] as List<dynamic>)
        .map((child) => ChildModel.fromMap(child as DataMap))
        .toList(),
    emergencyContactName: map['emergencyContactName'] as String,
    emergencyContactPhone: map['emergencyContactPhone'] as String,
    emailNotifications: map['emailNotifications'] as bool,
    smsNotifications: map['smsNotifications'] as bool,
    notificationFrequency: map['notificationFrequency'] as String,
    homeLocation: LatLng(
      map['homeLocation']['latitude'] as double,
      map['homeLocation']['longitude'] as double,
    ),
    homeAddress: map['homeAddress'] as String,
    pin: map['pin'] as String,
  );

  @override
  ParentalInfo copyWith({
    List<Child>? children,
    bool? emailNotifications,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? homeAddress,
    LatLng? homeLocation,
    String? notificationFrequency,
    String? pin,
    bool? smsNotifications,
  }) {
    return ParentalInfoModel(
      children: children ?? this.children.cast<ChildModel>(),
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      notificationFrequency: notificationFrequency ?? this.notificationFrequency,
      homeLocation: homeLocation ?? this.homeLocation,
      homeAddress: homeAddress ?? this.homeAddress,
      pin: pin ?? this.pin,
    );
  }

  DataMap toMap() {
    return {
      'children': children.map((child) => (child as ChildModel).toMap()).toList(),
      'emergencyContactName': emergencyContactName,
      'emergencyContactPhone': emergencyContactPhone,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'notificationFrequency': notificationFrequency,
      'homeLocation': {
        'latitude': homeLocation.latitude,
        'longitude': homeLocation.longitude,
      },
      'homeAddress': homeAddress,
      'pin': pin,
    };
  }

  factory ParentalInfoModel.fromEntity(ParentalInfo entity) {
    return ParentalInfoModel(
      children: entity.children.map((child) => ChildModel.fromEntity(child)).toList(),
      emergencyContactName: entity.emergencyContactName,
      emergencyContactPhone: entity.emergencyContactPhone,
      emailNotifications: entity.emailNotifications,
      smsNotifications: entity.smsNotifications,
      notificationFrequency: entity.notificationFrequency,
      homeLocation: entity.homeLocation,
      homeAddress: entity.homeAddress,
      pin: entity.pin,
    );
  }
}