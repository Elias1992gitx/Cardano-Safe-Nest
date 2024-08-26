import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/domain/repos/auth_repos.dart';

class LogoutUseCase extends UsecaseWithoutParams<void>{
  LogoutUseCase(this.repository);
  final AuthenticationRepository repository;

  @override
  ResultFuture call() async {
    return repository.logout();
  }
}
