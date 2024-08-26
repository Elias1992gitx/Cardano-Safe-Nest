import 'package:equatable/equatable.dart';
import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/domain/entities/user.dart';
import 'package:safenest/features/auth/domain/repos/auth_repos.dart';

class SignIn extends UsecaseWithParams<void,SignInParams>{
  const SignIn(this._authRepo);

  final AuthenticationRepository _authRepo;

  @override
  ResultFuture<LocalUser> call(SignInParams params) => _authRepo.signIn(
    email: params.email,
    password: params.password,
  );

}

class SignInParams extends Equatable{

  const SignInParams({
    required this.email,
    required this.password,
  });

  const SignInParams.empty():this(
    email: '',
    password:'',
  );

  final String email;
  final String password;

  @override
  List<Object?> get props => [email,password];

}
