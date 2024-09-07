abstract class LanguageRepository {
  Future<void> setLanguage(String languageCode);
  Future<String?> getLanguage();
}