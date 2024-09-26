
import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/on_boarding/domain/repos/on_boarding_repo.dart';

class CheckIfUserFirstTimer extends UsecaseWithoutParams<bool>{
  const CheckIfUserFirstTimer(this._repo);
  final OnBoardingRepo _repo;
  @override
  ResultFuture<bool> call() async => _repo.checkIfUserIsFirstTimer();
}
