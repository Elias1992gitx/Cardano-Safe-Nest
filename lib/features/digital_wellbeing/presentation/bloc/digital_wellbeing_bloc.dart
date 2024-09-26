import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safenest/features/digital_wellbeing/data/data_source/digital_wellbeing_local_data.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/digital_wellbeing/domain/usecases/get_digital_wellbeing_use_case.dart';
import 'package:safenest/features/digital_wellbeing/domain/usecases/update_digital_wellbeing_use_case.dart';
import 'package:safenest/features/digital_wellbeing/domain/usecases/set_usage_limit_use_case.dart';
import 'package:safenest/features/digital_wellbeing/domain/usecases/remove_usage_limit_use_case.dart';
import 'package:safenest/features/digital_wellbeing/domain/usecases/get_digital_wellbeing_history_use_case.dart';

part 'digital_wellbeing_event.dart';
part 'digital_wellbeing_state.dart';

class DigitalWellbeingBloc extends Bloc<DigitalWellbeingEvent, DigitalWellbeingState> {
  final GetDigitalWellbeingUseCase _getDigitalWellbeing;
  final UpdateDigitalWellbeingUseCase _updateDigitalWellbeing;
  final SetUsageLimitUseCase _setUsageLimit;
  final RemoveUsageLimitUseCase _removeUsageLimit;
  final GetDigitalWellbeingHistoryUseCase _getDigitalWellbeingHistory;
  final DigitalWellbeingLocalDataSource _localDataSource;

  DigitalWellbeingBloc({
    required GetDigitalWellbeingUseCase getDigitalWellbeing,
    required UpdateDigitalWellbeingUseCase updateDigitalWellbeing,
    required SetUsageLimitUseCase setUsageLimit,
    required RemoveUsageLimitUseCase removeUsageLimit,
    required GetDigitalWellbeingHistoryUseCase getDigitalWellbeingHistory,
    required DigitalWellbeingLocalDataSource localDataSource,
  }) : _getDigitalWellbeing = getDigitalWellbeing,
       _updateDigitalWellbeing = updateDigitalWellbeing,
       _setUsageLimit = setUsageLimit,
       _removeUsageLimit = removeUsageLimit,
       _getDigitalWellbeingHistory = getDigitalWellbeingHistory,
       _localDataSource = localDataSource,
       super(DigitalWellbeingInitial()) {
    on<GetDigitalWellbeingEvent>(_getDigitalWellbeingHandler);
    on<UpdateDigitalWellbeingEvent>(_updateDigitalWellbeingHandler);
    on<SetUsageLimitEvent>(_setUsageLimitHandler);
    on<RemoveUsageLimitEvent>(_removeUsageLimitHandler);
    on<GetDigitalWellbeingHistoryEvent>(_getDigitalWellbeingHistoryHandler);
    on<GetCurrentUserDigitalWellbeingEvent>(_getCurrentUserDigitalWellbeingHandler);
  }

  Future<void> _getCurrentUserDigitalWellbeingHandler(
    GetCurrentUserDigitalWellbeingEvent event,
    Emitter<DigitalWellbeingState> emit,
  ) async {
    emit(DigitalWellbeingLoading());
    try {
      final digitalWellbeing = await _localDataSource.getCurrentUserDigitalWellbeing();
      emit(DigitalWellbeingLoaded(digitalWellbeing: digitalWellbeing));
    } catch (e) {
      emit(DigitalWellbeingError(message: e.toString()));
    }
  }


  



  Future<void> _getDigitalWellbeingHandler(
      GetDigitalWellbeingEvent event,
      Emitter<DigitalWellbeingState> emit,
      ) async {
    emit(DigitalWellbeingLoading());
    final result = await _getDigitalWellbeing(event.childId);
    result.fold(
          (failure) => emit(DigitalWellbeingError(message: failure.message)),
          (digitalWellbeing) => emit(DigitalWellbeingLoaded(digitalWellbeing: digitalWellbeing)),
    );
  }

  Future<void> _updateDigitalWellbeingHandler(
      UpdateDigitalWellbeingEvent event,
      Emitter<DigitalWellbeingState> emit,
      ) async {
    emit(DigitalWellbeingLoading());
    final result = await _updateDigitalWellbeing(event.digitalWellbeing);
    result.fold(
          (failure) => emit(DigitalWellbeingError(message: failure.message)),
          (_) => emit(DigitalWellbeingUpdated()),
    );
  }

  Future<void> _setUsageLimitHandler(
      SetUsageLimitEvent event,
      Emitter<DigitalWellbeingState> emit,
      ) async {
    emit(DigitalWellbeingLoading());
    final result = await _setUsageLimit(SetUsageLimitParams(
      childId: event.childId,
      packageName: event.packageName,
      limit: event.limit,
    ));
    result.fold(
          (failure) => emit(DigitalWellbeingError(message: failure.message)),
          (_) => emit(UsageLimitSet()),
    );
  }


  Future<void> _removeUsageLimitHandler(
      RemoveUsageLimitEvent event,
      Emitter<DigitalWellbeingState> emit,
      ) async {
    emit(DigitalWellbeingLoading());
    final result = await _removeUsageLimit(RemoveUsageLimitParams(
      childId: event.childId,
      packageName: event.packageName,
    ));
    result.fold(
          (failure) => emit(DigitalWellbeingError(message: failure.message)),
          (_) => emit(UsageLimitRemoved()),
    );
  }

  Future<void> _getDigitalWellbeingHistoryHandler(
      GetDigitalWellbeingHistoryEvent event,
      Emitter<DigitalWellbeingState> emit,
      ) async {
    emit(DigitalWellbeingLoading());
    final result = await _getDigitalWellbeingHistory(GetDigitalWellbeingHistoryParams(
      childId: event.childId,
      startDate: event.startDate,
      endDate: event.endDate,
    ));
    result.fold(
          (failure) => emit(DigitalWellbeingError(message: failure.message)),
          (history) => emit(DigitalWellbeingHistoryLoaded(history: history)),
    );
  }
}