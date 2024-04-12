import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';

typedef FutureEmailCheck<T> = Future<Either<Failure, T>>;
typedef FutureShare<T> = Future<Either<Failure, T>>;
typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureTypes<T> = Either<Failure, T>;
typedef FutureVoid = FutureEither<void>;
