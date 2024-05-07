import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';

/// A provider responsible for managing the creation and submission of posts.
final createPost =
    StateNotifierProvider<PostProvider, bool>((ref) => PostProvider(ref));

String local = Platform.isAndroid ? AppConstants.local : 'localhost';

/// A provider for managing the creation and submission of posts.
///
/// This class handles the process of submitting a new post to the server.
/// It sends a POST request with the post data to the appropriate endpoint
/// based on the post type and destination (user profile or community).
class PostProvider extends StateNotifier<bool> {
  final Ref ref;

  /// Constructs a new [PostProvider] instance.
  PostProvider(this.ref) : super(false);

  /// Submits a new post to the server.
  ///
  /// This method sends a POST request to the server with the post data
  /// to create and submit a new post. It returns a [Post] object if
  /// the submission is successful, or a [Failure] object if it fails.
  FutureEither<Post> submitPost(String type) async {
    final post = ref.watch(postDataProvider);
    final token = await getToken();
    final user = ref.read(userModelProvider)!.username;
    final Map<String, List<String>> pollValue;
    if (post!.poll != null) {
      pollValue = {for (var value in post.poll!.values) value: []};
    } else {
      pollValue = {};
    }
    final whereTo = post.community == null ? 'u/$user' : 'r/${post.community}';

    try {
      final response = await http.post(
          Uri.parse('http://$local:8000/api/v1/posts/submit/$whereTo'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            "title": post.title,
            "url": post.url,
            "type": type,
            "spoiler": post.spoiler,
            "nsfw": post.NSFW,
            "locked": post.locked,
            "text_body": post.text_body ?? "",
            "image": post.image ?? "",
            "video": post.video ?? "",
            "duration": post.duration ?? 1,
            "poll": pollValue,
          }));

      if (response.statusCode == 201) {
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
        return left(
            Failure("Can't submit post, please discard or try again later"));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }
}
