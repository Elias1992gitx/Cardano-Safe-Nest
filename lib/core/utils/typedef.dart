import 'package:dartz/dartz.dart';
import 'package:safenest/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure,T>>;
typedef ResultVoid = ResultFuture<void>;
typedef ResultStream<T> = Stream<Either<Failure, T>>;
typedef DataMap = Map<String,dynamic>;
