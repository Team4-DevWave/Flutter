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