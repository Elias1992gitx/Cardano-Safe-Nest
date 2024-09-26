part of 'parental_info_bloc.dart';

abstract class ParentalInfoState extends Equatable {
  const ParentalInfoState();
  
  @override
  List<Object> get props => [];
}

class ParentalInfoInitial extends ParentalInfoState {}

class ParentalInfoLoading extends ParentalInfoState {}

class ParentalInfoLoaded extends ParentalInfoState {
  final ParentalInfo parentalInfo;

  const ParentalInfoLoaded(this.parentalInfo);

  @override
  List<Object> get props => [parentalInfo];
}

class ParentalInfoSaved extends ParentalInfoState {}

class ParentalInfoUpdated extends ParentalInfoState {}

class ChildAdded extends ParentalInfoState {}

class ChildUpdated extends ParentalInfoState {}

class ChildRemoved extends ParentalInfoState {}

class PinSet extends ParentalInfoState {}

class ParentalInfoError extends ParentalInfoState {
  final String message;

  const ParentalInfoError(this.message);

  @override
  List<Object> get props => [message];
}