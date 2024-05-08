import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/models/comment.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentsProvider =
    StateNotifierProvider<CommentNotifier, List<Comment>>((ref) {
  return CommentNotifier(); // You need to implement CommentNotifier
});

class CommentNotifier extends StateNotifier<List<Comment>> {
  CommentNotifier() : super([]);

  Future<void> fetchComments(String postId) async {
    final url =
        Uri.parse('https://www.threadit.tech/api/v1/posts/$postId/comments/');
    String? token = await getToken();
    final headers = {
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> commentsJson =
            json.decode(response.body)['data']['comments'];
        final comments = commentsJson
            .map((commentJson) => Comment.fromJson(commentJson))
            .toList();
        state = comments;
      } else {
        throw Exception(
            'Failed to load comments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch comments , $e');
    }
  }

  Future<void> addComment(String postId, String text, String username) async {
    String? token = await getToken();
    final url =
        Uri.parse('https://www.threadit.tech/api/v1/posts/$postId/comments/');
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.post(
        url,
        body: jsonEncode({'content': text}),
        headers: headers,
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> commentData =
            responseData['data']['comment'];

        final commentVotes = Vote(
            upvotes: commentData['votes']['upvotes'],
            downvotes: commentData['votes']['downvotes']);

        final thisUser = User(id: commentData['user'], username: username);

        final newComment = Comment(
            user: thisUser,
            content: commentData['content'],
            createdAt: DateTime.parse(commentData['createdAt']),
            votes: commentVotes,
            post: commentData['post'],
            collapsed: commentData['collapsed'],
            mentioned: [],
            id: commentData['_id'],
            version: commentData['__v']);

        state = [...state, newComment];
      } else {
        throw Exception(
            'Failed to create comment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create comment, $e');
    }
  }

  Future<void> deleteComment(String commentId, String postId) async {
    final url = Uri.parse(
        'https://www.threadit.tech/api/v1/posts/$postId/comments/$commentId');
    final token = await getToken();

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode == 204) {
        state = state.where((comment) => comment.id != commentId).toList();
        print("Comment deleted successfully.");
      } else {
        print("Failed to delete comment. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error deleting comment: $e");
    }
  }

  Future<void> editComment(String commentId, String newText) async {
    try {
      String url = 'https://www.threadit.tech/api/v1/comments/$commentId';
      final token = await getToken();
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode({
        "content": newText,
      });
      final response =
          await http.patch(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        state = state.map((comment) {
          if (comment.id == commentId) {
            return comment.copyWith(content: newText);
          }
          return comment;
        }).toList();
        print('Comment edited successfully');
      } else {
        print('Failed to edit comment. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error editing comment: $e');
    }
  }
}
