import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:safenest/core/errors/failure.dart';
import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/profile/domain/entity/scan_result.dart';
import 'package:safenest/features/profile/domain/repos/profile_repository.dart';

class ScanDigitalId extends UsecaseWithParams<void, ScanResultParams> {
  const ScanDigitalId(this._repository);
  final ProfileRepository _repository;

  @override
  ResultFuture<ScanResult> call(ScanResultParams params) {
    if (params.firstPage != null) {
      return _repository.scanPassport(
        firstPage: params.firstPage!,
      );
    } else {
      return _repository.scanDigitalId(
        front: params.front!,
        back: params.back!,
      );
    }
  }
}

class ScanResultParams extends Equatable {
  const ScanResultParams({
    this.front,
    this.back,
    this.firstPage,
  });
  final File? front;
  final File? back;
  final File? firstPage;

  @override
  List<Object?> get props => [front, back, firstPage];
}
