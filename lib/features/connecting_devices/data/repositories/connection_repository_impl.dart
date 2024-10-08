import 'package:dartz/dartz.dart';
import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/core/errors/failure.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/connecting_devices/data/datasources/connection_remote_data_source.dart';
import 'package:safenest/features/connecting_devices/data/models/connection_request_model.dart';
import 'package:safenest/features/connecting_devices/domain/entities/connection_request.dart';
import 'package:safenest/features/connecting_devices/domain/repositories/connection_repository.dart';

class ConnectionRepositoryImpl implements ConnectionRepository {
  final ConnectionRemoteDataSource _remoteDataSource;

  ConnectionRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<void> sendConnectionRequest(ConnectionRequest request) async {
    try {
      await _remoteDataSource
          .sendConnectionRequest(ConnectionRequestModel.fromEntity(request));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Stream<Either<Failure, List<ConnectionRequest>>> getPendingConnectionRequests(
      String childEmail) {
    return _remoteDataSource
        .getPendingConnectionRequests(childEmail)
        .map((requests) => Right<Failure, List<ConnectionRequest>>(
            requests.map((model) => model.toConnectionRequest()).toList()))
        .handleError((error) {
      if (error is ServerException) {
        return Left<Failure, List<ConnectionRequest>>(ServerFailure(
            message: error.message, statusCode: error.statusCode));
      }
      return Left<Failure, List<ConnectionRequest>>(
          ServerFailure(message: 'Unknown error occurred', statusCode: 500));
    });
  }

  @override
  ResultVoid acceptConnectionRequest(String requestId) async {
    try {
      await _remoteDataSource.acceptConnectionRequest(requestId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 502));
    }
  }

  @override
  ResultVoid rejectConnectionRequest(String requestId) async {
    try {
      await _remoteDataSource.rejectConnectionRequest(requestId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 502));
    }
  }

  @override
  ResultFuture<bool> isConnected(String parentEmail, String childEmail) async {
    try {
      final isConnected =
          await _remoteDataSource.isConnected(parentEmail, childEmail);
      return Right(isConnected);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 502));
    }
  }

  @override
  ResultVoid disconnectDevices(String parentEmail, String childEmail) async {
    try {
      await _remoteDataSource.disconnectDevices(parentEmail, childEmail);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: 502));
    }
  }
}
