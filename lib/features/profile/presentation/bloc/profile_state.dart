part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileScanSuccess extends ProfileState {

  const ProfileScanSuccess(this.scanResult);
  final ScanResult scanResult;

  @override
  List<Object> get props => [scanResult];
}

class ProfileError extends ProfileState {

  const ProfileError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}