import 'package:threddit_clone/models/message.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatRepository {
Future<List<Message>> fetchMessages(String uid) async {
  final response = await http.get(Uri.parse('http://192.168.100.249:3000/messages?recipient=$uid'));
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    List<Message> messages = data.map((json) => Message.fromJson(json)).toList();
    return messages;
  } else {
    throw Exception('Failed to load messages');
  }
}
Stream<List<Message>> getChatStream(String uid) {
    return Stream.periodic(const Duration(seconds: 10), (_) {
      return fetchMessages(uid);
    }).asyncMap((_) async => fetchMessages(uid));
  }
}