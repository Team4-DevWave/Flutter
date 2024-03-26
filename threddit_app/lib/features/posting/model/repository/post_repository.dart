import 'package:threddit_app/features/commenting/model/post.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostRepository {
  
  Future<List<String>> getUpvotes(String postID) async {
  
  final String apiUrl = 'http://192.168.100.249:3000/posts/$postID';
  final response = await http.get(Uri.parse(apiUrl));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final List<dynamic> upvotes = responseData['upvotes'] ?? [];
    return upvotes.cast<String>(); 
  } else {
    print('Failed to get upvotes. Error: ${response.reasonPhrase}');
    return []; 
  }
}

Future<List<String>> getDownvotes(String postId) async {
  
  final String apiUrl = 'http://192.168.100.249:3000/posts/$postId';
  final response = await http.get(Uri.parse(apiUrl));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final List<dynamic> downvotes = responseData['downvotes'] ?? [];
    return downvotes.cast<String>(); 
  } else {
    print('Failed to get downvotes. Error: ${response.reasonPhrase}');
    return []; 
  }
}

  Future<void> upVote(Post post, String userID) async {
    List<String>upvotes=await getUpvotes(post.id);
    List<String>downvotes=await getDownvotes(post.id);

    if (downvotes.contains(userID)) {
      post.downvotes.remove(userID);
      downvotes.remove(userID);

    }
    if (upvotes.contains(userID)) {
      post.upvotes.remove(userID);
      upvotes.remove(userID);
      
    } else {
      post.upvotes.add(userID);
      upvotes.add(userID);
    }

    final String apiUrl = 'http://192.168.100.249:3000/posts/${post.id}';
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

  Future<void> downVote(Post post, String userID) async {
    List<String>upvotes=await getUpvotes(post.id);
    List<String>downvotes=await getDownvotes(post.id);

     if (upvotes.contains(userID)) {
      post.upvotes.remove(userID);
      upvotes.remove(userID);
      
    }
    if (downvotes.contains(userID)) {
      post.downvotes.remove(userID);
      downvotes.remove(userID);
      
    } else {
      post.downvotes.add(userID);
      downvotes.add(userID);
      
    }

    final String apiUrl = 'http://192.168.100.249:3000/posts/${post.id}';
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
