import 'package:dartz/dartz.dart';
import 'package:safenest/core/errors/failure.dart';
import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/connecting_devices/domain/repositories/connection_repository.dart';
import 'package:safenest/features/connecting_devices/domain/entities/connection_request.dart';

class GetPendingConnectionRequestsUseCase extends UsecaseWithParams<Stream<Either<Failure, List<ConnectionRequest>>>, String> {
  const GetPendingConnectionRequestsUseCase(this._repository);

  final ConnectionRepository _repository;

  @override
  Future<Either<Failure, Stream<Either<Failure, List<ConnectionRequest>>>>> call(String params) async {
    try {
      final stream = _repository.getPendingConnectionRequests(params);
      return Right(stream);
    } catch (e) {
      return Left(ServerFailure(message: e.toString(),statusCode: 500));
    }
  }
}