import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as https;
import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/core/services/config.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/data/models/user_model.dart';
import 'package:safenest/features/auth/domain/repos/auth_repos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {

  UserProvider() {
    _init();
  }

  LocalUserModel? _user;
  LocalUserModel? get user => _user;
  StreamSubscription<User?>? _authStateSubscription;

  Future<void> _init() async {
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _user = null;
      } else {
        loadUserData();
      }
      notifyListeners();
    });
  }

  void initUser(LocalUserModel? user) {
    if (_user != user) {
      _user = user;
      notifyListeners();
    }
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final userDataString = prefs.getString('userData');
      if (userDataString != null) {
        final userDataMap = jsonDecode(userDataString) as DataMap;
        final userInfo = LocalUserModel.fromMap(userDataMap);
        initUser(userInfo);
      } else {
        final userInfo = await getUserInfo(userId);
        initUser(userInfo);
      }
    }
  }

  Future<LocalUserModel> getUserInfo(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return LocalUserModel.fromMap(userDoc.data()!);
      } else {
        throw const ServerException(
          message: 'User not found',
          statusCode: '404',
        );
      }
    } on SocketException {
      throw const ConnectivityException(message: 'No Internet Connection');
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  Future<void> updateUser(LocalUserModel updatedUser) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(updatedUser.uid).update(updatedUser.toMap());
      initUser(updatedUser);
    } catch (e) {
      throw const ServerException(
        message: 'Failed to update user',
        statusCode: '500',
      );
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}