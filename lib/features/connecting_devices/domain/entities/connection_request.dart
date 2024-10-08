import 'package:equatable/equatable.dart';

class ConnectionRequest extends Equatable {
  final String? id;
  final String parentEmail;
  final String childEmail;
  final DateTime timestamp;
  final String? status;

  const ConnectionRequest({
    this.id,
    required this.parentEmail,
    required this.childEmail,
    required this.timestamp,
    this.status,
  });

  @override
  List<Object?> get props => [id, parentEmail, childEmail, timestamp, status];
}