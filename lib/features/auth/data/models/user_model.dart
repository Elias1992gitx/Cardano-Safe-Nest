import 'package:safenest/core/enum/user/user_role.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
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
    uid: map['_id'] as String,
    username: map['name'] as String,
    email: map['email'] as String,
    monitoredApps: (map['monitoredApps'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ??
        [],
    isTwoFactorEnabled: map['isTwoFactorEnabled'] as bool,
    updatedAt: DateTime.parse(map['updatedAt'] as String),
    createdAt: DateTime.parse(map['createdAt'] as String),
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
