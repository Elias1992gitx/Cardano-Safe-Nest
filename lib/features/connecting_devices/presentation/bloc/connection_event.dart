import 'package:equatable/equatable.dart';

abstract class ConnectionEvent extends Equatable {
  const ConnectionEvent();

  @override
  List<Object?> get props => [];
}

class SendConnectionRequest extends ConnectionEvent {
  final String parentEmail;
  final String childEmail;

  const SendConnectionRequest({required this.parentEmail, required this.childEmail});

  @override
  List<Object?> get props => [parentEmail, childEmail];
}

class AcceptConnectionRequest extends ConnectionEvent {
  final String requestId;

  const AcceptConnectionRequest({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

class RejectConnectionRequest extends ConnectionEvent {
  final String requestId;

  const RejectConnectionRequest({required this.requestId});

  @override
  List<Object?> get props => [requestId];
}

class GetPendingConnectionRequests extends ConnectionEvent {
  final String childEmail;

  const GetPendingConnectionRequests({required this.childEmail});

  @override
  List<Object?> get props => [childEmail];
}