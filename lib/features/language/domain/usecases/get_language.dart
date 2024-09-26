import 'package:dartz/dartz.dart';
import 'package:safenest/core/errors/failure.dart';
import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/language/domain/repos/language_repository.dart';

class GetLanguage extends UsecaseWithoutParams<String?> {
  final LanguageRepository repository;

  GetLanguage(this.repository);

  @override
  ResultFuture<String?> call() async {
    try {
      final languageCode = await repository.getLanguage();
      return Right(languageCode);
    } catch (e) {
      return Left(CacheFailure(message: 'Localization Error', statusCode: 606));
    }
  }
}