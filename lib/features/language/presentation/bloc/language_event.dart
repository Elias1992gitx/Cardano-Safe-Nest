part of 'language_bloc.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class SetLanguageEvent extends LanguageEvent {
  final String languageCode;

  const SetLanguageEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class GetLanguageEvent extends LanguageEvent {}