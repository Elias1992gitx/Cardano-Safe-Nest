import 'package:equatable/equatable.dart';
import 'package:safenest/features/connecting_devices/domain/entities/connection_request.dart';

abstract class ConnectionState extends Equatable {
  const ConnectionState();

  @override
  List<Object?> get props => [];
}

class ConnectionInitial extends ConnectionState {}

class ConnectionLoading extends ConnectionState {}

class ConnectionSuccess extends ConnectionState {}

class ConnectionError extends ConnectionState {
  final String message;

  const ConnectionError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PendingConnectionRequestsLoaded extends ConnectionState {
  final List<ConnectionRequest> requests;

  const PendingConnectionRequestsLoaded({required this.requests});

  @override
  List<Object?> get props => [requests];
}