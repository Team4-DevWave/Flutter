import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

Future<PostApiResponse> fetchPostsByUsername(
    String name, int pageNumber) async {
  String? token = await getToken();

  final response = await http.get(
    Uri.parse("http://10.0.2.2:8000/api/v1/users/$name/posts?page=$pageNumber"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return PostApiResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load posts');
  }
}
