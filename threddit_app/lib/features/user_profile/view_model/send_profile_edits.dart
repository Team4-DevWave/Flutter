import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/user_settings.dart';

/// Updates user data on the server.
///
/// This function sends a PATCH request to update the user data on the server.
/// It takes a [user] parameter containing the updated user profile information.
/// Returns a [FutureEither] indicating whether the update was successful or not.
///
/// Parameters:
///   - user: The updated user profile information.
///
/// Returns:
///   A [FutureEither] containing a boolean value indicating whether the update was successful or not.
FutureEither<bool> updateUserData(UserProfile user) async {
  String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  final token = await getToken();
  final url = "http://$local:8000/api/v1/users/me/settings";
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.patch(Uri.parse(url),
        headers: headers, body: jsonEncode(user.toJson()));
    if (response.statusCode == 200) {
      return right(true);
    } else {
      return left(Failure("Can't submit changes, please try again later"));
    }
  } catch (e) {
    if (e is SocketException || e is TimeoutException || e is HttpException) {
      return left(Failure('Check your internet connection...'));
    } else {
      return left(Failure(e.toString()));
    }
  }
}
