part of 'digital_wellbeing_bloc.dart';

abstract class DigitalWellbeingState extends Equatable {
  const DigitalWellbeingState();

  @override
  List<Object> get props => [];
}

class DigitalWellbeingInitial extends DigitalWellbeingState {}

class DigitalWellbeingLoading extends DigitalWellbeingState {}

class DigitalWellbeingLoaded extends DigitalWellbeingState {
  final DigitalWellbeing digitalWellbeing;

  const DigitalWellbeingLoaded({required this.digitalWellbeing});

  @override
  List<Object> get props => [digitalWellbeing];
}

class DigitalWellbeingUpdated extends DigitalWellbeingState {}

class UsageLimitSet extends DigitalWellbeingState {}

class UsageLimitRemoved extends DigitalWellbeingState {}

class DigitalWellbeingHistoryLoaded extends DigitalWellbeingState {
  final List<DigitalWellbeing> history;

  const DigitalWellbeingHistoryLoaded({required this.history});

  @override
  List<Object> get props => [history];
}

class DigitalWellbeingError extends DigitalWellbeingState {
  final String message;

  const DigitalWellbeingError({required this.message});

  @override
  List<Object> get props => [message];
}