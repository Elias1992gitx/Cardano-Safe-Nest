part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ScanDigitalIdEvent extends ProfileEvent {

  const ScanDigitalIdEvent({required this.front, required this.back});
  final File front;
  final File back;

  @override
  List<Object> get props => [front, back];
}

class ScanPassportEvent extends ProfileEvent {

  const ScanPassportEvent({required this.firstPage});
  final File firstPage;

  @override
  List<Object> get props => [firstPage];
}