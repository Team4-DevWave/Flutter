import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/models/comment.dart';
import 'package:tuple/tuple.dart';

final savePostProvider =
    StateNotifierProvider<SavePost, bool>((ref) => SavePost(ref));

class SavePost extends StateNotifier<bool> {
  Ref ref;
  SavePost(this.ref) : super(false);

  FutureEither<bool> savePostRequest(String postid) async {
    final url = Uri.parse(
        'http://${AppConstants.local}:8000/api/v1/posts/$postid/save');
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

  FutureEither<List<String>> getSavedPostIds() async {
    final url = Uri.parse(
        "http://${AppConstants.local}:8000/api/v1/users/me/saved?page=1");
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

  FutureEither<bool> isSaved(String postid) async {
    final response = await getSavedPostIds();
    return response.fold((l) {
      return left(Failure('Error retriving saved'));
    }, (listSaved) {
      return right(listSaved.contains(postid));
    });
  }

  FutureEither<Tuple2<List<Post>, List<Comment>>> getSaved() async {
    final url = Uri.parse(
        "http://${AppConstants.local}:8000/api/v1/users/me/saved?page=1");
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

final updatesSaveProvider = StateProvider<String?>((ref) => null);
final updatesEditProvider = StateProvider<String?>((ref) => null);
final updatesDeleteProvider = StateProvider<String?>((ref) => null);
