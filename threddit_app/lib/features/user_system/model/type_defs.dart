import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:tuple/tuple.dart';

typedef FutureEmailCheck<T> = Future<Either<Failure, T>>;
typedef FutureShare<T> = Future<Either<Failure, T>>;
typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherTuple<T> = Future<Either<Failure, Tuple2<T, T>>>;
typedef FutureTypes<T> = Either<Failure, T>;
typedef FutureVoid = FutureEither<void>;
