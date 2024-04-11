import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/models/post.dart';

Future<PostApiResponse> fetchPosts(String feedID, int currentPage) async {
  final response = await http.get(Uri.parse('http://192.168.56.1:3000/posts'));

  if (response.statusCode == 200) {
    return PostApiResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load posts');
  }
}
