import 'package:dartz/dartz.dart';
import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/core/errors/failure.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/digital_wellbeing/data/data_source/digital_wellbeing_remote_data.dart';
import 'package:safenest/features/digital_wellbeing/data/model/digital_wellbeing_model.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/digital_wellbeing/domain/repository/digital_wellbeing_repository.dart';

class DigitalWellbeingRepoImpl implements DigitalWellbeingRepository {
  final DigitalWellbeingRemoteDataSource _remoteDataSource;

  const DigitalWellbeingRepoImpl(this._remoteDataSource);

  @override
  ResultFuture<DigitalWellbeing> getDigitalWellbeing(String childId) async {
    try {
      final result = await _remoteDataSource.getDigitalWellbeing(childId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid updateDigitalWellbeing(DigitalWellbeing digitalWellbeing) async {
    try {
      await _remoteDataSource.updateDigitalWellbeing(digitalWellbeing as DigitalWellbeingModel);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid setUsageLimit(String childId, String packageName, UsageLimit limit) async {
    try {
      await _remoteDataSource.setUsageLimit(childId, packageName, limit);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid removeUsageLimit(String childId, String packageName) async {
    try {
      await _remoteDataSource.removeUsageLimit(childId, packageName);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<List<DigitalWellbeing>> getDigitalWellbeingHistory(String childId, DateTime startDate, DateTime endDate) async {
    try {
      final result = await _remoteDataSource.getDigitalWellbeingHistory(childId, startDate, endDate);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid cleanOldData() {
    // TODO: implement cleanOldData
    throw UnimplementedError();
  }
}