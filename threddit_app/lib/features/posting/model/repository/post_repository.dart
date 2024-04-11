import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/models/post.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/models/votes.dart';

class PostRepository {
  
  Future<void> votePost(String postId, int voteType) async {
  try {
    String? token=await getToken();
    final url = 'http://10.0.2.2:8000/comments?_id=$postId';
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
      print("post upvoted");
    } else {
      print('Failed to vote on post: ${response.statusCode}');
    }
  } catch (e) {
    print('Error voting on post: $e');
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

  
  Future<void> togglePostNSFW(String postId) async {
  try {
    String? jwtToken=await getToken();
    String url = 'http://10.0.2.2:8000/api/v1/posts/$postId/nsfw';
    final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $jwtToken",
  };
    final response = await http.post(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      print('Post NSFW status toggled successfully');
    } 
  } catch (e) {
    print('Error toggling post NSFW status: $e');
  }
}

Future<Post> fetchPost(String postId) async {
  String? token=await getToken();
  final url = Uri.parse('http://10.0.2.2:8000/api/v1/posts/$postId');
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final post = Post.fromJson(responseData['data']['post']);
      return post;
    } else {
      throw Exception('Failed to fetch post. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching post: $e');
    throw Exception('Failed to fetch post');
  }
}

Future<Votes> getUserUpvotes() async {
  String? token = await getToken();
  final url = Uri.parse('http://10.0.2.2:8000/api/v1/users/me/upvoted?page=1');
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Votes.fromJson(responseData);
    } else {
      throw Exception('Failed to get user upvotes. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error getting user upvotes: $e');
    throw Exception('Failed to get user upvotes');
  }
}

Future<Votes> getUserDownvotes() async {
  String? token = await getToken();
  final url = Uri.parse('http://10.0.2.2:8000/api/v1/users/me/downvoted?page=1');
  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $token",
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Votes.fromJson(responseData);
    } else {
      throw Exception('Failed to get user downvotes. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error getting user downvotes: $e');
    throw Exception('Failed to get user downvotes');
  }
}

}