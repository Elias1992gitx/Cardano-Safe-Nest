import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/connecting_devices/domain/repositories/connection_repository.dart';

class AcceptConnectionRequestUseCase extends UsecaseWithParams<void, String> {
  const AcceptConnectionRequestUseCase(this._repository);

  final ConnectionRepository _repository;

  @override
  ResultVoid call(String params) async => _repository.acceptConnectionRequest(params);
}