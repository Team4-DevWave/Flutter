import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
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

  FutureEither<Post> sharePost() async {
    state = true;
    final sharedPost = ref.watch(sharedPostProvider);

    final url = Uri.parse('https://www.threadit.tech/api/v1/posts/share');
    final token = await getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(
          {
            "title": sharedPost.title,
            "destination": sharedPost.destination,
            "nsfw": sharedPost.nsfw,
            "spoiler": sharedPost.spoiler,
            "postid": sharedPost.post!.id,
          },
        ),
      );
      if (response.statusCode == 200) {
        final pid = json.decode(response.body)["data"]["post"]["_id"];

        final urlPost =
            Uri.parse('https://www.threadit.tech/api/v1/posts/$pid');

        final responsePost = await http.get(urlPost, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
        if (responsePost.statusCode == 200) {
          final Map<String, dynamic> responseData =
              jsonDecode(responsePost.body);
          final post = Post.fromJson(responseData['data']['post']);
          return right(post);
        } else {
          throw Exception(
              'Failed to fetch post. Status code: ${response.statusCode}');
        }
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
