import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEmailCheck<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
