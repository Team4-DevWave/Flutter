import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<PostApi> fetchdata(String id) async {
  final response = await http.get(Uri.parse(
      'https://d1884b69-05d1-43d1-acf8-86c6ac9d7b85.mock.pstmn.io/getbestpost'));

  if (response.statusCode == 200) {
    return PostApi.fromJson(jsonDecode(response.body));
  }
  throw Exception('Failed to load album');
}

class PostApi {
  final int success;
  final List<dynamic> result;

  const PostApi({required this.success, required this.result});

  factory PostApi.fromJson(Map<String, dynamic> json) {
    return PostApi(
        success: json['status'], result: List<dynamic>.from(json['data']));
  }
}
