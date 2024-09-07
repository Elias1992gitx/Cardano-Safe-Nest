import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as https;
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/core/services/config.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:safenest/features/auth/data/models/user_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSession extends ChangeNotifier {
  UserSession(this._prefs) {
    _isLoggedIn.add(_prefs.getBool(kIsLoggedIn) ?? false);
  }

  final SharedPreferences _prefs;
  final BehaviorSubject<bool> _isLoggedIn = BehaviorSubject<bool>();
  Stream<bool> get isLoggedIn => _isLoggedIn.stream;
  bool get isLoggedInValue => _isLoggedIn.value;

  void setLoginState(bool isLoggedIn) {
    try {
      _isLoggedIn.add(isLoggedIn);
      _prefs.setBool(kIsLoggedIn, isLoggedIn);
    } catch (e) {
      print('Failed to set login state: $e');
    }
  }

  Future<String?> refreshToken() async {
    try {
      final refreshToken = _prefs.getString('refreshToken');
      if (refreshToken == null) {
        _isLoggedIn.add(false);
        throw const ServerException(
          message: 'No refresh token available', statusCode: 401,
        );
      }

      final requestHeaders = <String, String>{
        'Authorization': 'Bearer $refreshToken',
      };

      final url = Uri.https(Config.apiUrl, Config.refreshTokenUrl);
      final response = await https.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'] as String;
        final newRefreshToken = data['refreshToken'] as String? ?? refreshToken;

        await _prefs.setString('accessToken', newAccessToken);
        await _prefs.setString('refreshToken', newRefreshToken);
        return newAccessToken;
      } else if (response.statusCode == 401) {
        _isLoggedIn.add(false);
        await logout();
        throw const ServerException(
            message: 'Refresh token expired', statusCode: 401);
      } else {
        throw ServerException(
          message: 'Failed to refresh token',
          statusCode: response.statusCode,
        );
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(message: e.toString(), statusCode: 400);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut(); // Firebase sign out
    await _prefs.clear();
    _isLoggedIn.add(false);
  }

  @override
  void dispose() {
    _isLoggedIn.close();
    super.dispose();
  }

  Stream<bool> emailVerificationStatus() async* {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      yield false;
      return;
    }

    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      await user.reload();
      if (user.emailVerified) {
        yield true;
        return;
      }
      yield false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> resendVerificationEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
}