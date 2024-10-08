import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:safenest/core/errors/failure.dart';
import 'package:safenest/features/connecting_devices/domain/entities/connection_request.dart';
import 'package:safenest/features/connecting_devices/domain/usecases/send_connection_request.dart';
import 'package:safenest/features/connecting_devices/domain/usecases/accept_connection_request_usecase.dart';
import 'package:safenest/features/connecting_devices/domain/usecases/reject_connection_request_usecase.dart';
import 'package:safenest/features/connecting_devices/domain/usecases/get_pending_connection_requests_usecase.dart';
import 'connection_event.dart';
import 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final SendConnectionRequestUseCase sendConnectionRequest;
  final AcceptConnectionRequestUseCase acceptConnectionRequest;
  final RejectConnectionRequestUseCase rejectConnectionRequest;
  final GetPendingConnectionRequestsUseCase getPendingConnectionRequests;

  ConnectionBloc({
    required this.sendConnectionRequest,
    required this.acceptConnectionRequest,
    required this.rejectConnectionRequest,
    required this.getPendingConnectionRequests,
  }) : super(ConnectionInitial()) {
    on<SendConnectionRequest>(_onSendConnectionRequest);
    on<AcceptConnectionRequest>(_onAcceptConnectionRequest);
    on<RejectConnectionRequest>(_onRejectConnectionRequest);
    on<GetPendingConnectionRequests>(_onGetPendingConnectionRequests);
  }

  void _onSendConnectionRequest(
      SendConnectionRequest event, Emitter<ConnectionState> emit) async {
    emit(ConnectionLoading());
    final result = await sendConnectionRequest(ConnectionRequest(
      parentEmail: event.parentEmail,
      childEmail: event.childEmail,
      timestamp: DateTime.now(),
    ));
    result.fold(
      (failure) => emit(ConnectionError(message: failure.message)),
      (_) => emit(ConnectionSuccess()),
    );
  }

  void _onAcceptConnectionRequest(
      AcceptConnectionRequest event, Emitter<ConnectionState> emit) async {
    emit(ConnectionLoading());
    final result = await acceptConnectionRequest(event.requestId);
    result.fold(
      (failure) => emit(ConnectionError(message: failure.message)),
      (_) => emit(ConnectionSuccess()),
    );
  }

  void _onRejectConnectionRequest(
      RejectConnectionRequest event, Emitter<ConnectionState> emit) async {
    emit(ConnectionLoading());
    final result = await rejectConnectionRequest(event.requestId);
    result.fold(
      (failure) => emit(ConnectionError(message: failure.message)),
      (_) => emit(ConnectionSuccess()),
    );
  }

  void _onGetPendingConnectionRequests(
      GetPendingConnectionRequests event, Emitter<ConnectionState> emit) async {
    emit(ConnectionLoading());
    final result = await getPendingConnectionRequests(event.childEmail);
    result.fold(
      (failure) => emit(ConnectionError(message: failure.message)),
      (stream) async {
        await emit.forEach<Either<Failure, List<ConnectionRequest>>>(
          stream,
          onData: (data) => data.fold(
            (failure) => ConnectionError(message: failure.message),
            (requests) => PendingConnectionRequestsLoaded(requests: requests),
          ),
        );
      },
    );
  }
}
