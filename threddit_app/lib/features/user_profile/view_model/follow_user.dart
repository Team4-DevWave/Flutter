import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';

FutureEither<bool> followUser(String userName, WidgetRef ref) async {
  String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  final token = await getToken();
  final url = "http://$local:8000/api/v1/users/me/friend/$userName";
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  try {
    final response = await http.post(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {

    // Decode the JSON string
    var decodedResponse = jsonDecode(response.body);

    // Get the followedUsers list from the decoded response
    var followedUsers = decodedResponse['data']['user']['followedUsers'];

    ref.read(userModelProvider.notifier).update((state) => state!.copyWith(followedUsers: followedUsers));

      return right(true);
    } else if (response.statusCode == 400) {
      return left(Failure("user already followed"));
    } else {
      return left(Failure("Can't find user"));
    }
  } catch (e) {
    if (e is SocketException || e is TimeoutException || e is HttpException) {
      return left(Failure('Check your internet connection...'));
    } else {
      return left(Failure(e.toString()));
    }
  }
}

FutureEither<bool> unfollowUser(String userName) async {
  String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  final token = await getToken();
  final url = "http://$local:8000/api/v1/users/me/friend/$userName";
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
  try {
    final response = await http.delete(Uri.parse(url), headers: headers);
    if (response.statusCode == 204) {
      return right(true);
    } else {
      return left(Failure("Can't unfollow user, please try again later"));
    }
  } catch (e) {
    if (e is SocketException || e is TimeoutException || e is HttpException) {
      return left(Failure('Check your internet connection...'));
    } else {
      return left(Failure(e.toString()));
    }
  }
}
