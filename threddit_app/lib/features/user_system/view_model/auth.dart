import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/user_data.dart';
import 'package:threddit_clone/features/user_system/view_model/user_system_providers.dart';

final authProvider = StateNotifierProvider<Auth, bool>((ref) => Auth(ref));

class Auth extends StateNotifier<bool> {
  final Ref ref;
  Auth(this.ref) : super(false);

  ///This function is responsible for checking if user trying to sign up is new or not
  // ///by using the check mail availabity in the BE
  // Future<void> saveCheckedAvailabilityEmail(String? email) async {
  //   state = true;
  //   final url = Uri.https(
  //       'threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app',
  //       'token.json');
  //   final response = await http.get(url);

  //   ///404 means that user mail was not found therfore this user in a new user
  //   if (response.statusCode == 200) {
  //     UserModel? currentUser = ref.read(userProvider)!;

  //     /// Create a new user with the updated email
  //     UserModel updatedUser =
  //         currentUser.copyWith(email: email, country: 'Egypt', isGoogle: false);

  //     /// Update the userProvider state with the new user
  //     ref.read(userProvider.notifier).state = updatedUser;
  //     ref.read(isNewProvider.notifier).update((state) => true);
  //     state = false;
  //   } else {
  //     ref.read(isNewProvider.notifier).update((state) => false);
  //   }
  // }

  void saveEmail(String email) {
    UserModel? currentUser = ref.read(userProvider)!;

    /// Create a new user with the updated email
    UserModel updatedUser =
        currentUser.copyWith(email: email, country: 'Egypt', isGoogle: false);

    /// Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
  }

  Future<bool> checkEmailAvailability(String email) async {
    state = true;
    final url = Uri.https(
        'threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app',
        'token.json');
    final response = await http.get(url);
    state = false;
    //this should be 200 but will make it 400 to stop checking
    //200 -> used
    //400 -> notuser
    if (response.statusCode == 400) {
      ref.read(isEmailUsedProvider.notifier).update((state) => true);
      return true;
    } else {
      ref.read(isEmailUsedProvider.notifier).update((state) => false);
      return false;
    }
  }

  Future<bool> checkUsernameAvailability(String username) async {
    final url = Uri.https(
        'threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app',
        'token.json');
    final response = await http.get(url);

    //this should be 200 but will make it 400 to stop checking
    //200 -> used
    //400 -> notuser
    if (response.statusCode == 400) {
      ref.read(isUserNameUsedProvider.notifier).update((state) => true);
      return true;
    } else {
      ref.read(isUserNameUsedProvider.notifier).update((state) => false);
      return false;
    }
  }

  ///this function saves the user password to the user model
  void savePassword(String password) {
    state = true;
    UserModel? currentUser = ref.read(userProvider)!;

    /// Create a new user with the updated password
    UserModel updatedUser = currentUser.copyWith(
        password: password, passwordConfirm: password, isGoogle: false);

    /// Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
    state = false;
  }

  void saveUserName(String userName) {
    state = true;
    UserModel? currentUser = ref.read(userProvider)!;

    /// Create a new user with the updated username
    UserModel updatedUser = currentUser.copyWith(username: userName);

    /// Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
    state = false;
  }

  void saveGender(String genderType) {
    UserModel? currentUser = ref.read(userProvider)!;

    /// Create a new user with the updated gender
    UserModel updatedUser = currentUser.copyWith(gender: genderType);

    /// Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
  }

  void saveUserInterests(List<String> interests) {
    UserModel? currentUser = ref.read(userProvider)!;

    /// Create a new user with the updated interests list
    UserModel updatedUser = currentUser.copyWith(interests: interests);

    /// Update the userProvider state with the new user
    ref.read(userProvider.notifier).state = updatedUser;
  }

  ///this function save the username or email to the usermodel
  void saveLoginEmail(String value) async {
    state = true;
    UserModel updatedUser;
    UserModel? currentUser = ref.read(userProvider)!;

    ///Check whether this is mail or user name
    final isMail = EmailValidator.validate(value);

    ///if mail will update the user model with the entered mail
    ///else will update the user model with the entered username
    if (isMail) {
      /// Create a new user with the updated email
      updatedUser =
          currentUser.copyWith(username: "", email: value, isGoogle: false);

      ref.read(enteredValue.notifier).update((state) => 'email');
    } else {
      /// Create a new user with the updated username
      updatedUser =
          currentUser.copyWith(username: value, isGoogle: false, email: "");
      ref.read(enteredValue.notifier).update((state) => 'username');
    }
    ref.read(userProvider.notifier).state = updatedUser;
    state = false;
  }

  Future<void> forgetPassword() async {
    state = true;
    final UserModel? user = ref.watch(userProvider);
    final url = Uri.https(
        'threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app',
        'forgetPassword.json');
    final response = await http.post(
      url,
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
    if (response.statusCode == 200) {
      ref.read(loginSucceeded.notifier).update((state) => true);
    } else {
      ref.read(loginSucceeded.notifier).update((state) => false);
    }
    state = false;
  }

  ///this function login the user and saves the token to the cache to create session
  Future<void> login() async {
    state = true;
    final user = ref.watch(userProvider)!;
    final url = Uri.https(
        'threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app',
        'login.json');
    final response = await http.post(
      url,
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
      saveToken(response.body.toString());

      ref.read(loginSucceeded.notifier).update((state) => true);
    } else {
      ref.read(loginSucceeded.notifier).update((state) => false);
    }
    state = false;
  }

  Future<void> signUp() async {
    state = true;
    final UserModel user = ref.watch(userProvider)!;
    final url = Uri.https(
      'threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app',
      'signup.json',
    );
    final response = await http.post(
      url,
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
    if (response.statusCode == 200) {
      ref.watch(signUpSuccess.notifier).update((state) => true);
    } else {
      ref.watch(signUpSuccess.notifier).update((state) => false);
    }
    state = false;
  }
}