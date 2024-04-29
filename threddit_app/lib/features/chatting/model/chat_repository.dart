import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:http/http.dart' as http;

final fetchChatRooms = FutureProvider<List<Chatroom>>((ref) async {
   String? token = await getToken();
    final url = Uri.parse('http://${AppConstants.local}/api/v1/chatrooms/');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final chatrooms = data['chatrooms'] as List;
      
        return chatrooms.map((json) => Chatroom.fromJson(json)).toList();
      
    } else {
      
      print('Error fetching chatrooms: ${response.statusCode}');
      return [];
    }

});

typedef ChatRoomParameters = ({List<String> users, String groupName});
final createChatroom=FutureProvider.family<void,ChatRoomParameters>((ref,parameters) async {
  try {
    final url = Uri.parse('http://${AppConstants.local}:8000/api/v1/chatrooms/');
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
      body:body,
      headers: headers,
    );
    if (response.statusCode == 201) {
      print('chat room created successfully');
    } else {
      print('Failed to create chat room ');
    }
  } catch (e) {
    print('Error creating chat room: $e');
    throw Exception('Failed to create chat room: $e');
  }
});
