import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/Moderation/model/post_types.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

final postTypesProvider = StateNotifierProvider<PostTypesNotifier, PostTypes>(
    (ref) => PostTypesNotifier());

class PostTypesNotifier extends StateNotifier<PostTypes> {
  PostTypesNotifier()
      : super(PostTypes(
            postTypesOptions: "any",
            imagePosts: false,
            videoPosts: false,
            pollPosts: false));

  void updatePostTypesOption(String type) {
    state = state.copyWith(postTypesOptions: type);
  }

  void updateImagePosts(bool check) {
    state = state.copyWith(imagePosts: check);
  }

  void updateVideoPosts(bool check) {
    state = state.copyWith(videoPosts: check);
  }

  void updatePollPosts(bool check) {
    state = state.copyWith(pollPosts: check);
  }

  FutureEither<PostTypes> getPostTypes() async {
    final url = Uri.https(
        "threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app",
        "postTypes.json");
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        state = PostTypes.fromJson(response.body);
        return right(state);
      } else {
        return left(Failure(
            'Somethig went wrong while trying to fetch your data, please try again later'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return left(Failure('Check your internet connection...'));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }

  FutureEither<PostTypes> updatePostTypes() async {
    final url = Uri.https(
        "threddit-clone-app-default-rtdb.europe-west1.firebasedatabase.app",
        "postTypes.json");
    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: state.toJson(),
      );
      if (response.statusCode == 200) {
        return right(state);
      } else {
        return left(Failure(
            'Somethig went wrong while trying to fetch your data, please try again later'));
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
