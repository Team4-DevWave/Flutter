import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/post/viewmodel/share_post_provider.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:http/http.dart' as http;

final sharePostsProvider =
    StateNotifierProvider<SharePosts, bool>((ref) => SharePosts(ref));

class SharePosts extends StateNotifier<bool> {
  Ref ref;
  SharePosts(this.ref) : super(false);

  FutureEither<bool> sharePost() async {
    state = true;
    final sharedPost = ref.watch(sharedPostProvider);

    //http://localhost:8000/api/v1/posts/[post_id]/share
    /*
    {
      "postIn":"subreddit or user profile",
      "postInName":"username or subreddit name",
      "postID":"",
      "NSFW":"false",
      "spoiler":"false",
      "postCommentNotifications":"true"
    }
    */
    //final token = await getToken();

    // final url = Uri.https(
    //     'threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app',
    //     'share.json');
    String? token = await getToken();
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/v1/posts/share'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(
          {
            "destination": (sharedPost.postIn == 'user profile')
                ? ''
                : sharedPost.postInName,
            "nsfw": sharedPost.NSFW,
            "title": sharedPost.title,
            "spoiler": sharedPost.spoiler,
            "postid": sharedPost.post?.id
          },
        ),
      );
      print('SHRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR');
      print(response.statusCode);
      if (response.statusCode == 200) {
        return right(true);
      } else {
        return left(Failure('Something went wrong while sharing the post'));
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
}
