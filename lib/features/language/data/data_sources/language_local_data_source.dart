import 'package:shared_preferences/shared_preferences.dart';

abstract class LanguageLocalDataSource {
  Future<void> setLanguage(String languageCode);
  Future<String?> getLanguage();
}

class LanguageLocalDataSourceImpl implements LanguageLocalDataSource {
  final SharedPreferences sharedPreferences;

  LanguageLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> setLanguage(String languageCode) async {
    await sharedPreferences.setString('language_code', languageCode);
  }

  @override
  Future<String?> getLanguage() async {
    return sharedPreferences.getString('language_code');
  }
}