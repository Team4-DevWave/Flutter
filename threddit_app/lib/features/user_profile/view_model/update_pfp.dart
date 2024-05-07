import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';

FutureEither<bool> updateProfilePicture(String? image, WidgetRef ref) async {
  String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  final token = await getToken();
  final url = "https://www.threadit.tech/api/v1/users/me/changeProfilePic";
  final headers = {
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http
        .patch(Uri.parse(url), headers: headers, body: {"image": image});
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      ref.read(userModelProvider.notifier).update((state) =>
          state = state!.copyWith(profilePicture: body['profilePicture']));
      return right(true);
    } else {
      return left(Failure("Failed to update profile picture"));
    }
  } catch (e) {
    if (e is SocketException || e is TimeoutException || e is HttpException) {
      return left(Failure('Check your internet connection...'));
    } else {
      return left(Failure(e.toString()));
    }
  }
}
