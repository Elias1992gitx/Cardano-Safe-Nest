import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:safenest/core/errors/failure.dart';
import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/language/domain/repos/language_repository.dart';

class SetLanguage extends UsecaseWithParams<void, SetLanguageParams> {
  final LanguageRepository repository;

  SetLanguage(this.repository);

  @override
  ResultFuture<void> call(SetLanguageParams params) async {
    try {
      await repository.setLanguage(params.languageCode);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Localization Error', statusCode: 606));
    }
  }
}

class SetLanguageParams extends Equatable {
  final String languageCode;

  const SetLanguageParams(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}