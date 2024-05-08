import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/viewmodel/save_post.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

/// A provider responsible for managing the editing of posts.
final editPostProvider =
    StateNotifierProvider<EditPost, Post>((ref) => EditPost(ref));

/// A state notifier responsible for managing the editing of posts.
class EditPost extends StateNotifier<Post> {
  final Ref ref;

  /// Constructs a new [EditPost] instance for the provider state.
  EditPost(this.ref)
      : super(
          Post(
            id: "",
            title: "",
            nsfw: false,
            spoiler: false,
            locked: false,
            approved: false,
            postedTime: DateTime.now(),
            numViews: 0,
            commentsCount: 0,
          ),
        );

  /// Initiates a request to edit a post.
  ///
  /// This method sends a PATCH request to the server to edit the post with the specified ID.
  /// If the request is successful, the updated post is returned.
  FutureEither<Post> editPostRequest() async {
    final url =
        Uri.parse("https://www.threadit.tech/api/v1/posts/${state.id}/edit");
    final token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = json.encode(
      {
        "type": "text",
        "text_body": state.textBody,
        "NSFW": state.nsfw,
        "spoiler": state.spoiler
      },
    );
    try {
      final response = await http.patch(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final post = Post.fromJson(responseData['data']['post']);

        ref.read(updatesEditProvider.notifier).update((state) => post.id);
        return right(post);
      } else {
        return left(Failure(
            'Something went wrong while editing your post, please try again later'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

  /// Updates the post to be edited.
  void updatePostToBeEdited(Post post) => state = post;

  /// Updates the NSFW flag of the post.
  void updateNFSW(bool nfsw) => state = state.copyWith(nsfw: nfsw);

  /// Updates the spoiler flag of the post.
  void updateSpoiler(bool spoiler) => state = state.copyWith(spoiler: spoiler);

  /// Updates the text body of the post.
  void updatePostTextBody(String textBody) =>
      state = state.copyWith(textBody: textBody);
}
