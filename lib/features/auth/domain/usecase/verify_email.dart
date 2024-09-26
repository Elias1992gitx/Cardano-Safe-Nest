import 'package:equatable/equatable.dart';
import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/domain/repos/auth_repos.dart';

class VerifyEmail extends UsecaseWithoutParams<void> {
  const VerifyEmail(this._authRepo);
  final AuthenticationRepository _authRepo;

  @override
  ResultFuture<void> call() => _authRepo.verifyEmail();
}

class VerifyEmailParams extends Equatable {
  const VerifyEmailParams();

  const VerifyEmailParams.empty() : this();

  @override
  List<Object?> get props => [];
}
