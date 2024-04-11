import 'package:threddit_clone/models/comment.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class CommentRepository {
var uuid = Uuid();
Future<Comment> fetchComment(String postId, String commentId, String uid) async { //uid to be changed to token 
  final String baseUrl = 'http://192.168.100.249:3000/comments?_id=$commentId';

  final Map<String, String> headers = {
    'Content-Type': 'application/json', 
    //'Authorization': 'Bearer $token',
  };

    final http.Response response = await http.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
    final Map<String, dynamic> comment = data.first;
        return Comment.fromJson(comment);
    } else {
    throw Exception('Failed to fetch comment: ${response.statusCode}');
  
}
}
Future<List<Comment>> fetchAllComments(List<String> commentIds, String postId, String uid) async { //TODO to be changed to token 
  final List<Future<Comment>> commentFutures = [];

  for (final commentId in commentIds) {
    final commentFuture = fetchComment(postId, commentId, uid);
    commentFutures.add(commentFuture);
  }

  final List<Comment> allComments = await Future.wait(commentFutures);
  return allComments;
}

Stream<List<Comment>> getCommentsStream(List<String> commentIds, String postId, String uid) {
    return Stream.periodic(const Duration(seconds: 10), (_) {
      return fetchAllComments(commentIds, postId, uid);
    }).asyncMap((_) async => fetchAllComments(commentIds, postId, uid));
  }

 void addComment(String postId, String content, String uid) async {
  const String baseUrl = 'http://192.168.100.249:3000/comments';
  Comment comment=Comment(collapsed: false,content: content,createdAt: DateTime.now(),downvotes: [],hidden: false,mentioned: [],post: postId,saved: false,upvotes: [],user: uid,votes: 0,version: 0,id: uuid.v4());

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    //'Authorization': 'Bearer $token',
  };
  // final Map<String, dynamic> body = {
  //   'content': content,
  // };
  final Map<String, dynamic> body = comment.toJson();

    final http.Response response = await http.post(Uri.parse(baseUrl), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      print('added comment successfully');
    } else {
      throw Exception('Failed to add comment: ${response.statusCode}');
    }
  } 



  Future<void> voteComment(String commentId, int voteType,String token) async {
  try {
    final url = 'http://192.168.100.249:3000/comments?_id=$commentId';
    final Map<String, String> headers = {
    'Content-Type': 'application/json',
    //'Authorization': 'Bearer $token',
  };
    final response = await http.patch(
      Uri.parse(url),
      body: jsonEncode({'voteType': voteType}),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print("data fteched successfully");
    } else {
      print('Failed to vote on comment: ${response.statusCode}');
    }
  } catch (e) {
    print('Error voting on comment: $e');
  }
}

Future<void> editComment(String postId, String commentId, String newContent, String uid) async {
  try {
    // Construct the URL
    String url = 'http://192.168.100.249:3000/comments?_id=$commentId';

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      //'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
    "content": newContent,
  });
    final response = await http.patch(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      // Comment edited successfully
      print('Comment edited successfully');
    } else {
      // Error occurred
      print('Failed to edit comment. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error editing comment: $e');
  }
}

Future<void> deleteComment(String postId, String commentId, String uid) async {
  //final url = Uri.parse('http://localhost:8000/api/v1/posts/$postId/comments/$commentId');
  String url = 'http://192.168.100.249:3000/comments?_id=$commentId';

  final headers = {
    "Content-Type": "application/json",
    //"Authorization": "Bearer $token", // Add your token here
  };

  try {
    final response = await http.delete(Uri.parse(url), headers: headers);
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

