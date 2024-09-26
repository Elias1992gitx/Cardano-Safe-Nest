import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/domain/entities/user.dart';
import 'package:safenest/features/auth/domain/repos/auth_repos.dart';

class SignInWithGoogle extends UsecaseWithoutParams<LocalUser> {

  SignInWithGoogle(this._authRepo);
  final AuthenticationRepository _authRepo;

  @override
  ResultFuture<LocalUser> call() => _authRepo.signInWithGoogle();
}
