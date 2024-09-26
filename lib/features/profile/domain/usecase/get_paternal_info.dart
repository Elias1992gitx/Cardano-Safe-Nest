import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/profile/domain/repos/parental_info_repository.dart';
import 'package:safenest/features/profile/domain/entity/parental_info.dart';

class GetParentalInfoUseCase extends UsecaseWithoutParams<ParentalInfo> {
  const GetParentalInfoUseCase(this._repository);

  final ParentalInfoRepository _repository;

  @override
  ResultFuture<ParentalInfo> call() async => _repository.getParentalInfo();
}