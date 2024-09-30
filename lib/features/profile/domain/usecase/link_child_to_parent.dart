import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:safenest/core/usecase/usecase.dart';
import 'package:safenest/features/profile/domain/repos/parental_info_repository.dart';
import 'package:safenest/core/errors/failure.dart';





class LinkChildToParent implements UsecaseWithParams<void, LinkChildToParentParams> {
  final ParentalInfoRepository repository;

  LinkChildToParent(this.repository);

  @override
  Future<Either<Failure, void>> call(LinkChildToParentParams params) async {
    return await repository.linkChildToParent(params.childId, params.parentId);
  }
}

class LinkChildToParentParams extends Equatable {
  final String childId;
  final String parentId;

  const LinkChildToParentParams({required this.childId, required this.parentId});

  @override
  List<Object?> get props => [childId, parentId];
}