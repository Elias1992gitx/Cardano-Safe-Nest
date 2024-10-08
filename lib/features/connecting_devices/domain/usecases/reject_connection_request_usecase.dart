import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/connecting_devices/domain/repositories/connection_repository.dart';

class RejectConnectionRequestUseCase extends UsecaseWithParams<void, String> {
  const RejectConnectionRequestUseCase(this._repository);

  final ConnectionRepository _repository;

  @override
  ResultVoid call(String params) async => _repository.rejectConnectionRequest(params);
}