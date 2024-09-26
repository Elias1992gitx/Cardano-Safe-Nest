import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/auth/domain/repos/auth_repos.dart';

class LogoutUseCase extends UsecaseWithoutParams<void> {
  final AuthenticationRepository repository;

  LogoutUseCase(this.repository);

  @override
  ResultFuture<void> call() async {
    return repository.logout();
  }
}