part of 'digital_wellbeing_bloc.dart';

abstract class DigitalWellbeingEvent extends Equatable {
  const DigitalWellbeingEvent();

  @override
  List<Object> get props => [];
}

class GetDigitalWellbeingEvent extends DigitalWellbeingEvent {
  final String childId;

  const GetDigitalWellbeingEvent(this.childId);

  @override
  List<Object> get props => [childId];
}

class UpdateDigitalWellbeingEvent extends DigitalWellbeingEvent {
  final DigitalWellbeing digitalWellbeing;

  const UpdateDigitalWellbeingEvent(this.digitalWellbeing);

  @override
  List<Object> get props => [digitalWellbeing];
}

class SetUsageLimitEvent extends DigitalWellbeingEvent {
  final String childId;
  final String packageName;
  final Duration limit;

  const SetUsageLimitEvent(this.childId, this.packageName, this.limit);

  @override
  List<Object> get props => [childId, packageName, limit];
}

class RemoveUsageLimitEvent extends DigitalWellbeingEvent {
  final String childId;
  final String packageName;

  const RemoveUsageLimitEvent(this.childId, this.packageName);

  @override
  List<Object> get props => [childId, packageName];
}

class GetDigitalWellbeingHistoryEvent extends DigitalWellbeingEvent {
  final String childId;
  final DateTime startDate;
  final DateTime endDate;

  const GetDigitalWellbeingHistoryEvent(this.childId, this.startDate, this.endDate);

  @override
  List<Object> get props => [childId, startDate, endDate];
}