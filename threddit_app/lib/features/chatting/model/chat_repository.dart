import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/chatting/model/chat_message_model.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:http/http.dart' as http;

Future<List<Chatroom>> fetchUserChatrooms() async {
  String? token = await getToken();
  final url = Uri.parse('https://www.threadit.tech/api/v1/chatrooms/');
  final headers = {
    'Content-Type': 'application/json',
    "Authorization": "Bearer $token",
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final chatrooms = data['chatrooms'] as List;
      return chatrooms.map((chatroom) => Chatroom.fromJson(chatroom)).toList();
    } else {
      throw Exception("failed to fetch chatrooms");
    }
  } catch (error) {
    // Handle any errors that might occur during the request
    throw Exception("failed to fetch chatrooms");
  }
}

final fetchChatRooms = StreamProvider<List<Chatroom>>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) {
    return fetchUserChatrooms();
  }).asyncMap((_) async => fetchUserChatrooms());
});

typedef ChatRoomParameters = ({List<String> users, String groupName});
final createChatroom = FutureProvider.family<Chatroom, ChatRoomParameters>(
    (ref, parameters) async {
  try {
    final url = Uri.parse('https://www.threadit.tech/api/v1/chatrooms/');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final body = jsonEncode({
      'chatroomName': parameters.groupName,
      'chatroomMembers': parameters.users,
    });
    final response = await http.post(
      url,
      body: body,
      headers: headers,
    );
    if (response.statusCode == 201) {
      print('chat room created successfully');
      final id = json.decode(response.body)['data']['chatroom']['_id'];
      final urlChatroom =
          Uri.parse('https://www.threadit.tech/api/v1/chatrooms/$id');
      final responseChatroom = await http.get(urlChatroom, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (responseChatroom.statusCode == 200) {
        final Map<String, dynamic> responseData =
            jsonDecode(responseChatroom.body);
        print(responseData['data']['chatroom']);
        final chatroom = Chatroom.fromJson(responseData['data']['chatroom']);
        return chatroom;
      } else {
        throw Exception(
            'Failed to fetch chatroom. Status code: ${response.statusCode}');
      }
    } else {
      throw Exception('Failed to create chat room ');
    }
  } catch (e) {
    print('Error creating chat room: $e');
    throw Exception('Failed to create chat room: $e');
  }
});

Future<List<ChatMessage>> fetchChatMessages(String chatroomId) async {
  try {
    final url = Uri.parse(
        'https://www.threadit.tech/api/v1/chatrooms/$chatroomId/messages/');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };

    final response = await http.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print('messages fetched successfully');
      final List<dynamic> messagesJson =
          json.decode(response.body)['data']['chatMessages'];
      List<ChatMessage> messages = messagesJson
          .map((messageJson) => ChatMessage.fromJson(messageJson))
          .toList();
      return messages;
    } else {
      throw Exception(
          'Failed to load messages. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fteching room messages: $e');
    throw Exception('Failed to ftech room messages: $e');
  }
}

final getChatMessages =
    StreamProvider.family<List<ChatMessage>, String>((ref, chatroomId) {
  return Stream.periodic(const Duration(seconds: 1), (_) {
    return fetchUserChatrooms();
  }).asyncMap((_) async => fetchChatMessages(chatroomId));
});
typedef SendChatParameters = ({String message, String chatroomId});
final sendChatMessage =
    FutureProvider.family<void, SendChatParameters>((ref, parameters) async {
  try {
    final url = Uri.parse(
        'https://www.threadit.tech/api/v1/chatrooms/${parameters.chatroomId}/messages/');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final body = jsonEncode({
      'message': parameters.message,
    });
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 201) {
      print('message sent successfully');
    } else {
      throw Exception(
          'Failed to send message. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error sending message: $e');
    throw Exception('Failed to send message: $e');
  }
});
final deleteChatRoom =
    FutureProvider.family<void, String>((ref, chatroomId) async {
  try {
    final url =
        Uri.parse('https://www.threadit.tech/api/v1/chatrooms/$chatroomId');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final response = await http.delete(url, headers: headers);
    if (response.statusCode == 204) {
      print('chatroom deleted successfully');
    } else {
      throw Exception(
          'Failed to delete chatroom. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting chatroom: $e');
    throw Exception('Failed to delete chatroom: $e');
  }
});
final leaveChatRoom =
    FutureProvider.family<int, String>((ref, chatroomId) async {
  try {
    final url = Uri.parse(
        'https://www.threadit.tech/api/v1/chatrooms/$chatroomId/leave');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final response = await http.delete(url, headers: headers);
    if (response.statusCode == 204) {
      print('left chatroom successfully');
      return response.statusCode;
    } else {
      throw Exception(
          'Failed to leave chatroom. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error leaving chatroom: $e');
    throw Exception('Failed to leave chatroom: $e');
  }
});

typedef RenameChatParameters = ({String chatName, String chatroomId});
final renameChatroom =
    FutureProvider.family<void, RenameChatParameters>((ref, parameters) async {
  try {
    final url = Uri.parse(
        'https://www.threadit.tech/api/v1/chatrooms/${parameters.chatroomId}/rename');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final body = jsonEncode({
      'chatroomName': parameters.chatName,
    });
    final response = await http.patch(
      url,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      print('chatroom name changed successfully');
    } else {
      throw Exception(
          'Failed to change chatroom name. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error editing chatroom name: $e');
    throw Exception('Failed to edit chatroom name: $e');
  }
});
typedef RemoveMemberParameters = ({String memberName, String chatroomId});
final removeMember = FutureProvider.family<void, RemoveMemberParameters>(
    (ref, parameters) async {
  try {
    final url = Uri.parse(
        'https://www.threadit.tech/api/v1/chatrooms/${parameters.chatroomId}/removemember');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final body = jsonEncode({
      'member': parameters.memberName,
    });
    final response = await http.delete(
      url,
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      print('member removed successfully');
    } else {
      throw Exception(
          'Failed to remove member. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error removing member: $e');
    throw Exception('Failed to remove member: $e');
  }
});
typedef AddMemberParameters = ({List<String> memberName, String chatroomId});
final addMember =
    FutureProvider.family<void, AddMemberParameters>((ref, parameters) async {
  try {
    final url = Uri.parse(
        'https://www.threadit.tech/api/v1/chatrooms/${parameters.chatroomId}/addmember');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    for (int i = 0; i < parameters.memberName.length; i++) {
      final body = jsonEncode({
        'member': parameters.memberName,
      });
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        print('member $i added successfully');
      } else {
        throw Exception(
            'Failed to add member $i. Status code: ${response.statusCode}');
      }
    }
  } catch (e) {
    print('Error adding member: $e');
    throw Exception('Failed to add member: $e');
  }
});
