import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.email,
    required this.uid,
    required this.username,
    this.phoneNumber,

    this.profilePic,
    this.address,
    this.city,
    this.country,
    this.updatedAt,
    this.createdAt,
    this.emailVerified,
    this.monitoredApps,  // Changed from 'investmentType'
    this.isTwoFactorEnabled = false,
  });

  const LocalUser.empty()
      : this(
    uid: '',
    username: '',
    phoneNumber: '',
    email: '',
    profilePic: '',

  );

  final String uid;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? profilePic;
  final String? address;
  final String? country;
  final String? city;
  final List<String>? monitoredApps;  // Changed from 'investmentType'
  final bool isTwoFactorEnabled;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final DateTime? emailVerified;

  @override
  String toString() {
    return 'LocalUser{uid: $uid, phoneNumber: $phoneNumber, '
        'email: $email}';
  }

  @override
  List<Object?> get props => [uid, username, email];
}
