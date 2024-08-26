import 'package:safenest/core/enum/user/update_user.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/data/models/user_model.dart';
import 'package:safenest/features/auth/domain/entities/user.dart';

abstract class AuthenticationRepository{

  const AuthenticationRepository();

  ResultFuture<void> forgotPassword({
    required String email,
  });
  Stream<LocalUserModel> getUserProfileStream(String uid);

  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });

  ResultFuture<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  ResultFuture<LocalUser> signInWithGoogle();

  ResultFuture<LocalUser> signInWithFacebook();

  ResultFuture<void> verifyEmail();

  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });

  ResultFuture<void> logout();

}
