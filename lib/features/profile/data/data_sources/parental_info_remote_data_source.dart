import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safenest/features/profile/data/isolates/connection_isolate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/features/profile/data/models/parental_info_model.dart';
import 'package:safenest/features/profile/data/models/child_model.dart';

abstract class ParentalInfoRemoteDataSource {
  Future<void> saveParentalInfo(ParentalInfoModel parentalInfo);
  Future<ParentalInfoModel> getParentalInfo();
  Future<void> updateParentalInfo(ParentalInfoModel parentalInfo);
  Future<void> addChild(ChildModel child);
  Future<void> updateChild(ChildModel child);
  Future<void> removeChild(String childId);
  Future<void> linkChildToParent(String childId, String parentId);
  Future<void> linkChildToParentWithIsolate(String childId, String parentId);
  Future<void> setPin(String pin);
}

class ParentalInfoRemoteDataSourceImpl implements ParentalInfoRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ParentalInfoRemoteDataSourceImpl({
    required this.firestore,
    required this.auth,
  });

  @override
  Future<void> linkChildToParentWithIsolate(
      String childId, String parentId) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(connectionIsolate, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();

    sendPort.send({
      'childId': childId,
      'parentId': parentId,
      'dataSource': this,
    });

    final response = await responsePort.first;
    if (response['success'] == true) {
      return;
    } else {
      throw ServerException(message: response['error'], statusCode: 500);
    }
  }

  @override
  Future<void> saveParentalInfo(ParentalInfoModel parentalInfo) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore
            .collection('parental_info')
            .doc(user.uid)
            .set(parentalInfo.toMap());
      } else {
        throw const ServerException(message: 'Server Error', statusCode: 501);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 501);
    }
  }

  @override
  Future<ParentalInfoModel> getParentalInfo() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        final doc =
            await firestore.collection('parental_info').doc(user.uid).get();
        if (doc.exists) {
          return ParentalInfoModel.fromMap(doc.data()!);
        } else {
          throw const ServerException(message: 'Server Error', statusCode: 501);
        }
      } else {
        throw const ServerException(message: 'Server Error', statusCode: 501);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 501);
    }
  }

  @override
  Future<void> updateParentalInfo(ParentalInfoModel parentalInfo) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore
            .collection('parental_info')
            .doc(user.uid)
            .update(parentalInfo.toMap());
      } else {
        throw const ServerException(message: 'Server Error', statusCode: 501);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 501);
    }
  }

  @override
  Future<void> addChild(ChildModel child) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore.collection('children').doc(child.id).set(child.toMap());

        await firestore.collection('parental_info').doc(user.uid).update({
          'children': FieldValue.arrayUnion([child.id])
        });
      } else {
        throw const ServerException(message: 'Server Error', statusCode: 501);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 501);
    }
  }

  @override
  Future<void> linkChildToParent(String childId, String parentId) async {
    try {
      final childDoc =
          await firestore.collection('children').doc(childId).get();
      if (childDoc.exists) {
        await firestore.collection('children').doc(childId).update({
          'parentId': parentId,
          'linkedAt': FieldValue.serverTimestamp(),
        });

        await firestore.collection('parental_info').doc(parentId).update({
          'children': FieldValue.arrayUnion([childId])
        });
      } else {
        throw const ServerException(
            message: 'Child not found', statusCode: 404);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 500);
    }
  }

  @override
  Future<void> updateChild(ChildModel child) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore
            .collection('parental_info')
            .doc(user.uid)
            .collection('children')
            .doc(child.id)
            .update(child.toMap());
      } else {
        throw const ServerException(message: 'Server Error', statusCode: 501);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 501);
    }
  }

  @override
  Future<void> removeChild(String childId) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore
            .collection('parental_info')
            .doc(user.uid)
            .collection('children')
            .doc(childId)
            .delete();
      } else {
        throw const ServerException(message: 'Server Error', statusCode: 501);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 501);
    }
  }

  @override
  Future<void> setPin(String pin) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await firestore
            .collection('parental_info')
            .doc(user.uid)
            .update({'pin': pin});
      } else {
        throw const ServerException(message: 'Server Error', statusCode: 501);
      }
    } catch (e) {
      throw const ServerException(message: 'Server Error', statusCode: 501);
    }
  }
}
