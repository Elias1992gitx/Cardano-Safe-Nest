import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:safenest/features/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:safenest/features/on_boarding/domain/usecases/check_if_user_first_timer.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  OnBoardingCubit(
      {required CacheFirstTimer cacheFirstTimer,
        required CheckIfUserFirstTimer checkIfUserFirstTimer})
      : _cacheFirstTimer = cacheFirstTimer,
        _checkIfUserFirstTimer = checkIfUserFirstTimer,
        super(const OnBoardingInitial());

  CheckIfUserFirstTimer _checkIfUserFirstTimer;
  CacheFirstTimer _cacheFirstTimer;

  Future<void> cacheFirstTimer() async {
    emit(const CachingFirstTimer());
    final result = await _cacheFirstTimer();

    result.fold(
          (failure)=>emit(OnBoardingError(failure.errorMessage)),
          (_) =>emit(const UserCached()),
    );
  }

  Future<void> checkIfUserFirstTimer() async {
    emit(const CheckIfUserIsFirstTimer());
    final result = await _checkIfUserFirstTimer();
    result.fold(
          (failure) => emit(const OnBoardingStatus(isFirstTimer: true)),
          (isFirstTimer) => emit(OnBoardingStatus(isFirstTimer: isFirstTimer)),
    );
  }
}
