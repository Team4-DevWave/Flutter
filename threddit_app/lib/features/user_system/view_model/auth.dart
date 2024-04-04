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
  Future<void> saveEmail(String? email) async {
    state = true;
    final url = Uri.https(
        'threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app',
        'token.json');
    final response = await http.get(url);

    ///404 means that user mail was not found therfore this user in a new user
    if (response.statusCode == 200) {
      UserModel? currentUser = ref.read(userProvider)!;

      /// Create a new user with the updated email
      UserModel updatedUser =
          currentUser.copyWith(email: email, country: 'Egypt', isGoogle: false);

      /// Update the userProvider state with the new user
      ref.read(userProvider.notifier).state = updatedUser;
      ref.read(isNewProvider.notifier).update((state) => true);
      state = false;
    } else {
      ref.read(isNewProvider.notifier).update((state) => false);
    }
  }

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
      updatedUser = currentUser.copyWith(email: value, isGoogle: false);

      ref.read(enteredValue.notifier).update((state) => 'email');
    } else {
      /// Create a new user with the updated username
      updatedUser = currentUser.copyWith(username: value, isGoogle: false);
      ref.read(enteredValue.notifier).update((state) => 'username');
    }
    ref.read(userProvider.notifier).state = updatedUser;
    state = false;
  }

  Future<void> login() async {
    state = true;
    final user = ref.watch(userProvider)!;
    final url = Uri.https(
        'threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app',
        'user.json');
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
      ref.read(succeeded.notifier).update((state) => true);
    } else {
      ref.read(succeeded.notifier).update((state) => false);
    }
    state = false;
  }
}
