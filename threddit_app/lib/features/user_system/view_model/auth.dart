import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';
import 'package:threddit_clone/features/user_system/view_model/sign_in_with_google/google_auth_controller.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';
import 'package:threddit_clone/features/user_system/view_model/window_auth_service.dart';

///This provider is mainly used in all the registeration process to make validations,
///send and receive data from the backend server.
final authProvider = StateNotifierProvider<Auth, bool>((ref) => Auth(ref));

///This class is a [StateNotifier] class, its state is a [bool] type, where this state
///is and indicator wheather the application is making any contact with the backend server
///so, a loading action is made.
class Auth extends StateNotifier<bool> {
  final Ref ref;
  Auth(this.ref) : super(false);

  void saveEmail(String email) {
    UserModel? currentUser = ref.read(userProvider)!;

    // Create a new user with the updated email
    UserModel updatedUser =
        currentUser.copyWith(email: email, country: 'Egypt', isGoogle: false);

    // Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
  }

  FutureEmailCheck<bool> checkEmailAvailability(String email) async {
    state = true;

    try {
      final response = await http.get(Uri.parse(
          'http://${AppConstants.local}:8000/api/v1/users/checkEmail/$email'));
      state = false;

      //200 -> This email is available to be used
      //400 -> This email is not available to be used  (used before)
      if (response.statusCode == 200) {
        return right(false); //not used (available)
      } else if (response.statusCode == 404) {
        return right(true); //used (not available)
      } else {
        return left(Failure(
            'Error checking on email availabiliy, statuscode ${response.statusCode}'));
      }
    } catch (e) {
      state = false;
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

  FutureEmailCheck<bool> checkUsernameAvailability(String username) async {
    try {
      final response = await http.get(Uri.parse(
          'http://${AppConstants.local}:8000/api/v1/users/check/$username'));

      //200 -> available to be used (not used)
      //401 -> not available (used before)
      if (response.statusCode == 404) {
        ref.read(isUserNameUsedProvider.notifier).update((state) => true);
        return right(true); //used (not available)
      } else if (response.statusCode == 200) {
        ref.read(isUserNameUsedProvider.notifier).update((state) => false);
        return right(false); //not used (available)
      } else {
        return left(Failure(
            'Error checking on username availabiliy, statuscode ${response.statusCode}'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

  ///this function saves the user password to the user model
  void savePassword(String password) {
    state = true;
    UserModel? currentUser = ref.read(userProvider)!;

    // Create a new user with the updated password
    UserModel updatedUser = currentUser.copyWith(
        password: password, passwordConfirm: password, isGoogle: false);

    // Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
    state = false;
  }

  void saveUserName(String userName) {
    state = true;
    UserModel? currentUser = ref.read(userProvider)!;

    // Create a new user with the updated username
    UserModel updatedUser = currentUser.copyWith(username: userName);

    // Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
    state = false;
  }

  void saveGender(String genderType) {
    UserModel? currentUser = ref.read(userProvider)!;

    // Create a new user with the updated gender
    UserModel updatedUser = currentUser.copyWith(gender: genderType);

    // Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
  }

  void saveUserInterests(List<String> interests) {
    UserModel? currentUser = ref.read(userProvider)!;

    // Create a new user with the updated interests list
    UserModel updatedUser = currentUser.copyWith(interests: interests);

    // Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
  }

  // this function save the username or email to the usermodel
  void saveLoginEmail(String value) async {
    state = true;
    UserModel updatedUser;
    UserModel? currentUser = ref.read(userProvider)!;

    // Check whether this is mail or user name
    final isMail = EmailValidator.validate(value);

    // if mail will update the user model with the entered mail
    // else will update the user model with the entered username
    if (isMail) {
      // Create a new user with the updated email
      updatedUser =
          currentUser.copyWith(username: "", email: value, isGoogle: false);

      ref.read(enteredValue.notifier).update((state) => 'email');
    } else {
      // Create a new user with the updated username
      updatedUser =
          currentUser.copyWith(username: value, isGoogle: false, email: "");
      ref.read(enteredValue.notifier).update((state) => 'username');
    }
    ref.read(userProvider.notifier).state = updatedUser;
    state = false;
  }

  FutureEmailCheck<bool> forgotPassword() async {
    state = true;
    final UserModel? user = ref.watch(userProvider);

    try {
      final response = await http.post(
        Uri.parse(
            'http://${AppConstants.local}:8000/api/v1/users/forgotPassword'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'username': user!.username,
            'email': user.email,
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(true);
      } else if (response.statusCode == 400) {
        return right(false);
      } else {
        return left(Failure(
            'Error forgetting password, statuscode ${response.statusCode}'));
      }
    } catch (e) {
      state = false;
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    } finally {
      state = false;
    }
  }

  FutureEmailCheck<bool> forgotUsername() async {
    state = true;
    final UserModel? user = ref.watch(userProvider);

    try {
      final response = await http.post(
        Uri.parse(
            'http://${AppConstants.local}:8000/api/v1/users/forgotUsername'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'email': user!.email,
          },
        ),
      );
      if (response.statusCode == 200) {
        return right(true);
      } else if (response.statusCode == 404) {
        return right(false);
      } else {
        return left(Failure(
            'Error forgetting username, statuscode ${response.statusCode}'));
      }
    } catch (e) {
      state = false;
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    } finally {
      state = false;
    }
  }

  ///this function login the user and saves the token to the cache to create session
  FutureEmailCheck<bool> login() async {
    state = true;
    final user = ref.watch(userProvider)!;
    try {
      final response = await http.post(
        Uri.parse("http://${AppConstants.local}:8000/api/v1/users/login"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'username': user.username,
            'email': user.email,
            'password': user.password,
          },
        ),
      );

      if (response.statusCode == 200) {
        saveToken(jsonDecode(response.body)['token']);
        saveUserId(jsonDecode(response.body)['data']['user']['_id']);
        return right(true);
      } else if ((response.statusCode == 401)) {
        return right(false);
      } else {
        return left(
            Failure('Error logging in, statuscode ${response.statusCode}'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure(
          'Check your internet connection...',
        ));
      } else {
        return left(Failure(e.toString()));
      }
    } finally {
      state = false;
    }
  }

  FutureEmailCheck<bool> signUp() async {
    state = true;
    final UserModel user = ref.watch(userProvider)!;
    try {
      final response = await http.post(
        Uri.parse('http://${AppConstants.local}:8000/api/v1/users/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'username': user.username,
            'email': user.email,
            'password': user.password,
            'passwordConfirm': user.passwordConfirm,
            'country': user.country,
            'gender': user.gender,
            'interests': user.interests,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ref.watch(signUpSuccess.notifier).update((state) => true);
        return right(true);
      } else {
        ref.watch(signUpSuccess.notifier).update((state) => false);
        return right(false);
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    } finally {
      state = false;
    }
  }

  FutureEmailCheck<bool> signUpWithGoogle() async {
    state = true;
    final UserModel user = ref.watch(userProvider)!;
    try {
      final response = await http.post(
        Uri.parse(
            'http://${AppConstants.local}:8000/api/v1/users/googleSignup?token=${user.token}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'username': user.username,
            'country': 'Egypt',
            'gender': user.gender,
            'interests': user.interests,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ref.watch(signUpSuccess.notifier).update((state) => true);
        return right(true);
      } else {
        ref.watch(signUpSuccess.notifier).update((state) => false);
        return right(false);
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    } finally {
      state = false;
    }
  }

  FutureEmailCheck<bool> loginWithGoogle() async {
    state = true;
    final user = ref.watch(userProvider)!;

    try {
      final response = await http.get(
        Uri.parse(
            'http://${AppConstants.local}:8000/api/v1/users/googleLogin?token=${user.token}'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        saveToken(jsonDecode(response.body)['token']);
        saveGoogleToken(jsonDecode(response.body)['token']);
        return right(true);
      } else {
        return right(false);
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    } finally {
      state = false;
    }
  }

  FutureEmailCheck<bool> signInWithGoogle() async {
    final authService = AuthService();
    final String? userToken;

    if (Platform.isWindows) {
      try {
        userToken = await authService.signInWithGoogle();
      } catch (e) {
        if (e is SocketException ||
            e is TimeoutException ||
            e is HttpException) {
          return left(Failure('Check your internet connection...'));
        } else {
          return left(Failure(e.toString()));
        }
      }
    } else {
      try {
        userToken =
            await ref.read(authControllerProvider.notifier).signInWithGoogle();
      } catch (e) {
        if (e is SocketException ||
            e is TimeoutException ||
            e is HttpException) {
          return left(Failure('Check your internet connection...'));
        } else {
          return left(Failure(e.toString()));
        }
      }
    }

    // After getting the token we will update the user and send the token to the backend
    UserModel? currentUser = ref.read(userProvider)!;

    // Create a new user with the updated email
    UserModel updatedUser =
        currentUser.copyWith(token: userToken, isGoogle: true);

    // Update the userProvider state with the new user
    // we are trying to log in by google
    ref.read(userProvider.notifier).state = updatedUser;

    final response = await http.get(
      Uri.parse(
          'http://${AppConstants.local}:8000/api/v1/users/googleLogin?token=$userToken'),
    );

    //200 for exisiting users
    //400 new users
    if (response.statusCode == 200 || response.statusCode == 201) {
      saveToken(jsonDecode(response.body)['token']);
      saveGoogleToken(jsonDecode(response.body)['token']);
      return right(true);
    } else {
      return right(false);
    }
  }

  FutureEmailCheck<bool> connectWithGoogle() async {
    final authService = AuthService();
    final String? userToken;

    if (Platform.isWindows) {
      try {
        userToken = await authService.signInWithGoogle();
      } catch (e) {
        if (e is SocketException ||
            e is TimeoutException ||
            e is HttpException) {
          return left(Failure('Check your internet connection...'));
        } else {
          return left(Failure(e.toString()));
        }
      }
    } else {
      try {
        userToken =
            await ref.read(authControllerProvider.notifier).signInWithGoogle();
      } catch (e) {
        if (e is SocketException ||
            e is TimeoutException ||
            e is HttpException) {
          return left(Failure('Check your internet connection...'));
        } else {
          return left(Failure(e.toString()));
        }
      }
    }

    //After getting the token we will update the user and send the token to the backend
    UserModel? currentUser = ref.read(userProvider)!;

    /// Create a new user with the updated email
    UserModel updatedUser = currentUser.copyWith(token: userToken);

    /// Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;

    final response = await http.get(
      Uri.parse(
          'http://${AppConstants.local}:8000/api/v1/users/googleLogin?token=$userToken'),
    );

    //200 for exisiting users
    //400 new users
    if (response.statusCode == 200 || response.statusCode == 201) {
      saveToken(jsonDecode(response.body)['token']);
      return right(true);
    } else {
      saveGoogleToken(jsonDecode(response.body)['token']);
      return right(false);
    }
  }
}
