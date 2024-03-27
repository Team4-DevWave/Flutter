import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<PostApi> fetchdata(String id) async {
  String urlLocal =
      'https://d1884b69-05d1-43d1-acf8-86c6ac9d7b85.mock.pstmn.io/getbestpost';
  if (id == "Best") {
    urlLocal =
        'https://d1884b69-05d1-43d1-acf8-86c6ac9d7b85.mock.pstmn.io/getbestpost';
  } else if (id == "Hot") {
    urlLocal =
        'https://e59c8b6e-2d09-4b54-8bd6-6caa975cb21d.mock.pstmn.io/hotpost';
  }

  final response = await http.get(Uri.parse(urlLocal));

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
