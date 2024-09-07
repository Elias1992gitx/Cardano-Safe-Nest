import 'package:safenest/core/errors/failure.dart';
import 'package:safenest/features/language/data/data_sources/language_local_data_source.dart';
import 'package:safenest/features/language/domain/repos/language_repository.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  final LanguageLocalDataSource localDataSource;

  LanguageRepositoryImpl(this.localDataSource);

  @override
  Future<void> setLanguage(String languageCode) async {
    try {
      await localDataSource.setLanguage(languageCode);
    } catch (e) {
      throw CacheFailure(message: 'Localization Error', statusCode: 606);
    }
  }

  @override
  Future<String?> getLanguage() async {
    try {
      return await localDataSource.getLanguage();
    } catch (e) {
      throw CacheFailure(message: 'Localization Error', statusCode: 606);
    }
  }
}