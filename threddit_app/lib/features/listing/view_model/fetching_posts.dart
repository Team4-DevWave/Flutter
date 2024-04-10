import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/listing/model/post_model.dart';

Future<PostApiResponse> fetchPosts(String feedID, int currentPage) async {
  final response = await http.get(Uri.parse(
      'https://e10d733d-62c5-4e9e-b5a3-767c31f392c9.mock.pstmn.io/getbestpost'));

  if (response.statusCode == 200) {
    return PostApiResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load posts');
  }
}
