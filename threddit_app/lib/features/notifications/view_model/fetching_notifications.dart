import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

Future<NotificationAPI> fetchDataNotifications(String id) async {
  // user id
  String urlLocal = 'http://10.0.2.2:8000/api/v1/notifications';
  String? token = await getToken();
  final response = await http.get(
    Uri.parse(urlLocal),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return NotificationAPI.fromJson(jsonDecode(response.body));
  }
  throw Exception('Failed to load album');
}

class NotificationData {
  final String id;
  final String recipient;
  final String content;
  final String createdAt;
  final bool read;
  final String type;
  final bool hidden;
  final String sender;
  final String contentID;
  final int v;

  NotificationData({
    required this.id,
    required this.recipient,
    required this.content,
    required this.createdAt,
    required this.read,
    required this.type,
    required this.hidden,
    required this.sender,
    required this.contentID,
    required this.v,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['_id'],
      recipient: json['recipient'],
      content: json['content'],
      createdAt: json['createdAt'],
      read: json['read'],
      type: json['type'],
      hidden: json['hidden'],
      sender: json['sender'],
      contentID: json['contentID'],
      v: json['__v'],
    );
  }
}

class NotificationAPI {
  final String status;
  final List<NotificationData> notifications;

  NotificationAPI({
    required this.status,
    required this.notifications,
  });

  factory NotificationAPI.fromJson(Map<String, dynamic> json) {
    return NotificationAPI(
      status: json['status'],
      notifications: (json['data']['notifications'] as List)
          .map((i) => NotificationData.fromJson(i))
          .toList(),
    );
  }
}
