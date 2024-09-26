part of 'language_bloc.dart';

abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageChanged extends LanguageState {
  final String languageCode;

  const LanguageChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LanguageLoaded extends LanguageState {
  final String? languageCode;

  const LanguageLoaded(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LanguageError extends LanguageState {
  final String message;

  const LanguageError(this.message);

  @override
  List<Object?> get props => [message];
}