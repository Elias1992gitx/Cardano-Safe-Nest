import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';
SharedPreferences? _prefs;

abstract class CoreTheme {
  ThemeData get themeData;

  Color get primaryColor;
  Color get secondaryColor;
  Color get backgroundColor;
  Color get secondaryBackgroundColor;
  Color get errorColor;
  Color get warningColor;
  Color get helpColor;
  Color get profileHeader;
  Color get tFieldPrimary;

  static Future<SharedPreferences> initialize() async =>
      _prefs = await SharedPreferences.getInstance();

  static void saveThemeMode(ThemeMode mode) {
    _prefs?.setString(kThemeModeKey, mode.toString().split('.').last);
  }

  static ThemeMode get themeMode {
    final modeStr = _prefs?.getString(kThemeModeKey);
    if (modeStr != null) {
      switch (modeStr) {
        case 'light':
          return ThemeMode.light;
        case 'dark':
          return ThemeMode.dark;
        default:
          return ThemeMode.system;
      }
    }
    return ThemeMode.light;
  }

  static ThemeData getThemeData(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? DarkModeTheme().themeData
        : LightModeTheme().themeData;
  }
}

class LightModeTheme extends CoreTheme {
  @override
  Color get primaryColor => const Color.fromRGBO(79, 61, 86, 1);
  @override
  Color get secondaryColor => const Color(0xff290001);
  @override
  Color get backgroundColor => const Color(0xFFFFFFFF);
  @override
  Color get secondaryBackgroundColor => const Color(0xFFFFFFFF);
  @override
  Color get errorColor => const Color.fromRGBO(216, 0, 50, 1);
  @override
  Color get tFieldPrimary => const Color(0xF1EFEFFF);

  @override
  Color get helpColor => const Color(0xff3282B8);
  @override
  Color get warningColor => const Color(0xffFCA652);
  @override
  Color get profileHeader => const Color.fromRGBO(34, 40, 49, .9);

  Color get cardGradientStart => primaryColor.withOpacity(0.05);
  Color get cardGradientEnd => primaryColor.withOpacity(0.02);
  Color get cardBorder => primaryColor.withOpacity(0.1);

  @override
  ThemeData get themeData => ThemeData(
        primaryColor: primaryColor,
        primaryTextTheme: TextTheme(
          bodyMedium: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: Colors.green, // Example of defining a primary swatch
          secondary: secondaryColor,
          surface: backgroundColor,
          onSurface: secondaryBackgroundColor,
          primaryContainer: helpColor,
          secondaryContainer: warningColor,
          onTertiary: profileHeader,

        ).copyWith(
          error: errorColor,
          tertiaryContainer: tFieldPrimary,
        ),
      );
}

class DarkModeTheme extends CoreTheme {
  @override
  Color get primaryColor => Color.fromRGBO(79, 61, 86, 1);
  @override
  Color get secondaryColor => const Color.fromRGBO(4, 13, 18, 1);
  @override
  Color get secondaryBackgroundColor => const Color.fromRGBO(4, 13, 18, 1);
  @override
  Color get backgroundColor => const Color.fromRGBO(4, 13, 18, 1);
  @override
  Color get errorColor => const Color.fromRGBO(216, 0, 50, 1);
  @override
  Color get helpColor => const Color(0xff3282B8);
  @override
  Color get warningColor => const Color(0xffFCA652);
  @override
  Color get tFieldPrimary => const Color.fromRGBO(9, 24, 30, 1);
  @override
  Color get profileHeader => const Color(0x00040d12);

  Color get cardGradientStart => primaryColor.withOpacity(0.05);
  Color get cardGradientEnd => primaryColor.withOpacity(0.02);
  Color get cardBorder => primaryColor.withOpacity(0.1);

  @override
  ThemeData get themeData => ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.dark(
            primary: primaryColor,
            secondary: secondaryColor,
            error: errorColor,
            primaryContainer: helpColor,
            secondaryContainer: warningColor,
            onTertiary: profileHeader,
            surface: cardGradientStart,
            onSurface: cardGradientEnd,
            outline: cardBorder,
            tertiaryContainer: tFieldPrimary),
      );
}
