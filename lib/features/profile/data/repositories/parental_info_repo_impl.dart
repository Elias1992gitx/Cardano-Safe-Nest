import 'package:dartz/dartz.dart';
import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/core/errors/failure.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/profile/data/data_sources/parental_info_remote_data_source.dart';
import 'package:safenest/features/profile/data/models/parental_info_model.dart';
import 'package:safenest/features/profile/data/models/child_model.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';
import 'package:safenest/features/profile/domain/entity/parental_info.dart';
import 'package:safenest/features/profile/domain/repos/parental_info_repository.dart';

class ParentalInfoRepoImpl implements ParentalInfoRepository {
  final ParentalInfoRemoteDataSource _remoteDataSource;

  const ParentalInfoRepoImpl(this._remoteDataSource);

  @override
  ResultVoid saveParentalInfo(ParentalInfo parentalInfo) async {
    try {
      await _remoteDataSource.saveParentalInfo(
        ParentalInfoModel.fromEntity(parentalInfo),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<ParentalInfo> getParentalInfo() async {
    try {
      final result = await _remoteDataSource.getParentalInfo();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid updateParentalInfo(ParentalInfo parentalInfo) async {
    try {
      await _remoteDataSource.updateParentalInfo(
        ParentalInfoModel.fromEntity(parentalInfo),
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid addChild(Child child) async {
    try {
      await _remoteDataSource.addChild(ChildModel.fromEntity(child));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid updateChild(Child child) async {
    try {
      await _remoteDataSource.updateChild(ChildModel.fromEntity(child));
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid removeChild(String childId) async {
    try {
      await _remoteDataSource.removeChild(childId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid setPin(String pin) async {
    try {
      await _remoteDataSource.setPin(pin);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}