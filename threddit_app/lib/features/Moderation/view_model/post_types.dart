import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/Moderation/model/post_types.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';

/// Provider for managing the post types state.
final postTypesProvider = StateNotifierProvider<PostTypesNotifier, PostTypes>(
    (ref) => PostTypesNotifier());

/// State notifier responsible for managing the post types state.
class PostTypesNotifier extends StateNotifier<PostTypes> {
  PostTypesNotifier()
      : super(PostTypes(
            postTypesOptions: "any",
            imagePosts: false,
            videoPosts: false,
            pollPosts: false));

  /// Updates the selected post type option.
  ///
  /// This method updates the state with the selected post type option.
  ///
  /// [type]: The selected post type option.
  void updatePostTypesOption(String type) {
    state = state.copyWith(postTypesOptions: type);
  }

  /// Updates the state for allowing image posts.
  ///
  /// This method updates the state to allow or disallow image posts.
  ///
  /// [check]: True to allow image posts, false to disallow.
  void updateImagePosts(bool check) {
    state = state.copyWith(imagePosts: check);
  }

  /// Updates the state for allowing video posts.
  ///
  /// This method updates the state to allow or disallow video posts.
  ///
  /// [check]: True to allow video posts, false to disallow.
  void updateVideoPosts(bool check) {
    state = state.copyWith(videoPosts: check);
  }

  /// Updates the state for allowing poll posts.
  ///
  /// This method updates the state to allow or disallow poll posts.
  ///
  /// [check]: True to allow poll posts, false to disallow.
  void updatePollPosts(bool check) {
    state = state.copyWith(pollPosts: check);
  }

  /// Fetches the post types from the server.
  ///
  /// This method sends a GET request to fetch the post types from the server.
  ///
  /// Returns a [FutureEither] containing either the fetched post types or a [Failure].
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

  /// Updates the post types on the server.
  ///
  /// This method sends a PATCH request to update the post types on the server.
  ///
  /// Returns a [FutureEither] containing either the updated post types or a [Failure].
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
