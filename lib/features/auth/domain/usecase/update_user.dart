import 'package:equatable/equatable.dart';
import 'package:safenest/core/enum/user/update_user.dart';
import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/domain/repos/auth_repos.dart';

class UpdateUser extends UsecaseWithParams<void, UpdateUserParams> {
  const UpdateUser(this._authRepo);
  final AuthenticationRepository _authRepo;

  @override
  ResultFuture<void> call(UpdateUserParams params) =>
      _authRepo.updateUser(action: params.action, userData: params.userData);
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({
    required this.action,
    required this.userData,
  });

  const UpdateUserParams.empty()
      : this(
    action: UpdateUserAction.displayName,
    userData: '',
  );

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<Object?> get props => [action, userData];
}
