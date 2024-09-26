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

class GetCurrentUserDigitalWellbeingEvent extends DigitalWellbeingEvent {
  const GetCurrentUserDigitalWellbeingEvent();

  @override
  List<Object> get props => [];
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
  final UsageLimit limit;

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

  const GetDigitalWellbeingHistoryEvent({
    required this.childId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [childId, startDate, endDate];
}