import 'package:dartz/dartz.dart';
import 'package:safenest/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure,T>>;
typedef ResultVoid = ResultFuture<void>;
typedef DataMap = Map<String,dynamic>;
