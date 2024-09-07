import 'package:safenest/core/common/app/providers/user_session.dart';
import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/domain/repos/auth_repos.dart';

class LogoutUseCase extends UsecaseWithoutParams<void> {
  final AuthenticationRepository repository;
  final UserSession userSession;

  LogoutUseCase(this.repository, this.userSession);

  @override
  ResultFuture call() async {
    await userSession.logout();
    return repository.logout();
  }
}
