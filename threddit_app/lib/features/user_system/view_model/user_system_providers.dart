import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';

///This user provider is a [StateProvider] that holds a state of an object from the
///[UserModel] and updated throught the whole app in the registration process.
final userProvider = StateProvider<UserModel?>(
  (ref) => UserModel(
    username: '',
    email: '',
    password: '',
    passwordConfirm: '',
    country: '',
    gender: '',
    token: '',
    isGoogle: false,
    interests: [],
  ),
);

///This provider is used to update and retreive the entered value in the screens
final enteredValue = StateProvider<String?>((ref) => null);

///This provider is used to update and retreive thet state of the entered user name used
final isUserNameUsedProvider = StateProvider<bool>(((ref) => false));

///This provider is used to update and retreive the state of the sign up process
final signUpSuccess = StateProvider<bool>((ref) => false);

///This provider is used to update and retreive the entered value in the screens
final enteredAccoutValue = StateProvider<String?>(((ref) => null));

///This provider is used to update and retreive the type of the forgot chosen; forgot username, forgot password
final forgotType = StateProvider<String?>(((ref) => null));
