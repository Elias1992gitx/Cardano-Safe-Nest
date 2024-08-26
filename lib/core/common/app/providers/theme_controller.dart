import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safenest/core/res/app_theme.dart';

class ThemeController extends GetxController {

  ThemeController() {
    currentTheme.value = CoreTheme.themeMode; // Initialize with saved theme mode
  }
  Rx<ThemeMode> currentTheme = Rx<ThemeMode>(ThemeMode.light);

  void changeTheme(ThemeMode mode) {
    Get.changeThemeMode(mode);
    CoreTheme.saveThemeMode(mode);
    currentTheme.value = mode;
  }
}

