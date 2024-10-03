import 'package:safenest/core/enum/user/user_role.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.email,
    required super.uid,
    required super.username,

    super.phoneNumber,
    super.country,
    super.city,
    super.address,
    super.emailVerified,
    super.createdAt,
    super.updatedAt,
    super.profilePic,
    super.monitoredApps,
    super.isTwoFactorEnabled,
  });

  LocalUserModel.fromMap(DataMap map)
    : super(
        uid: map['uid'] as String? ?? '',
        username: map['username'] as String? ?? '',
        email: map['email'] as String? ?? '',
        monitoredApps: (map['monitoredApps'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
            [],
        isTwoFactorEnabled: map['isTwoFactorEnabled'] as bool? ?? false,
        updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt'] as String) : null,
        createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
        phoneNumber: map['phoneNumber'] as String?,
        profilePic: map['profilePic'] as String?,
        address: map['address'] as String?,
        country: map['country'] as String?,
        city: map['city'] as String?,
        emailVerified: map['emailVerified'] != null ? DateTime.parse(map['emailVerified'] as String) : null,
      );

  LocalUserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? phoneNumber,
    String? profilePic,
    UserRole? role,
    String? address,
    String? country,
    String? city,
    List<String>? monitoredApps, 
    bool? isTwoFactorEnabled,
    DateTime? updatedAt,
    DateTime? createdAt,
    DateTime? emailVerified,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePic: profilePic ?? this.profilePic,
      address: address ?? this.address,
      country: country ?? this.country,
      city: city ?? this.city,
      monitoredApps: monitoredApps ?? this.monitoredApps,
      isTwoFactorEnabled: isTwoFactorEnabled ?? this.isTwoFactorEnabled,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  DataMap toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'address': address,
      'country': country,
      'city': city,
      'monitoredApps': monitoredApps,
      'isTwoFactorEnabled': isTwoFactorEnabled,
      'updatedAt': updatedAt,
      'createdAt': createdAt,
      'emailVerified': emailVerified,
    };
  }
}
