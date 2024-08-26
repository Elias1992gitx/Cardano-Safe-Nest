import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/domain/repos/auth_repos.dart';

class ForgotPassword extends UsecaseWithParams<void,String>{

  const ForgotPassword(this._authRepo);

  final AuthenticationRepository _authRepo;
  @override
  ResultFuture<void> call(String params) =>
      _authRepo.forgotPassword(email: params);
}
