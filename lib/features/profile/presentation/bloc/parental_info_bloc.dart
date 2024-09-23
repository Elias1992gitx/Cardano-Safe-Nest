import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safenest/features/profile/domain/entity/parental_info.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';
import 'package:safenest/features/profile/domain/usecase/add_child_usecase.dart';
import 'package:safenest/features/profile/data/models/parental_info_model.dart';
import 'package:safenest/features/profile/domain/usecase/get_paternal_info.dart';
import 'package:safenest/features/profile/domain/usecase/save_parental_info.dart';
import 'package:safenest/features/profile/domain/usecase/update_child_usecase.dart';
import 'package:safenest/features/profile/domain/usecase/remove_child_usecase.dart';
import 'package:safenest/features/profile/domain/usecase/set_pin_usecase.dart';
import 'package:safenest/features/profile/domain/usecase/update_paternal_info.dart';

part 'parental_info_event.dart';
part 'parental_info_state.dart';

class ParentalInfoBloc extends Bloc<ParentalInfoEvent, ParentalInfoState> {
  final SaveParentalInfoUseCase _saveParentalInfo;
  final GetParentalInfoUseCase _getParentalInfo;
  final UpdateParentalInfoUseCase _updateParentalInfo;
  final AddChildUseCase _addChild;
  final UpdateChildUseCase _updateChild;
  final RemoveChildUseCase _removeChild;
  final SetPinUseCase _setPin;

  ParentalInfoBloc({
    required SaveParentalInfoUseCase saveParentalInfo,
    required GetParentalInfoUseCase getParentalInfo,
    required UpdateParentalInfoUseCase updateParentalInfo,
    required AddChildUseCase addChild,
    required UpdateChildUseCase updateChild,
    required RemoveChildUseCase removeChild,
    required SetPinUseCase setPin,
  }) : _saveParentalInfo = saveParentalInfo,
       _getParentalInfo = getParentalInfo,
       _updateParentalInfo = updateParentalInfo,
       _addChild = addChild,
       _updateChild = updateChild,
       _removeChild = removeChild,
       _setPin = setPin,
       super(ParentalInfoInitial()) {
    on<SaveParentalInfoEvent>(_saveParentalInfoHandler);
    on<GetParentalInfoEvent>(_getParentalInfoHandler);
    on<UpdateParentalInfoEvent>(_updateParentalInfoHandler);
    on<AddChildEvent>(_addChildHandler);
    on<UpdateChildEvent>(_updateChildHandler);
    on<RemoveChildEvent>(_removeChildHandler);
    on<SetPinEvent>(_setPinHandler);
  }

  Future<void> _cacheParentalInfo(ParentalInfoModel parentalInfo) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('parental_info', json.encode(parentalInfo.toMap()));
  }

  Future<ParentalInfoModel?> _getCachedParentalInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('parental_info');
    if (jsonString != null) {
      return ParentalInfoModel.fromMap(json.decode(jsonString));
    }
    return null;
  }



  Future<void> _saveParentalInfoHandler(
    SaveParentalInfoEvent event,
    Emitter<ParentalInfoState> emit,
  ) async {
    emit(ParentalInfoLoading());
    final result = await _saveParentalInfo(event.parentalInfo);
    result.fold(
      (failure) => emit(ParentalInfoError(failure.errorMessage)),
      (_) => emit(ParentalInfoSaved()),
    );
  }

  Future<void> _getParentalInfoHandler(
    GetParentalInfoEvent event,
    Emitter<ParentalInfoState> emit,
  ) async {
    emit(ParentalInfoLoading());
    final result = await _getParentalInfo();
    result.fold(
      (failure) => emit(ParentalInfoError(failure.errorMessage)),
      (parentalInfo) => emit(ParentalInfoLoaded(parentalInfo)),
    );
  }

  Future<void> _updateParentalInfoHandler(
    UpdateParentalInfoEvent event,
    Emitter<ParentalInfoState> emit,
  ) async {
    emit(ParentalInfoLoading());
    final result = await _updateParentalInfo(event.parentalInfo);
    result.fold(
      (failure) => emit(ParentalInfoError(failure.errorMessage)),
      (_) => emit(ParentalInfoUpdated()),
    );
  }

  Future<void> _addChildHandler(
    AddChildEvent event,
    Emitter<ParentalInfoState> emit,
  ) async {
    emit(ParentalInfoLoading());
    final result = await _addChild(event.child);
    result.fold(
      (failure) => emit(ParentalInfoError(failure.errorMessage)),
      (_) => emit(ChildAdded()),
    );
  }

  Future<void> _updateChildHandler(
    UpdateChildEvent event,
    Emitter<ParentalInfoState> emit,
  ) async {
    emit(ParentalInfoLoading());
    final result = await _updateChild(event.child);
    result.fold(
      (failure) => emit(ParentalInfoError(failure.errorMessage)),
      (_) => emit(ChildUpdated()),
    );
  }

  Future<void> _removeChildHandler(
    RemoveChildEvent event,
    Emitter<ParentalInfoState> emit,
  ) async {
    emit(ParentalInfoLoading());
    final result = await _removeChild(event.childId);
    result.fold(
      (failure) => emit(ParentalInfoError(failure.errorMessage)),
      (_) => emit(ChildRemoved()),
    );
  }

  Future<void> _setPinHandler(
    SetPinEvent event,
    Emitter<ParentalInfoState> emit,
  ) async {
    emit(ParentalInfoLoading());
    final result = await _setPin(event.pin);
    result.fold(
      (failure) => emit(ParentalInfoError(failure.errorMessage)),
      (_) => emit(PinSet()),
    );
  }
}