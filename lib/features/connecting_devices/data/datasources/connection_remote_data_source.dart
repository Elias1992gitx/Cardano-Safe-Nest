import 'package:firebase_database/firebase_database.dart';
import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/features/connecting_devices/data/models/connection_request_model.dart';

abstract class ConnectionRemoteDataSource {
  Future<void> sendConnectionRequest(ConnectionRequestModel request);
  Stream<List<ConnectionRequestModel>> getPendingConnectionRequests(String childEmail);
  Future<void> acceptConnectionRequest(String requestId);
  Future<void> rejectConnectionRequest(String requestId);
  Future<bool> isConnected(String parentEmail, String childEmail);
  Future<void> disconnectDevices(String parentEmail, String childEmail);
}

class ConnectionRemoteDataSourceImpl implements ConnectionRemoteDataSource {
  final FirebaseDatabase _database;

  ConnectionRemoteDataSourceImpl(this._database);

  @override
  Future<void> sendConnectionRequest(ConnectionRequestModel request) async {
    try {
      await _database.ref('connection_requests').push().set(request.toMap());
    } catch (e) {
      throw ServerException(message: 'Failed to send connection request', statusCode: 500);
    }
  }

  @override
  Stream<List<ConnectionRequestModel>> getPendingConnectionRequests(String childEmail) {
    return _database
        .ref('connection_requests')
        .orderByChild('childEmail')
        .equalTo(childEmail)
        .onValue
        .map((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value == null) return [];
      final Map<dynamic, dynamic> values = dataSnapshot.value as Map<dynamic, dynamic>;
      return values.entries
          .where((entry) => entry.value['status'] == 'pending')
          .map((entry) => ConnectionRequestModel.fromMap(Map<String, dynamic>.from(entry.value)))
          .toList();
    });
  }

  @override
  Future<void> acceptConnectionRequest(String requestId) async {
    try {
      await _database
          .ref('connection_requests')
          .child(requestId)
          .update({'status': 'accepted'});
    } catch (e) {
      throw ServerException(message: 'Failed to accept connection request', statusCode: 500);
    }
  }

  @override
  Future<void> rejectConnectionRequest(String requestId) async {
    try {
      await _database
          .ref('connection_requests')
          .child(requestId)
          .update({'status': 'rejected'});
    } catch (e) {
      throw ServerException(message: 'Failed to reject connection request', statusCode: 500);
    }
  }

  @override
  Future<bool> isConnected(String parentEmail, String childEmail) async {
    try {
      final snapshot = await _database
          .ref('connections')
          .orderByChild('parentEmail')
          .equalTo(parentEmail)
          .get();

      if (!snapshot.exists) return false;

      final Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      return values.values.any((connection) => connection['childEmail'] == childEmail);
    } catch (e) {
      throw ServerException(message: 'Failed to check connection status', statusCode: 500);
    }
  }

  @override
  Future<void> disconnectDevices(String parentEmail, String childEmail) async {
    try {
      final snapshot = await _database
          .ref('connections')
          .orderByChild('parentEmail')
          .equalTo(parentEmail)
          .get();

      if (!snapshot.exists) return;

      final Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      final connectionToRemove = values.entries.firstWhere(
        (entry) => entry.value['childEmail'] == childEmail,
        orElse: () => MapEntry('', {}),
      );

      if (connectionToRemove != null) {
        await _database
            .ref('connections')
            .child(connectionToRemove.key)
            .remove();
      }
    } catch (e) {
      throw ServerException(message: 'Failed to disconnect devices', statusCode: 500);
    }
  }
}