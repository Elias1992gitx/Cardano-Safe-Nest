import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/connecting_devices/domain/repositories/connection_repository.dart';
import 'package:safenest/features/connecting_devices/domain/entities/connection_request.dart';

class SendConnectionRequestUseCase extends UsecaseWithParams<void, ConnectionRequest> {
  const SendConnectionRequestUseCase(this._repository);

  final ConnectionRepository _repository;

  @override
  ResultFuture<void> call(ConnectionRequest params) async => _repository.sendConnectionRequest(params);
}