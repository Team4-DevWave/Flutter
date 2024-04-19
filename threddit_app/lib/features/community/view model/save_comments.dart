import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:http/http.dart' as http;

final savecommentProvider =
    StateNotifierProvider<Savecomment, bool>((ref) => Savecomment(ref));

class Savecomment extends StateNotifier<bool> {
  Ref ref;
  Savecomment(this.ref) : super(false);

  FutureEither<bool> savecommentRequest(String commentid) async {
    final url = Uri.parse(
        'http://${AppConstants.local}:8000/api/v1/comments/$commentid/save');
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

  FutureEither<List<String>> getSavedcommentIds() async {
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
        final List<dynamic> comments = body['comments'];

        final List<String> commentIds =
            comments.map((comment) => comment['_id'] as String).toList();
        return Right(commentIds);
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

  FutureEither<bool> isSaved(String commentid) async {
    final response = await getSavedcommentIds();
    return response.fold((l) {
      return left(Failure('Error retriving saved'));
    }, (listSaved) {
      return right(listSaved.contains(commentid));
    });
  }
}
