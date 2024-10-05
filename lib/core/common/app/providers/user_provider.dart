import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/data/models/user_model.dart';
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
    await loadUserData();
    _authStateSubscription =
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _user = null;
        _clearUserData();
      } else if (_user == null) {
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
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      try {
        final userDataMap = jsonDecode(userDataString) as Map<String, dynamic>;

        // Convert ISO 8601 strings back to DateTime objects
        userDataMap['createdAt'] = userDataMap['createdAt'] != null
            ? DateTime.parse(userDataMap['createdAt'])
            : null;
        userDataMap['updatedAt'] = userDataMap['updatedAt'] != null
            ? DateTime.parse(userDataMap['updatedAt'])
            : null;
        userDataMap['emailVerified'] = userDataMap['emailVerified'] != null
            ? DateTime.parse(userDataMap['emailVerified'])
            : null;

        final userInfo = LocalUserModel.fromMap(userDataMap);
        initUser(userInfo);
      } catch (e) {
        print('Error parsing user data: $e');
        await _clearUserData();
      }
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userInfo = await getUserInfo(user.uid);
        await _saveUserData(userInfo);
        initUser(userInfo);
      }
    }
  }

  Future<LocalUserModel> getUserInfo(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedUser.uid)
          .update(updatedUser.toMap());
      initUser(updatedUser);
    } catch (e) {
      throw const ServerException(
        message: 'Failed to update user',
        statusCode: '500',
      );
    }
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    await prefs.remove('userId');
  }

  Future<void> _saveUserData(LocalUserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = user.toMap();

    // Convert DateTime objects to ISO 8601 strings
    userData['createdAt'] = userData['createdAt']?.toIso8601String();
    userData['updatedAt'] = userData['updatedAt']?.toIso8601String();
    userData['emailVerified'] = userData['emailVerified']?.toIso8601String();

    await prefs.setString('userData', jsonEncode(userData));
    await prefs.setString('userId', user.uid);
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
