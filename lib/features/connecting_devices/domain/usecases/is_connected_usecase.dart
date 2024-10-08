import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/connecting_devices/domain/repositories/connection_repository.dart';

class IsConnectedUseCase extends UsecaseWithParams<bool, IsConnectedParams> {
  const IsConnectedUseCase(this._repository);

  final ConnectionRepository _repository;

  @override
  ResultFuture<bool> call(IsConnectedParams params) async => _repository.isConnected(params.parentEmail, params.childEmail);
}

class IsConnectedParams {
  final String parentEmail;
  final String childEmail;

  IsConnectedParams({required this.parentEmail, required this.childEmail});
}