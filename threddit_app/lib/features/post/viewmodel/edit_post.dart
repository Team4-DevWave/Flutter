import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/viewmodel/save_post.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

final editPostProvider =
    StateNotifierProvider<EditPost, Post>((ref) => EditPost(ref));

class EditPost extends StateNotifier<Post> {
  final Ref ref;
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

  FutureEither<Post> editPostRequest() async {
    final url = Uri.parse(
        "http://${AppConstants.local}:8000/api/v1/posts/${state.id}/edit");
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

  void updatePostToBeEdited(Post post) => state = post;
  void updateNFSW(bool nfsw) => state = state.copyWith(nsfw: nfsw);
  void updateSpoiler(bool spoiler) => state = state.copyWith(spoiler: spoiler);
  void updatePostTextBody(String textBody) =>
      state = state.copyWith(textBody: textBody);
}
