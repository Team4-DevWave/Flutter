import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/models/message.dart';

class MessageRepository {
  Future<List<Message>> fetchUserMessages() async {
    final url = Uri.parse('http://${AppConstants.local}:8000/api/v1/messages/inbox');
    String? token = await getToken();
    final headers = {
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> messagesJson = json.decode(response.body)['data']['messages'];
        List<Message> messages = messagesJson.map((messageJson) => Message.fromJson(messageJson)).toList();
        return messages;
      } else {
        throw Exception('Failed to load messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch messages: $e');
    }
  }
}
