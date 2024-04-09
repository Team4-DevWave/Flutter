import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';

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

// final isNewProvider = StateProvider<bool>((ref) => false);
// final isEmailUsedProvider = StateProvider<bool>((ref) => false);
// final loginSucceeded = StateProvider<bool>((ref) => false);
final enteredValue = StateProvider<String?>((ref) => null);
final isUserNameUsedProvider = StateProvider<bool>(((ref) => false));
final signUpSuccess = StateProvider<bool>((ref) => false);
final enteredAccoutValue = StateProvider<String?>(((ref) => null));
// final forgotPasswordSuccess = StateProvider<bool>(((ref) => false));
// final forgotUsernameSuccess = StateProvider<bool>(((ref) => false));
final forgotType = StateProvider<String?>(((ref) => null));
