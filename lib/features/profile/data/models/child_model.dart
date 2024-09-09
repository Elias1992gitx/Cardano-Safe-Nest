import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/location/domain/entity/safe_location.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';

class ChildModel extends Child {
  const ChildModel({
    required super.id,
    required super.name,
    required super.age,
    required super.gender,
    super.profilePicture,
    super.phoneNumber,
    super.emailAddress,
    super.homeAddress,
    super.currentLocation,
    super.schoolName,
    super.schoolAddress,
    super.monitoredApps,
    super.screenTime,
    super.activityLogs,
    super.parentalControls,
    super.geofencingAlerts,
    super.emergencyContacts,
    super.accountSecurity,
    super.permissions,
    super.educationProfile,
    super.friendsList,
    super.behavioralReports,
    super.notificationPreferences,
    super.personalPreferences,
    super.safeLocations
  });

  ChildModel.fromMap(DataMap map)
      : super(
    id: map['id'] as String,
    name: map['name'] as String,
    age: map['age'] as int,
    gender: map['gender'] as String,
    profilePicture: map['profilePicture'] as String?,
    phoneNumber: map['phoneNumber'] as String?,
    emailAddress: map['emailAddress'] as String?,
    homeAddress: map['homeAddress'] as String?,
    currentLocation: map['currentLocation'] != null
        ? GeoPoint(
      map['currentLocation']['latitude'] as double,
      map['currentLocation']['longitude'] as double,
    )
        : null,
    schoolName: map['schoolName'] as String?,
    schoolAddress: map['schoolAddress'] as String?,
    monitoredApps: (map['monitoredApps'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    screenTime: map['screenTime'] != null
        ? Duration(seconds: map['screenTime'] as int)
        : null,
    activityLogs: (map['activityLogs'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    parentalControls: map['parentalControls'] as Map<String, dynamic>?,
    geofencingAlerts: (map['geofencingAlerts'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    emergencyContacts: (map['emergencyContacts'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    accountSecurity: map['accountSecurity'] as bool?,
    permissions: map['permissions'] as Map<String, bool>?,
    educationProfile: map['educationProfile'] as Map<String, dynamic>?,
    friendsList: (map['friendsList'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    behavioralReports: (map['behavioralReports'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList(),
    notificationPreferences:
    map['notificationPreferences'] as Map<String, bool>?,
    personalPreferences: map['personalPreferences'] as Map<String, dynamic>?,
  );

  ChildModel copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? profilePicture,
    String? phoneNumber,
    String? emailAddress,
    String? homeAddress,
    GeoPoint? currentLocation,
    String? schoolName,
    String? schoolAddress,
    List<SafeLocation>? safeLocations,
    List<String>? monitoredApps,
    Duration? screenTime,
    List<String>? activityLogs,
    Map<String, dynamic>? parentalControls,
    List<String>? geofencingAlerts,
    List<String>? emergencyContacts,
    bool? accountSecurity,
    Map<String, bool>? permissions,
    Map<String, dynamic>? educationProfile,
    List<String>? friendsList,
    List<String>? behavioralReports,
    Map<String, bool>? notificationPreferences,
    Map<String, dynamic>? personalPreferences,
  }) {
    return ChildModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      profilePicture: profilePicture ?? this.profilePicture,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      homeAddress: homeAddress ?? this.homeAddress,
      currentLocation: currentLocation ?? this.currentLocation,
      schoolName: schoolName ?? this.schoolName,
      schoolAddress: schoolAddress ?? this.schoolAddress,
      monitoredApps: monitoredApps ?? this.monitoredApps,
      screenTime: screenTime ?? this.screenTime,
      safeLocations:safeLocations??this.safeLocations,
      activityLogs: activityLogs ?? this.activityLogs,
      parentalControls: parentalControls ?? this.parentalControls,
      geofencingAlerts: geofencingAlerts ?? this.geofencingAlerts,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      accountSecurity: accountSecurity ?? this.accountSecurity,
      permissions: permissions ?? this.permissions,
      educationProfile: educationProfile ?? this.educationProfile,
      friendsList: friendsList ?? this.friendsList,
      behavioralReports: behavioralReports ?? this.behavioralReports,
      notificationPreferences:
      notificationPreferences ?? this.notificationPreferences,
      personalPreferences: personalPreferences ?? this.personalPreferences,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'profilePicture': profilePicture,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'homeAddress': homeAddress,
      'currentLocation': currentLocation != null
          ? {
        'latitude': currentLocation!.latitude,
        'longitude': currentLocation!.longitude,
      }
          : null,
      'schoolName': schoolName,
      'schoolAddress': schoolAddress,
      'safeLocations': safeLocations,
      'monitoredApps': monitoredApps,
      'screenTime': screenTime?.inSeconds,
      'activityLogs': activityLogs,
      'parentalControls': parentalControls,
      'geofencingAlerts': geofencingAlerts,
      'emergencyContacts': emergencyContacts,
      'accountSecurity': accountSecurity,
      'permissions': permissions,
      'educationProfile': educationProfile,
      'friendsList': friendsList,
      'behavioralReports': behavioralReports,
      'notificationPreferences': notificationPreferences,
      'personalPreferences': personalPreferences,
    };
  }

  factory ChildModel.fromEntity(Child entity) {
    return ChildModel(
      id: entity.id,
      name: entity.name,
      age: entity.age,
      gender: entity.gender,
      profilePicture: entity.profilePicture,
      phoneNumber: entity.phoneNumber,
      emailAddress: entity.emailAddress,
      homeAddress: entity.homeAddress,
      currentLocation: entity.currentLocation,
      schoolName: entity.schoolName,
      schoolAddress: entity.schoolAddress,
      safeLocations: entity.safeLocations,
      monitoredApps: entity.monitoredApps,
      screenTime: entity.screenTime,
      activityLogs: entity.activityLogs,
      parentalControls: entity.parentalControls,
      geofencingAlerts: entity.geofencingAlerts,
      emergencyContacts: entity.emergencyContacts,
      accountSecurity: entity.accountSecurity,
      permissions: entity.permissions,
      educationProfile: entity.educationProfile,
      friendsList: entity.friendsList,
      behavioralReports: entity.behavioralReports,
      notificationPreferences: entity.notificationPreferences,
      personalPreferences: entity.personalPreferences,
    );
  }

}