import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/post/viewmodel/save_post.dart';
import 'package:threddit_clone/features/posting/view_model/history_manager.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:http/http.dart' as http;

/// A provider responsible for managing the deletion of posts.
final deletePostProvider =
    StateNotifierProvider<DeletePost, bool>((ref) => DeletePost(ref));

/// A state notifier responsible for managing the deletion of posts.
class DeletePost extends StateNotifier<bool> {
  Ref ref;

  /// Constructs a new [DeletePost] instance.
  DeletePost(this.ref) : super(false);

  /// Initiates a request to delete a post.
  ///
  /// This method sends a request to the server to delete the post with the specified [postid].
  /// If the request is successful, the post is removed and the [updatesDeleteProvider]
  /// is updated.
  FutureEither<bool> deletePostRequest(String postid) async {
    final url =
        Uri.parse('https://www.threadit.tech/api/v1/posts/$postid/delete');
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
        HistoryManager.removePostFromHistory(postid);
        ref.read(updatesDeleteProvider.notifier).state = postid;
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
