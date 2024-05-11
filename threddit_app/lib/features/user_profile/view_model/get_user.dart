import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_profile/models/other_user_data.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

/// A state notifier provider for fetching user data.
final getUserProvider = StateNotifierProvider<GetUserNotifier, UserModelNotMe>(
    (ref) => GetUserNotifier(ref));

/// A state notifier class for fetching user data.
class GetUserNotifier extends StateNotifier<UserModelNotMe> {
  final Ref ref;

  /// Constructor for [GetUserNotifier].
  ///
  /// Initializes the state with an empty [UserModelNotMe].
  GetUserNotifier(this.ref) : super(UserModelNotMe());

  /// Fetches user data from the API.
  ///
  /// This function sends an HTTP GET request to fetch user data
  /// for the specified username.
  ///
  /// Parameters:
  ///   - username: The username of the user whose data is to be fetched.
  ///
  /// Returns:
  ///   A [FutureEither] object representing either a success or a failure.
  ///   If successful, it returns a [UserModelNotMe] object containing the user data,
  ///   otherwise it returns a [Failure] object.
  FutureEither<UserModelNotMe> getUser(String username) async {
    String? token = await getToken();
    try {
      http.Response response = await http.get(
        Uri.parse("https://www.threadit.tech/api/v1/users/$username"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonBody = UserModelNotMe.fromJson(jsonDecode(response.body));
        state = jsonBody;
        return right(state);
      } else {
        return left(Failure("Getting user data failed :( "));
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
