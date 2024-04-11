import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/models/comment.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class CommentRepository {
var uuid = Uuid();
Future<Comment> fetchComment(String commentId) async {
  String? token= await getToken();
  final url = Uri.parse('http://10.0.2.2:8000/api/v1/comments/$commentId');
  final headers = {
    "Authorization": "Bearer $token",
  };
  try {
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final comment = Comment.fromJson(responseData['data']['comment']);
      return comment;
    } else {
      throw Exception('Failed to fetch comment. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching comment: $e');
    throw Exception('Failed to fetch comment');
  }
}
Future<List<Comment>> fetchAllComments(List<String> commentIds) async { 
  final List<Future<Comment>> commentFutures = [];

  for (final commentId in commentIds) {
    final commentFuture = fetchComment(commentId);
    commentFutures.add(commentFuture);
  }

  final List<Comment> allComments = await Future.wait(commentFutures);
  return allComments;
}

Stream<List<Comment>> getCommentsStream(List<String> commentIds) {
    return Stream.periodic(const Duration(seconds: 10), (_) {
      return fetchAllComments(commentIds);
    }).asyncMap((_) async => fetchAllComments(commentIds));
  }

 Future<void> createComment(String postId, String content) async {
  String? token= await getToken();
  final url = Uri.parse('http://10.0.2.2:8000/api/v1/posts/$postId/comments/');
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };
  final body = jsonEncode({"content": content});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      print('comment added successfully');
    } else {
      throw Exception('Failed to create comment. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error creating comment: $e');
    throw Exception('Failed to create comment');
  }
}



  Future<void> voteComment(String commentId, int voteType) async {
  try {
    final url = 'http://10.0.2.2:8000/api/v1/comments/$commentId/vote';
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

Future<void> editComment( String commentId, String newContent) async {
  try {
    String url = 'http://10.0.2.2:8000/api/v1/comments/$commentId';
    final token = await getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
    "content": newContent,

  });
    final response = await http.patch(Uri.parse(url), headers: headers, body: body);

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
  final url = Uri.parse('http://10.0.2.2:8000/api/v1/posts/$postId/comments/$commentId');
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

