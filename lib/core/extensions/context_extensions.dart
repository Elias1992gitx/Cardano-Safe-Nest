import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:safenest/core/enum/user/user_role.dart';
import 'package:safenest/core/res/app_theme.dart';
import 'package:safenest/features/auth/data/models/user_model.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => CoreTheme.getThemeData(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;
  UserProvider get userProvider => read<UserProvider>();
  LocalUserModel? get currentUser => userProvider.user;
}

extension UserRoleExtension on UserRole {
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
          (e) => e.toString().split('.').last == role,
      orElse: () => UserRole.user,
    );
  }
}
