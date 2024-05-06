import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';

///This is used to manage the response of RESTful request where the failure message in the right and
///response is generic type [T] on the left
typedef FutureEmailCheck<T> = Future<Either<Failure, T>>;

///This is used to manage the response of RESTful request where the failure message in the right and
///response is generic type [T] on the left
typedef FutureEither<T> = Future<Either<Failure, T>>;
