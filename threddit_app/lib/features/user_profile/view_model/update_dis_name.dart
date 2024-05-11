import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';

/// Updates the display name of the current user.
///
/// This function sends a PATCH request to update the display name of the current user on the server.
/// It takes the new display name [dispName] as a parameter.
/// Returns a [FutureEither] indicating whether the update was successful or not.
///
/// Parameters:
///   - dispName: The new display name to be set for the current user.
///   - ref: The reference to the current widget's provider for updating the local state.
///
/// Returns:
///   A [FutureEither] containing a boolean value indicating whether the update was successful or not.

FutureEither<bool> updateDisplayName(String dispName, WidgetRef ref) async {
  String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  final token = await getToken();
  final url = "https://www.threadit.tech/api/v1/users/me/changeDisplayName";
  final headers = {
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.patch(Uri.parse(url),
        headers: headers, body: {"displayName": dispName});

    if (response.statusCode == 200) {
      ref
          .read(userModelProvider.notifier)
          .update((state) => state?.copyWith(displayName: dispName));
      return right(true);
    } else {
      return left(Failure("Failed to update display name"));
    }
  } catch (e) {
    if (e is SocketException || e is TimeoutException || e is HttpException) {
      return left(Failure('Check your internet connection...'));
    } else {
      return left(Failure(e.toString()));
    }
  }
}
