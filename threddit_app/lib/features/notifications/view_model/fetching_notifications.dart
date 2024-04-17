import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// The `fetchdata` function is an asynchronous function that fetches notification data for a given user ID. It sends a GET request to a mock API and returns a `NotificationAPI`
/// object if the request is successful. If the request fails, it throws an exception.
///
/// The `NotificationAPI` class represents the response from the notifications API.
/// It has two properties: `success` and `result`. The `success` property is an integer that represents the status of the response, and the `result` property is a list of dynamic objects that represents the data of the response.
///
/// The `NotificationAPI` class has a factory constructor named `fromJson` that creates a new `NotificationAPI` object from a map. The map must contain a `status` key for the `success` property and a `data` key for the `result` property. The `data` key must map to a list.
Future<NotificationAPI> fetchdata(String id) async {
  // user id
  String urlLocal =
      'https://e10d733d-62c5-4e9e-b5a3-767c31f392c9.mock.pstmn.io/getbestpost';

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
