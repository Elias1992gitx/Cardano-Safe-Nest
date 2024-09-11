import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/features/digital_wellbeing/data/model/digital_wellbeing_model.dart';
import 'package:safenest/features/digital_wellbeing/domain/entity/digital_wellbeing.dart';
import 'package:safenest/features/notification/data/model/child_task_model.dart';
import 'package:safenest/features/notification/data/model/notification_preference_model.dart';
import 'package:safenest/features/notification/domain/entity/child_task.dart';
import 'package:safenest/features/notification/domain/entity/notification_preference.dart';

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
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  DigitalWellbeingRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  

  @override
  Future<DigitalWellbeingModel> getDigitalWellbeing(String childId) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        final doc = await firestore.collection('digital_wellbeing').doc(childId).get();
        if (doc.exists) {
          return DigitalWellbeingModel.fromMap(doc.data()!);
        } else {
          throw const ServerException(message: 'Digital wellbeing data not found', statusCode: 404);
        }
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 500);
    }
  }

  @override
  Future<void> updateDigitalWellbeing(DigitalWellbeingModel digitalWellbeing) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore.collection('digital_wellbeing').doc(digitalWellbeing.childId).set(digitalWellbeing.toMap());
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 500);
    }
  }

  @override
  Future<void> setUsageLimit(String childId, String packageName, UsageLimit limit) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore.collection('digital_wellbeing').doc(childId).update({
          'usageLimits.$packageName': {
            'dailyLimit': limit.dailyLimit.inSeconds,
            'isEnabled': limit.isEnabled,
          },
        });
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 500);
    }
  }

  @override
  Future<void> removeUsageLimit(String childId, String packageName) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore.collection('digital_wellbeing').doc(childId).update({
          'usageLimits.$packageName': FieldValue.delete(),
        });
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 500);
    }
  }

  @override
  Future<List<DigitalWellbeingModel>> getDigitalWellbeingHistory(String childId, DateTime startDate, DateTime endDate) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        final querySnapshot = await firestore.collection('digital_wellbeing')
            .where('childId', isEqualTo: childId)
            .where('date', isGreaterThanOrEqualTo: startDate)
            .where('date', isLessThanOrEqualTo: endDate)
            .get();

        return querySnapshot.docs.map((doc) => DigitalWellbeingModel.fromMap(doc.data())).toList();
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 500);
    }
  }

  @override
  Future<void> setNotificationPreferences(String childId, NotificationPreferencesModel preferences) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore.collection('digital_wellbeing').doc(childId).update({
          'notificationPreferences': preferences.toMap(),
        });
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 500);
    }
  }

  @override
  Future<void> addChildTask(String childId, ChildTaskModel task) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore.collection('digital_wellbeing').doc(childId).collection('tasks').add(task.toMap());
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 500);
    }
  }

  @override
  Future<void> updateChildTask(String childId, ChildTaskModel task) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore.collection('digital_wellbeing').doc(childId).collection('tasks').doc(task.id).update(task.toMap());
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 500);
    }
  }

  @override
  Future<void> removeChildTask(String childId, String taskId) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore.collection('digital_wellbeing').doc(childId).collection('tasks').doc(taskId).delete();
      } else {
        throw const ServerException(message: 'User not authenticated', statusCode: 401);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 500);
    }
  }
}