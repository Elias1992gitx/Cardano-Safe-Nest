import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:safenest/core/enum/user/update_user.dart';
import 'package:safenest/core/errors/exceptions.dart';
import 'package:safenest/core/utils/constants.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();
  Future<void> forgotPassword({required String email});

  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<LocalUserModel> signInWithGoogle();

  Future<LocalUserModel> signInWithFacebook();

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> verifyEmail();

  Stream<LocalUserModel> getUserProfileStream(String uid);

  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });

  Future<void> logout();
}

const kIsLoggedIn = 'isLoggedIn';
const kIsProfileComplete = 'isProfileComplete';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FacebookAuth facebookAuthClient,
    required GoogleSignIn googleSignIn,
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
  })  : _facebookAuthClient = facebookAuthClient,
        _googleSignIn = googleSignIn,
        _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;

  final FacebookAuth _facebookAuthClient;
  final GoogleSignIn _googleSignIn;

  Stream<bool> emailVerificationStatus() async* {
    final user = _authClient.currentUser;
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

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      if (user != null) {
        var userData = await _getUserData(user.uid);  
        print(userData.data());
        if (userData.exists) {
          final localUser = LocalUserModel.fromMap(userData.data()!);
          await _cacheUserData(localUser);
          return localUser;
        }
        await _setUserData(
          user,
          email,
        );
        userData = await _getUserData(user.uid);
        final localUser = LocalUserModel.fromMap(userData.data()!);
        await _cacheUserData(localUser);
        return localUser;
      } else {
        throw const ServerException(
          message: 'Failed to sign in',
          statusCode: 505,
        );
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<LocalUserModel> signInWithFacebook() async {
    try {
      final result = await _facebookAuthClient.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);
        final userCredential =
            await _authClient.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          var userData = await _getUserData(user.uid);
          if (userData.exists) {
            return LocalUserModel.fromMap(userData.data()!);
          }
          await _setUserData(
            user,
            user.email!,
          );
          userData = await _getUserData(user.uid);
          return LocalUserModel.fromMap(userData.data()!);
        } else {
          throw const ServerException(
            message: 'Failed to sign in',
            statusCode: 505,
          );
        }
      } else {
        throw const ServerException(
          message: 'Failed to sign in',
          statusCode: 400,
        );
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<LocalUserModel> signInWithGoogle() async {
    try {
      final result = await _googleSignIn.signIn();

      if (result != null) {
        final googleAuth = await result.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential =
            await _authClient.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          var userData = await _getUserData(user.uid);
          if (userData.exists) {
            return LocalUserModel.fromMap(userData.data()!);
          }
          await _setUserData(
            user,
            user.email!,
          );
          userData = await _getUserData(user.uid);
          return LocalUserModel.fromMap(userData.data()!);
        } else {
          throw const ServerException(
            message: 'Failed to sign in',
            statusCode: 505,
          );
        }
      } else {
        throw const ServerException(
          message: 'Failed to sign in',
          statusCode: 400,
        );
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.updatePhotoURL(kDefaultAvatar);
        await _setUserData(_authClient.currentUser!, user.email!);
      } else {
        throw const ServerException(
          message: 'Failed to sign up',
          statusCode: 505,
        );
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<void> verifyEmail() async {
    try {
      final user = _authClient.currentUser;
      if (user != null && user.emailVerified) {
        return;
      } else {
        throw const ServerException(
          message: 'Email not verified',
          statusCode: 400,
        );
      }
    } on SocketException {
      throw const ConnectivityException(message: "No Internet Connection");
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      final user = _authClient.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'No user signed in',
          statusCode: 401,
        );
      }

      switch (action) {
        case UpdateUserAction.displayName:
          await user.updateDisplayName(userData as String);
          break;
        case UpdateUserAction.photoURL:
          await user.updatePhotoURL(userData as String);
          break;

        case UpdateUserAction.password:
          break;
      }

      final updatedUser = LocalUserModel(
        uid: user.uid,
        email: user.email!,
        username: user.displayName ?? '',
        profilePic: user.photoURL ?? '',
        // Add other fields as needed
      );

      await _cloudStoreClient
          .collection('users')
          .doc(user.uid)
          .update(updatedUser.toMap());
      await _cacheUserData(updatedUser);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  @override
  Future<void> forgotPassword({required String email}) {
    throw UnimplementedError();
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _cloudStoreClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(
  User user,
  String fallbackEmail,
) async {
  await _cloudStoreClient.collection('users').doc(user.uid).set(
        LocalUserModel(
          email: user.email ?? fallbackEmail,
          uid: user.uid,
          username: user.displayName ?? "",
          phoneNumber: user.phoneNumber,
          profilePic: user.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isTwoFactorEnabled: false,
          monitoredApps: [],
        ).toMap(),
      );
}

  @override
  Stream<LocalUserModel> getUserProfileStream(String uid) {
    return _cloudStoreClient
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      return LocalUserModel.fromMap(snapshot.data()!);
    });
  }

  @override
  Future<void> logout() async {
    try {
      await _authClient.signOut();

      try {
        await _facebookAuthClient.logOut();
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
      }
      try {
        await _googleSignIn.signOut();
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
      }
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: 505,
      );
    }
  }

  Future<void> _cacheUserData(LocalUserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.uid);
    await prefs.setString('userData', jsonEncode(user.toMap()));
  }


}


