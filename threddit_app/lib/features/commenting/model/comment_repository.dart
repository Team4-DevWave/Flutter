import 'package:threddit_clone/models/comment.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;


class CommentRepository {
Future<List<Comment>> fetchComments(String postId) async {
  final response = await http.get(Uri.parse('http://192.168.100.249:3000/comments?postId=${postId}'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
   
    List<Comment> comments = data.map((json) => Comment.fromJson(json)).toList();
   
    return comments;
  } else {
    
    throw Exception('Failed to load comments');

  }
}
Stream<List<Comment>> getCommentsStream(String postId) {
    return Stream.periodic(Duration(seconds: 10), (_) {
      return fetchComments(postId);
    }).asyncMap((_) async => fetchComments(postId));
  }

  Future<void> addComment(String commentText, String postID, String uid) async {
    // Create a JSON object representing the comment
    Map<String, dynamic> commentData = {
      'text': commentText,
      'postId': postID,
      'username': uid,
      'createdAt': DateTime.now().toIso8601String(),
      'upvotes': [],
      'downvotes': [],
    };

    String jsonData = jsonEncode(commentData);

    final response = await http.post(
      Uri.parse('http://192.168.100.249:3000/comments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );

    if (response.statusCode == 201) {
      print('Comment added successfully');
      
    } else {
      throw Exception('Failed to add comment: ${response.statusCode}');
    }
  }

Future<List<String>> getUpvotes(String commentId) async {
  
  final String apiUrl = 'http://192.168.100.249:3000/comments/$commentId';
  final response = await http.get(Uri.parse(apiUrl));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final List<dynamic> upvotes = responseData['upvotes'] ?? [];
    return upvotes.cast<String>(); // Ensure the upvotes are of type List<String>
  } else {
    print('Failed to get upvotes. Error: ${response.reasonPhrase}');
    return []; // Return an empty list in case of failure
  }
}

Future<List<String>> getDownvotes(String commentId) async {
  
  final String apiUrl = 'http://192.168.100.249:3000/comments/$commentId';
  final response = await http.get(Uri.parse(apiUrl));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final List<dynamic> downvotes = responseData['downvotes'] ?? [];
    return downvotes.cast<String>(); // Ensure the upvotes are of type List<String>
  } else {
    print('Failed to get downvotes. Error: ${response.reasonPhrase}');
    return []; // Return an empty list in case of failure
  }
}

  Future<void> upVote(Comment comment, String userID) async {
    List<String>upvotes=await getUpvotes(comment.id);
    List<String>downvotes=await getDownvotes(comment.id);

    if (downvotes.contains(userID)) {
      comment.downvotes.remove(userID);
      downvotes.remove(userID);

    }
    if (upvotes.contains(userID)) {
      comment.upvotes.remove(userID);
      upvotes.remove(userID);
      
    } else {
      comment.upvotes.add(userID);
      upvotes.add(userID);
    }

    final String apiUrl = 'http://192.168.100.249:3000/comments/${comment.id}';
    final Map<String, dynamic> data = {
    'upvotes': upvotes,
    'downvotes':downvotes,
  };

  final response = await http.patch(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
  } else {
    print('Failed to update upvotes. Error: ${response.reasonPhrase}');
  }

  }

  Future<void> downVote(Comment comment, String userID) async {
    List<String>upvotes=await getUpvotes(comment.id);
    List<String>downvotes=await getDownvotes(comment.id);

     if (upvotes.contains(userID)) {
      comment.upvotes.remove(userID);
      upvotes.remove(userID);
      
    }
    if (downvotes.contains(userID)) {
      comment.downvotes.remove(userID);
      downvotes.remove(userID);
      
    } else {
      comment.downvotes.add(userID);
      downvotes.add(userID);
      
    }

    final String apiUrl = 'http://192.168.100.249:3000/comments/${comment.id}';
    final Map<String, dynamic> data = {
    'upvotes': upvotes,
    'downvotes':downvotes,
  };

  final response = await http.patch(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
  } else {
    print('Failed to update upvotes. Error: ${response.reasonPhrase}');
  }

  }

}