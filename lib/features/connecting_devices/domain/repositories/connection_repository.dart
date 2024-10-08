import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/connecting_devices/domain/entities/connection_request.dart';
import "package:dartz/dartz.dart";
import "package:safenest/core/errors/failure.dart";

abstract class ConnectionRepository {
  ResultFuture<void> sendConnectionRequest(ConnectionRequest request);
  Stream<Either<Failure, List<ConnectionRequest>>> getPendingConnectionRequests(
      String childEmail);
  ResultVoid acceptConnectionRequest(String requestId);
  ResultVoid rejectConnectionRequest(String requestId);
  ResultFuture<bool> isConnected(String parentEmail, String childEmail);
  ResultVoid disconnectDevices(String parentEmail, String childEmail);
}
