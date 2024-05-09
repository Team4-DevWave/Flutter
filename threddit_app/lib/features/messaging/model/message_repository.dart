import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/models/message.dart';

class MessageRepository {
  Future<List<Message>> fetchUserMessages() async {
    final url =
        Uri.parse('https://www.threadit.tech/api/v1/messages/allmessages');
    String? token = await getToken();
    final headers = {
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> messagesJson =
            json.decode(response.body)['data']['messages'];
        List<Message> messages = messagesJson
            .map((messageJson) => Message.fromJson(messageJson))
            .toList();
        return messages;
      } else {
        throw Exception(
            'Failed to load messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch messages: $e');
    }
  }

  Stream<List<Message>> getMessagesStream() {
    return Stream.periodic(const Duration(seconds: 1), (_) {
      return fetchUserMessages();
    }).asyncMap((_) async => fetchUserMessages());
  }

  Future<void> createMessage(
      String recipient, String subject, String message) async {
    String? token = await getToken();
    final url = Uri.parse('https://www.threadit.tech/api/v1/messages/compose');
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    try {
      String formattedRecipient =
          recipient.startsWith('u/') ? recipient : 'u/$recipient';
      final body = jsonEncode({
        'from': "",
        'to': formattedRecipient,
        'subject': subject,
        'message': message
      });
      final response = await http.post(url, body: body, headers: headers);
      if (response.statusCode == 201) {
        print('Message sent successfully');
      } else if (response.statusCode == 404) {
        throw Exception('No user found with username $formattedRecipient');
      } else {
        throw Exception(
            'Failed to send message. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
      throw Exception('Failed to send message: $e');
    }
  }
}

final markAllMessagesAsReadProvider = FutureProvider<void>((ref) async {
  try {
    final url =
        Uri.parse('https://www.threadit.tech/api/v1/messages/markallread');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final response = await http.patch(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print('All messages marked as read');
    } else {
      print('Failed to mark all messages as read');
    }
  } catch (e) {
    print('Error marking all messages as read: $e');
    throw Exception('Failed to mark all messages as read: $e');
  }
});
final toggleRead = FutureProvider.family<void, String>((ref, String id) async {
  try {
    final url =
        Uri.parse('https://www.threadit.tech/api/v1/messages/$id/markread');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final response = await http.patch(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print('read flag toggled');
    } else {
      print('Failed to toggle read flag');
    }
  } catch (e) {
    print('Error toggling read flag: $e');
    throw Exception('Failed to mark all messages as read: $e');
  }
});
