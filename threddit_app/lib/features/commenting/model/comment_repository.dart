import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/models/comment.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

///this repository handles all the http requests sent to the backend related to comment
///operations like fetching all comments, creating a comment, voting on a comment, editing a comment and deleting a comment
///fetch comment is used to get all the comments of a post and then used by get comments stream which automatically fetches the comments every 5 seconds to update the UI continously
///create comment is used to create a new comment on a post
///vote comment is used to vote on a comment, vote type is 1 for upvote and -1 for downvote
///edit comment is used to edit a comment and accepts a comment ID and the new content as it's parameters
///delete comment is used to delete a comment and accepts a comment ID as it's parameter

class CommentRepository {
  var uuid = const Uuid();

  Future<List<Comment>> fetchAllComments(String postId) async {
    final url = Uri.parse(
        'http://${AppConstants.local}:8000/api/v1/posts/$postId/comments/');
    String? token = await getToken();
    final headers = {
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> commentsJson =
            json.decode(response.body)['data']['comments'];
        return commentsJson
            .map((commentJson) => Comment.fromJson(commentJson))
            .toList();
      } else {
        throw Exception(
            'Failed to load comments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch comments');
    }
  }

  Stream<List<Comment>> getCommentsStream(String postId) {
    return Stream.periodic(const Duration(seconds: 1), (_) {
      return fetchAllComments(postId);
    }).asyncMap((_) async => fetchAllComments(postId));
  }

  Future<void> createComment(String postId, String content) async {
    String? token = await getToken();
    final url = Uri.parse(
        'http://${AppConstants.local}:8000/api/v1/posts/$postId/comments/');
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.post(
        url,
        body: jsonEncode({'content': content}),
        headers: headers,
      );
      if (response.statusCode == 201) {
      } else {
        throw Exception(
            'Failed to create comment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create comment');
    }
  }

  Future<void> voteComment(String commentId, int voteType) async {
    try {
      final url =
          'http://${AppConstants.local}:8000/api/v1/comments/$commentId/vote';
      final token = await getToken();
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final response = await http.patch(
        Uri.parse(url),
        body: jsonEncode({'voteType': voteType}),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("voted successfully");
      } else {
        print('Failed to vote on comment: ${response.statusCode}');
      }
    } catch (e) {
      print('Error voting on comment: $e');
    }
  }

  Future<void> editComment(String commentId, String newContent) async {
    try {
      String url =
          'http://${AppConstants.local}:8000/api/v1/comments/$commentId';
      final token = await getToken();
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode({
        "content": newContent,
      });
      final response =
          await http.patch(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Comment edited successfully');
      } else {
        print('Failed to edit comment. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error editing comment: $e');
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    final url = Uri.parse(
        'http://${AppConstants.local}:8000/api/v1/posts/$postId/comments/$commentId');
    final token = await getToken();

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 200) {
        print("Comment deleted successfully.");
      } else {
        print("Failed to delete comment. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error deleting comment: $e");
    }
  }
}
