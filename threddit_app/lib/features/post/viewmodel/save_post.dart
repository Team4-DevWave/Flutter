import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/models/comment.dart';
import 'package:tuple/tuple.dart';

/// A provider responsible for managing the saving and retrieving of posts.
final savePostProvider =
    StateNotifierProvider<SavePost, bool>((ref) => SavePost(ref));

/// A state notifier responsible for saving and retrieving posts.
///
/// This class manages the communication between the app and the server
/// for saving, retrieving, and checking the saved status of posts.
class SavePost extends StateNotifier<bool> {
  Ref ref;

  /// Constructs a new [SavePost] instance.
  SavePost(this.ref) : super(false);

  /// Sends a request to save a post by its ID.
  ///
  /// This method sends a PATCH request to the server to save a post
  /// identified by the provided [postid]. It updates the saved status
  /// of the post and returns a boolean indicating the success of the operation.
  FutureEither<bool> savePostRequest(String postid) async {
    final url =
        Uri.parse('https://www.threadit.tech/api/v1/posts/$postid/save');
    final token = await getToken();
    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return right(true);
      } else if (response.statusCode == 404) {
        return left(Failure('Something went wrong, try again later'));
      } else {
        return left(Failure('Something went wrong, try again later'));
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

  /// Retrieves the IDs of saved posts.
  ///
  /// This method sends a GET request to the server to retrieve
  /// the IDs of posts saved by the current user. It returns
  /// a list of post IDs or an error if the operation fails.
  FutureEither<List<String>> getSavedPostIds() async {
    final url =
        Uri.parse("https://www.threadit.tech/api/v1/users/me/saved?page=1");
    final token = await getToken();
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body)['data'];
        final List<dynamic> posts = body['posts'];

        final List<String> postIds =
            posts.map((post) => post['_id'] as String).toList();

        return Right(postIds);
      } else {
        return Left(Failure('Something went wrong, try again later'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return Left(Failure('Check your internet connection...'));
      } else {
        return Left(Failure(e.toString()));
      }
    }
  }

  /// Checks if a post is saved by its ID.
  ///
  /// This method checks if a post with the provided [postid] is
  /// saved by the current user. It returns a boolean indicating
  /// whether the post is saved or not, or an error if the operation fails.
  FutureEither<bool> isSaved(String postid) async {
    final response = await getSavedPostIds();
    return response.fold((l) {
      return left(Failure('Error retriving saved'));
    }, (listSaved) {
      return right(listSaved.contains(postid));
    });
  }

  /// Retrieves saved posts along with save comments.
  ///
  /// This method sends a GET request to the server to retrieve
  /// posts saved by the current user. It returns a tuple containing
  /// a list of saved posts and a list of comments associated with them,
  /// or an error if the operation fails.
  FutureEither<Tuple2<List<Post>, List<Comment>>> getSaved() async {
    final url =
        Uri.parse("https://www.threadit.tech/api/v1/users/me/saved?page=1");
    final token = await getToken();
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body)['data'];
        final List<dynamic> postsData = body['posts'];
        final List<dynamic> commentsData = body['comments'];
        final List<Post> posts =
            postsData.map((postData) => Post.fromJson(postData)).toList();
        final List<Comment> comments =
            commentsData.map((postData) => Comment.fromJson(postData)).toList();

        Tuple2<List<Post>, List<Comment>> tuple = Tuple2(posts, comments);

        return Right(tuple);
      } else {
        return Left(Failure('Something went wrong, try again later'));
      }
    } catch (e) {
      if (e is SocketException || e is TimeoutException || e is HttpException) {
        return Left(Failure('Check your internet connection...'));
      } else {
        return Left(Failure(e.toString()));
      }
    }
  }
}

/// A provider for tracking updates related to saving posts.
final updatesSaveProvider = StateProvider<String?>((ref) => null);

/// A provider for tracking updates related to editing posts.
final updatesEditProvider = StateProvider<String?>((ref) => null);

/// A provider for tracking updates related to deleting posts.
final updatesDeleteProvider = StateProvider<String?>((ref) => null);

/// A provider for tracking updates related to feed content.
final updatesFeedProvider = StateProvider<String?>((ref) => 'Best');
