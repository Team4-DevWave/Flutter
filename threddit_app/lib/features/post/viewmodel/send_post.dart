import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

final createPost =
    StateNotifierProvider<PostProvider, bool>((ref) => PostProvider(ref));

String local = Platform.isAndroid ? '10.0.2.2' : 'localhost';

class PostProvider extends StateNotifier<bool> {
  final Ref ref;
  PostProvider(this.ref) : super(false);

  FutureEither<bool> submitPost(String type) async {
    final post = ref.watch(postDataProvider);
    final token = await getToken();
    //get username
    final whereTo =
        post?.community == null ? 'u/username' : 'r/${post?.community}';

    try {
      final response = await http.post(
          Uri.parse('http://$local:8000/api/v1/posts/submit/$whereTo'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            "title": post?.title,
            "url": post?.url,
            "type": type,
            "spoiler": post?.spoiler,
            "nsfw": post?.NSFW,
            "locked": post?.locked,
            "text_body": post?.text_body ?? "",
            "image": post?.image ?? "",
            "video": post?.video ?? ""
          }));
      if (response.statusCode == 201) {
        return right(true);
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
