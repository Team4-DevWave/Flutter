import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:http/http.dart' as http;

final deletePostProvider =
    StateNotifierProvider<DeletePost, bool>((ref) => DeletePost(ref));

class DeletePost extends StateNotifier<bool> {
  Ref ref;
  DeletePost(this.ref) : super(false);

  FutureEither<bool> deletePostRequest(String postid) async {
    final url = Uri.parse(
        'http://${AppConstants.local}:8000/api/v1/posts/$postid/delete');
    final token = await getToken();
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 204) {
        return right(true);
      } else if (response.statusCode == 500) {
        return left(Failure('Post not found, may be deleted before'));
      } else {
        return left(Failure('something went wrong while deleting your post'));
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
}
