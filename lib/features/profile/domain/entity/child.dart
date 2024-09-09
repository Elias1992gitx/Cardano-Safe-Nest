import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safenest/features/location/domain/entity/safe_location.dart';

class Child extends Equatable {
  const Child({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.profilePicture,
    this.phoneNumber,
    this.emailAddress,
    this.homeAddress,
    this.currentLocation,
    this.schoolName,
    this.schoolAddress,
    this.safeLocations,
    this.monitoredApps,
    this.screenTime,
    this.activityLogs,
    this.parentalControls,
    this.geofencingAlerts,
    this.emergencyContacts,
    this.accountSecurity,
    this.permissions,
    this.educationProfile,
    this.friendsList,
    this.behavioralReports,
    this.notificationPreferences,
    this.personalPreferences,
  });

  final String id;
  final String name;
  final int age;
  final String gender;
  final String? profilePicture;
  final String? phoneNumber;
  final String? emailAddress;
  final String? homeAddress;
  final GeoPoint? currentLocation;
  final String? schoolName;
  final String? schoolAddress;
  final List<String>? monitoredApps;
  final Duration? screenTime;
  final List<String>? activityLogs;
  final Map<String, dynamic>? parentalControls;
  final List<String>? geofencingAlerts;
  final List<String>? emergencyContacts;
  final bool? accountSecurity;
  final Map<String, bool>? permissions;
  final Map<String, dynamic>? educationProfile;
  final List<String>? friendsList;
  final List<String>? behavioralReports;
  final Map<String, bool>? notificationPreferences;
  final Map<String, dynamic>? personalPreferences;
  final List<SafeLocation>? safeLocations;

  @override
  List<Object?> get props => [
    id,
    name,
    age,
    gender,
    profilePicture,
    phoneNumber,
    emailAddress,
    homeAddress,
    currentLocation,
    schoolName,
    schoolAddress,
    safeLocations,
    monitoredApps,
    screenTime,
    activityLogs,
    parentalControls,
    geofencingAlerts,
    emergencyContacts,
    accountSecurity,
    permissions,
    educationProfile,
    friendsList,
    behavioralReports,
    notificationPreferences,
    personalPreferences,
  ];
}