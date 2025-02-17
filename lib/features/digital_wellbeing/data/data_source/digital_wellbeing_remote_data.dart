import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/features/digital_wellbeing/data/model/digital_wellbeing_model.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/notification/data/model/child_task_model.dart';
import 'package:safenest/features/notification/data/model/notification_preference_model.dart';

abstract class DigitalWellbeingRemoteDataSource {
  Future<DigitalWellbeingModel> getDigitalWellbeing(String childId);
  Future<void> updateDigitalWellbeing(DigitalWellbeingModel digitalWellbeing);
  Future<void> setUsageLimit(String childId, String packageName, UsageLimit limit);
  Future<void> removeUsageLimit(String childId, String packageName);
  Future<void> setNotificationPreferences(String childId, NotificationPreferencesModel preferences);
  Future<void> addChildTask(String childId, ChildTaskModel task);
  Future<void> updateChildTask(String childId, ChildTaskModel task);
  Future<void> removeChildTask(String childId, String taskId);
  Future<List<DigitalWellbeingModel>> getDigitalWellbeingHistory(String childId, DateTime startDate, DateTime endDate);
}

class DigitalWellbeingRemoteDataSourceImpl implements DigitalWellbeingRemoteDataSource {
  final FirebaseDatabase database;
  final FirebaseAuth auth;

  DigitalWellbeingRemoteDataSourceImpl({
    required this.database,
    required this.auth,
  });



  @override
  Future<DigitalWellbeingModel> getDigitalWellbeing(String childId) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        final snapshot = await database.ref().child('digital_wellbeing').child(childId).get();
        if (snapshot.exists) {
          return DigitalWellbeingModel.fromMap(Map<String, dynamic>.from(snapshot.value as Map));
        } else {
          throw const ServerException(message: 'Digital wellbeing data not found', statusCode: 404);
        }
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw ServerException(message: 'Server Error: $e', statusCode: 500);
    }
  }


  @override
  Future<void> updateDigitalWellbeing(DigitalWellbeingModel digitalWellbeing) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await database.ref().child('digital_wellbeing').child(digitalWellbeing.childId).set(digitalWellbeing.toMap());
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw ServerException(message: 'Server Error: $e', statusCode: 500);
    }
  }

  @override
  Future<void> setUsageLimit(String childId, String packageName, UsageLimit limit) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await database.ref().child('digital_wellbeing').child(childId).child('usageLimits').child(packageName).set({
          'dailyLimit': limit.dailyLimit.inSeconds,
          'isEnabled': limit.isEnabled,
        });
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw ServerException(message: 'Server Error: $e', statusCode: 500);
    }
  }

  @override
  Future<void> removeUsageLimit(String childId, String packageName) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await database.ref().child('digital_wellbeing').child(childId).child('usageLimits').child(packageName).remove();
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw ServerException(message: 'Server Error: $e', statusCode: 500);
    }
  }

  @override
  Future<List<DigitalWellbeingModel>> getDigitalWellbeingHistory(String childId, DateTime startDate, DateTime endDate) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        final snapshot = await database.ref()
            .child('digital_wellbeing')
            .child(childId)
            .child('history')
            .orderByChild('date')
            .startAt(startDate.millisecondsSinceEpoch)
            .endAt(endDate.millisecondsSinceEpoch)
            .get();

        if (snapshot.exists) {
          final Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
          return values.entries
              .map((entry) => DigitalWellbeingModel.fromMap(Map<String, dynamic>.from(entry.value as Map)))
              .toList();
        } else {
          return [];
        }
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw ServerException(message: 'Server Error: $e', statusCode: 500);
    }
  }

  @override
  Future<void> setNotificationPreferences(String childId, NotificationPreferencesModel preferences) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await database.ref().child('digital_wellbeing').child(childId).child('notificationPreferences').set(preferences.toMap());
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw ServerException(message: 'Server Error: $e', statusCode: 500);
    }
  }

  @override
  Future<void> addChildTask(String childId, ChildTaskModel task) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        final newTaskRef = database.ref().child('digital_wellbeing').child(childId).child('tasks').push();
        await newTaskRef.set(task.toMap());
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw ServerException(message: 'Server Error: $e', statusCode: 500);
    }
  }

  @override
  Future<void> updateChildTask(String childId, ChildTaskModel task) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await database.ref().child('digital_wellbeing').child(childId).child('tasks').child(task.id).update(task.toMap());
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw ServerException(message: 'Server Error: $e', statusCode: 500);
    }
  }

  @override
  Future<void> removeChildTask(String childId, String taskId) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await database.ref().child('digital_wellbeing').child(childId).child('tasks').child(taskId).remove();
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw ServerException(message: 'Server Error: $e', statusCode: 500);
    }
  }


}