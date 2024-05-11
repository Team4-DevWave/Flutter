import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:threddit_clone/features/user_system/model/failure.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/features/user_system/model/type_defs.dart';
import 'package:http/http.dart' as http;

/// A state notifier that handles saving and retrieving saved comment IDs.
///
/// This class provides methods for:
/// - Sending a request to save a comment using its ID.
/// - Fetching a list of saved comment IDs from the backend.
/// - Checking if a specific comment ID is present in the list of saved IDs.
final savecommentProvider =
    StateNotifierProvider<Savecomment, bool>((ref) => Savecomment(ref));

/// A state notifier class that handles saving and unsaving comments.
class Savecomment extends StateNotifier<bool> {
  Ref ref;
  Savecomment(this.ref) : super(false);

  /// Sends a request to save the comment with the given [commentid].
  ///
  /// Returns a [FutureEither] that resolves to `true` if the request was
  /// successful or a [Failure] object if an error occurred.
  FutureEither<bool> savecommentRequest(String commentid) async {
    final url =
        Uri.parse('https://www.threadit.tech/api/v1/comments/$commentid/save');
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

  /// Sends a request to get the comment with the given [commentid].
  ///
  /// Returns a [FutureEither] that resolves to List of the user
  /// saved comments if the request was
  /// successful or a [Failure] object if an error occurred.
  FutureEither<List<String>> getSavedcommentIds() async {
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

  /// Checks if a comment is saved by the current user.
  ///
  /// This method fetches the IDs of all saved comments using [getSavedcommentIds]
  /// and checks if the provided `commentid` is present in the list.
  ///
  /// Returns a [FutureEither] containing:
  /// - [right]: `true` if the comment is saved, `false` otherwise.
  /// - [left]: A [Failure] object if there was an error retrieving the saved comment IDs.
  FutureEither<bool> isSaved(String commentid) async {
    final response = await getSavedcommentIds();
    return response.fold((l) {
      return left(Failure('Error retriving saved'));
    }, (listSaved) {
      return right(listSaved.contains(commentid));
    });
  }
}
