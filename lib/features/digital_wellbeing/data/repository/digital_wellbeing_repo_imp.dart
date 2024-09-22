import 'package:dartz/dartz.dart';
import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/core/errors/failure.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/digital_wellbeing/data/data_source/digital_wellbeing_local_data.dart';
import 'package:safenest/features/digital_wellbeing/data/data_source/digital_wellbeing_remote_data.dart';
import 'package:safenest/features/digital_wellbeing/data/model/digital_wellbeing_model.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/digital_wellbeing/domain/repository/digital_wellbeing_repository.dart';
import 'package:safenest/features/notification/data/model/child_task_model.dart';
import 'package:safenest/features/notification/data/model/notification_preference_model.dart';
import 'package:safenest/features/notification/domain/entity/child_task.dart';
import 'package:safenest/features/notification/domain/entity/notification_preference.dart';

class DigitalWellbeingRepoImpl implements DigitalWellbeingRepository {
  final DigitalWellbeingRemoteDataSource _remoteDataSource;
  final DigitalWellbeingLocalDataSource _localDataSource;

  const DigitalWellbeingRepoImpl({
    required DigitalWellbeingRemoteDataSource remoteDataSource,
    required DigitalWellbeingLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

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
  @override
  ResultVoid setNotificationPreferences(String childId, NotificationPreferencesModel preferences) async {
    try {
      await _remoteDataSource.setNotificationPreferences(childId, preferences);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid addChildTask(String childId, ChildTaskModel task) async {
    try {
      await _remoteDataSource.addChildTask(childId, task);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid updateChildTask(String childId, ChildTaskModel task) async {
    try {
      await _remoteDataSource.updateChildTask(childId, task);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid removeChildTask(String childId, String taskId) async {
    try {
      await _remoteDataSource.removeChildTask(childId, taskId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}