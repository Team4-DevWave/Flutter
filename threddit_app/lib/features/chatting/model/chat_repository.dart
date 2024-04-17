import 'package:threddit_clone/models/message.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// The [ChatRepository] class provides methods for fetching chat messages from a remote server.
class ChatRepository {
  /// Fetches a list of [Message] objects for a given user ID.
  ///
  /// The [fetchMessages] method sends a GET request to the server and retrieves a list of messages for the user with the given [uid].
  /// It then decodes the response body and maps each item in the decoded list to a [Message] object.
  ///
  /// Throws an [Exception] if the server returns a status code other than 200.
  Future<List<Message>> fetchMessages(String uid) async {
    final response = await http
        .get(Uri.parse('https://www.threadit.tech/messages?recipient=$uid'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Message> messages =
          data.map((json) => Message.fromJson(json)).toList();
      return messages;
    } else {
      throw Exception('Failed to load messages');
    }
  }
}
