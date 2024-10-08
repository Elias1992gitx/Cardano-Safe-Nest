import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/connecting_devices/domain/entities/connection_request.dart';

class ConnectionRequestModel extends ConnectionRequest {
  const ConnectionRequestModel({
    required super.parentEmail,
    required super.childEmail,
    required super.timestamp,
    super.id,
    super.status,
  });

  ConnectionRequestModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String?,
          parentEmail: map['parentEmail'] as String,
          childEmail: map['childEmail'] as String,
          timestamp: map['timestamp'] is Timestamp
              ? (map['timestamp'] as Timestamp).toDate()
              : DateTime.parse(map['timestamp'] as String),
          status: map['status'] as String?,
        );

  ConnectionRequest toConnectionRequest() {
    return ConnectionRequest(
      id: id,
      parentEmail: parentEmail,
      childEmail: childEmail,
      timestamp: timestamp,
      status: status,
    );
  }

  ConnectionRequestModel copyWith({
    String? id,
    String? parentEmail,
    String? childEmail,
    DateTime? timestamp,
    String? status,
  }) {
    return ConnectionRequestModel(
      id: id ?? this.id,
      parentEmail: parentEmail ?? this.parentEmail,
      childEmail: childEmail ?? this.childEmail,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'parentEmail': parentEmail,
      'childEmail': childEmail,
      'timestamp': timestamp,
      'status': status,
    };
  }

  static ConnectionRequestModel fromEntity(ConnectionRequest entity) {
    return ConnectionRequestModel(
      id: entity.id,
      parentEmail: entity.parentEmail,
      childEmail: entity.childEmail,
      timestamp: entity.timestamp,
      status: entity.status,
    );
  }
}
