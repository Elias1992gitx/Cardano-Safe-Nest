part of 'parental_info_bloc.dart';

abstract class ParentalInfoEvent extends Equatable {
  const ParentalInfoEvent();

  @override
  List<Object> get props => [];
}

class SaveParentalInfoEvent extends ParentalInfoEvent {
  final ParentalInfo parentalInfo;

  const SaveParentalInfoEvent(this.parentalInfo);

  @override
  List<Object> get props => [parentalInfo];
}


class LinkChildToParentEvent extends ParentalInfoEvent {
  final String childId;
  final String parentId;

  const LinkChildToParentEvent({required this.childId, required this.parentId});

  @override
  List<Object> get props => [childId, parentId];
}

class GetParentalInfoEvent extends ParentalInfoEvent {}

class UpdateParentalInfoEvent extends ParentalInfoEvent {
  final ParentalInfo parentalInfo;

  const UpdateParentalInfoEvent(this.parentalInfo);

  @override
  List<Object> get props => [parentalInfo];
}

class AddChildEvent extends ParentalInfoEvent {
  final Child child;

  const AddChildEvent(this.child);

  @override
  List<Object> get props => [child];
}

class UpdateChildEvent extends ParentalInfoEvent {
  final Child child;

  const UpdateChildEvent(this.child);

  @override
  List<Object> get props => [child];
}

class RemoveChildEvent extends ParentalInfoEvent {
  final String childId;

  const RemoveChildEvent(this.childId);

  @override
  List<Object> get props => [childId];
}

class SetPinEvent extends ParentalInfoEvent {
  final String pin;

  const SetPinEvent(this.pin);

  @override
  List<Object> get props => [pin];
}