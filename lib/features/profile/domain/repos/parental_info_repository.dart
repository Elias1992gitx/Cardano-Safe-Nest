import 'package:dartz/dartz.dart';
import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';
import 'package:safenest/features/profile/domain/entity/parental_info.dart';

abstract class ParentalInfoRepository {
  ResultVoid saveParentalInfo(ParentalInfo parentalInfo);
  ResultFuture<ParentalInfo> getParentalInfo();
  ResultVoid updateParentalInfo(ParentalInfo parentalInfo);
  ResultVoid addChild(Child child);
  ResultVoid updateChild(Child child);
  ResultVoid removeChild(String childId);
  ResultVoid setPin(String pin);
}