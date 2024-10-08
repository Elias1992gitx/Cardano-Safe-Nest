import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/connecting_devices/domain/repositories/connection_repository.dart';

class DisconnectDevicesUseCase extends UsecaseWithParams<void, DisconnectDevicesParams> {
  const DisconnectDevicesUseCase(this._repository);

  final ConnectionRepository _repository;

  @override
  ResultVoid call(DisconnectDevicesParams params) async => _repository.disconnectDevices(params.parentEmail, params.childEmail);
}

class DisconnectDevicesParams {
  final String parentEmail;
  final String childEmail;

  DisconnectDevicesParams({required this.parentEmail, required this.childEmail});
}