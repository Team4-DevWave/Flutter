import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/viewmodel/share_post_provider.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:http/http.dart' as http;

/// A provider responsible for managing the sharing of posts.
final sharePostsProvider =
    StateNotifierProvider<SharePosts, bool>((ref) => SharePosts(ref));

/// A notifier for managing the sharing of posts.
///
/// This class handles the process of sharing a post by sending a POST request
/// with the necessary data to the server. It provides methods for sharing
/// a post and handles errors that may occur during the sharing process.
class SharePosts extends StateNotifier<bool> {
  Ref ref;

  /// Constructs a new [SharePosts] instance.
  SharePosts(this.ref) : super(false);

  /// Shares a post to the specified destination.
  ///
  /// This method sends a POST request to the server with the post data
  /// to share the post to the specified destination. It returns a [Post] object
  /// if the sharing is successful, or a [Failure] object if it fails.
  FutureEither<Post> sharePost() async {
    state = true;
    final sharedPost = ref.watch(sharedPostProvider);

    final url =
        Uri.parse('http://${AppConstants.local}:8000/api/v1/posts/share');
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
            Uri.parse('http://${AppConstants.local}:8000/api/v1/posts/$pid');

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
