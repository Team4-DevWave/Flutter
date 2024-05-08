import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/notifications/view_model/providers.dart';
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

  ///This fucntion is responsible to take the user [email] and update the [UserModel] with its
  ///email and location and isGoogle boolean.
  void saveEmail(String email) {
    UserModel? currentUser = ref.read(userProvider)!;

    // Create a new user with the updated email
    UserModel updatedUser =
        currentUser.copyWith(email: email, country: 'Egypt', isGoogle: false);

    // Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
  }

  ///This function is considered as a validation step in signup process to check if the entered mail
  ///is free to be used.
  ///
  ///Where a get request is sent to the backend with the [email] as a querey in the url.
  ///
  ///The responses that may be sent back are 200, and 400.
  ///
  ///For 200: that's mean that the email is free to be used and not used before by same or another user.
  ///
  ///For 400: means that the mail is used before and cannot be used again in our application.
  ///
  ///At the end a message is returned as a [FutureEmailCheck] where:
  ///
  ///On the Left is the error message returned to be displayed to the user at the appropriate screen.
  ///
  ///And on the Right is the result of the check : true for 200 and false for 400.
  FutureEmailCheck<bool> checkEmailAvailability(String email) async {
    state = true;

    try {
      final response = await http.get(Uri.parse(
          'https://www.threadit.tech/api/v1/users/checkEmail/$email'));
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

  ///This function is considered as a validation step in signup process to check if the entered username
  ///is free to be used.
  ///
  ///Where a get request is sent to the backend with the [username] as a querey in the url.
  ///
  ///The responses that may be sent back are 200, and 400.
  ///
  ///For 200: that's mean that the username is free to be used and not used before by same or another user.
  ///
  ///For 401: means that the username is used before and cannot be used again in our application.
  ///
  ///At the end a message is returned as a [FutureEmailCheck] where:
  ///
  ///On the Left is the error message returned to be displayed to the user at the appropriate screen.
  ///
  ///And on the Right is the result of the check : true for 200 and false for 401.
  FutureEmailCheck<bool> checkUsernameAvailability(String username) async {
    try {
      final response = await http.get(
          Uri.parse('https://www.threadit.tech/api/v1/users/check/$username'));

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

  ///This fucntion is responsible to take the user [password] and update the [UserModel] with its
  ///password and isGoogle boolean.
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

  ///This fucntion is responsible to take the user [userName] and update the [UserModel] with its
  ///username.
  void saveUserName(String userName) {
    state = true;
    UserModel? currentUser = ref.read(userProvider)!;

    // Create a new user with the updated username
    UserModel updatedUser = currentUser.copyWith(username: userName);

    // Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
    state = false;
  }

  ///This fucntion is responsible to take the user [genderType] and
  ///update the [UserModel] with the chosen gender.
  void saveGender(String genderType) {
    UserModel? currentUser = ref.read(userProvider)!;

    // Create a new user with the updated gender
    UserModel updatedUser = currentUser.copyWith(gender: genderType);

    // Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
  }

  ///This fucntion is responsible to take the user [interests] list and update the [UserModel]
  ///with the chosen interests.
  void saveUserInterests(List<String> interests) {
    UserModel? currentUser = ref.read(userProvider)!;

    // Create a new user with the updated interests list
    UserModel updatedUser = currentUser.copyWith(interests: interests);

    // Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
  }

  ///This fucntion is responsible to take the user [value] and check if this value
  ///is an email or username by checking on its format.
  ///
  ///
  /// In case email is entered: update the [UserModel] with the entered email.
  ///
  /// In user username is entered: update the [UserModel] with the entered username.
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

  ///This function is responsible to send to the backend server a post request with the
  ///user username and email, one is filled and the other is empty string.
  ///
  ///A response is sent back indicating whether the action is done successfully or not.
  ///
  ///For 200: This user is found and reset password mail is sent to the user email.
  ///
  ///For 400: Either the user is not found or this account is not validated yet.
  ///
  ///At the end a [bool] is sent back as an indicator to the state of the request
  FutureEmailCheck<bool> forgotPassword() async {
    state = true;
    final UserModel? user = ref.watch(userProvider);

    try {
      final response = await http.post(
        Uri.parse('https://www.threadit.tech/api/v1/users/forgotPassword'),
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

  ///This function is responsible to send to the backend server a post request with the user email
  ///
  ///A response is sent back indicating whether the action is done successfully or not.
  ///
  ///For 200: This user is found and reset username mail is sent to the user email.
  ///
  ///For 400: Either the user is not found or this account is not validated yet.
  ///
  ///At the end a [bool] is sent back as an indicator to the state of the request
  FutureEmailCheck<bool> forgotUsername() async {
    state = true;
    final UserModel? user = ref.watch(userProvider);

    try {
      final response = await http.post(
        Uri.parse('https://www.threadit.tech/api/v1/users/forgotUsername'),
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

  ///This function is considered as a turnary step in the login process.
  ///
  ///Where a post request is sent to the backend with the user data; username, email,
  ///and password.
  ///
  ///The responses that may be sent back are 200, and 400.
  ///
  ///For 200: Mean that the user is found and the data sent is valid for that user.
  ///
  ///For 401: Means that there is no user matches the data sent to the backend server.
  ///
  ///At the end a message is returned as a [FutureEmailCheck] where:
  ///
  ///On the Left is the error message returned to be displayed to the user at the appropriate screen.
  ///
  ///And on the Right is the result of the [login] : true for 200 and false for 401.
  FutureEmailCheck<bool> login() async {
    state = true;
    final user = ref.watch(userProvider)!;
    final String? mtoken = ref.watch(mtokenProvider);
    try {
      final response = await http.post(
        Uri.parse("https://www.threadit.tech/api/v1/users/login"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'username': user.username,
            'email': user.email,
            'password': user.password,
            'mtoken': mtoken
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

  ///This function is considered as a turnary step in signup process.
  ///
  ///Where a post request is sent to the backend with the user data; username, email,
  ///password, passwordConfirm, country, gender, and interests.
  ///
  ///The responses that may be sent back are 200, and 400.
  ///
  ///For 201: that's mean that user's account is created successfully.
  ///
  ///For 400: means that there where a problem happend with the data prevented that user
  ///from creating a new account.
  ///
  ///At the end a message is returned as a [FutureEmailCheck] where:
  ///
  ///On the Left is the error message returned to be displayed to the user at the appropriate screen.
  ///
  ///And on the Right is the result of the signup : true for 200 and false for 400.
  FutureEmailCheck<bool> signUp() async {
    state = true;
    final UserModel user = ref.watch(userProvider)!;
    final String? mtoken = ref.watch(mtokenProvider);
    try {
      final response = await http.post(
        Uri.parse('https://www.threadit.tech/api/v1/users/signup'),
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
            'mtoken': mtoken
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

  ///This function is considered as a turnary step in signup process.
  ///
  ///Where a post request is sent to the backend with the user data; username,
  /// country, gender, and interests.
  ///
  ///The responses that may be sent back are 200, and 400.
  ///
  ///For 201: that's mean that user's account is created successfully.
  ///
  ///For 400: means that there where a problem happend with the data prevented that user
  ///from creating a new account.
  ///
  ///At the end a message is returned as a [FutureEmailCheck] where:
  ///
  ///On the Left is the error message returned to be displayed to the user at the appropriate screen.
  ///
  ///And on the Right is the result of the signup: true for 200 and false for 400.
  FutureEmailCheck<bool> signUpWithGoogle() async {
    state = true;
    final UserModel user = ref.watch(userProvider)!;
    final String? mtoken = ref.watch(mtokenProvider);
    try {
      final response = await http.post(
        Uri.parse(
            'https://www.threadit.tech/api/v1/users/googleSignup?token=${user.token}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'username': user.username,
            'country': 'Egypt',
            'gender': user.gender,
            'interests': user.interests,
            'mtoken': mtoken
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

  ///This function is considered as a turnary step in the login process.
  ///
  ///Where a get request with the user google token in the url as a querey
  ///is sent to the backend server.
  ///
  ///The responses that may be sent back are 200, and 400.
  ///
  ///For 200: Mean that the user is found and the data sent is valid for that user.
  ///
  ///For 400: Means that there is no user matches the data sent to the backend server.
  ///
  ///At the end a message is returned as a [FutureEmailCheck] where:
  ///
  ///On the Left is the error message returned to be displayed to the user at the appropriate screen.
  ///
  ///And on the Right is the result of the [login] : true for 200 and false for 400.
  FutureEmailCheck<bool> loginWithGoogle() async {
    state = true;
    final user = ref.watch(userProvider)!;

    try {
      final response = await http.get(
        Uri.parse(
            'https://www.threadit.tech/api/v1/users/googleLogin?token=${user.token}'),
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

  ///This function is considered as a start point to control the signin with google process,
  ///where, first of all the user platform decive is checked to choose the approriate signin
  ///with google path that matches the user's device.
  ///
  ///Then the [UserModel] is updated with the returned access token from google for that user.
  ///
  ///A get request is then sent to the backend server with the user google token in the url as a querey,
  ///to try logging the user in assuming that the user exist.
  ///
  ///The responses that may be sent back are 200, and 400.
  ///
  ///For 200: Mean that the user is found and the data sent is valid for that user.
  ///
  ///For 400: Means that there is no user matches the data sent to the backend server.
  ///
  ///At the end a message is returned as a [FutureEmailCheck] where:
  ///
  ///On the Left is the error message returned to be displayed to the user at the appropriate screen.
  ///
  ///And on the Right is the result of the [login] : true for 200 and false for 400.
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
          'https://www.threadit.tech/api/v1/users/googleLogin?token=$userToken'),
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

  ///This function is considered as a start point to control the connect with google process,
  ///where, first of all the user platform decive is checked to choose the approriate signin
  ///with google path that matches the user's device.
  ///
  ///Then the [UserModel] is updated with the returned access token from google for that user.
  ///
  ///A get request is then sent to the backend server with the user google token in the url as a querey,
  ///to try logging the user in assuming that the user exist.
  ///
  ///The responses that may be sent back are 200, and 400.
  ///
  ///For 200: Mean that the user is found and the data sent is valid for that user.
  ///
  ///For 400: Means that there is no user matches the data sent to the backend server.
  ///
  ///At the end a message is returned as a [FutureEmailCheck] where:
  ///
  ///On the Left is the error message returned to be displayed to the user at the appropriate screen.
  ///
  ///And on the Right is the result of the [login] : true for 200 and false for 400.
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

    // Create a new user with the updated email
    UserModel updatedUser = currentUser.copyWith(token: userToken);

    // Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;

    final response = await http.get(
      Uri.parse(
          'https://www.threadit.tech/api/v1/users/googleLogin?token=$userToken'),
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
