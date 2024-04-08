import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<NotificationAPI> fetchdata(String id) async {
  // user id
  String urlLocal =
      'https://d1884b69-05d1-43d1-acf8-86c6ac9d7b85.mock.pstmn.io/getbestpost';

  final response = await http.get(Uri.parse(urlLocal));

  if (response.statusCode == 200) {
    return NotificationAPI.fromJson(jsonDecode(response.body));
  }
  throw Exception('Failed to load album');
}

class NotificationAPI {
  final int success;
  final List<dynamic> result;

  const NotificationAPI({required this.success, required this.result});

  factory NotificationAPI.fromJson(Map<String, dynamic> json) {
    return NotificationAPI(
        success: json['status'], result: List<dynamic>.from(json['data']));
  }
}
