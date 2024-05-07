import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:threddit_clone/features/chatting/model/chat_message_model.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:threddit_clone/app/pref_constants.dart';

final socketProvider = Provider((ref) async {
  String socketUrl = "http://${AppConstants.local}:3005";
  print('we are here');
  // Fetch token asynchronously
  String? token = await getToken();

  // Initialize socket provider with the obtained token
  IO.Socket socket = IO.io(socketUrl, <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
    'query': {'token': token},
  });

  socket.connect();
socket.on('connect', (_) {
  print('connected');
});
  return socket;
});



final chatNotifierProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  final socketFuture = ref.watch(socketProvider);
  final chatNotifier = ChatNotifier(socketFuture);
  chatNotifier.setupListeners(); 
  return chatNotifier;
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final Future<IO.Socket> socketFuture;

ChatNotifier(this.socketFuture) : super([]);
Future<void> fetchRoomMessages(String roomId) async {
   try {
    final url = Uri.parse('http://${AppConstants.local}:8000/api/v1/chatrooms/$roomId/messages/');
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
      final List<dynamic> messagesJson = json.decode(response.body)['data']['chatMessages'];
        List<ChatMessage> messages = messagesJson.map((messageJson) => ChatMessage.fromJson(messageJson)).toList();
       state=messages;
      
    } else {
      throw Exception('Failed to load messages. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fteching room messages: $e');
    throw Exception('Failed to ftech room messages: $e');
  }
  }
 void setupListeners() {
  socketFuture.then((socket) async {
    socket.on('message received', (data) {
      print('Message received: $data');
      final sender= ChatroomMember.fromJson(data['sender']);
      print(sender.username);
      final chatMessage = ChatMessage(id: data['_id'], dateSent: data['dateSent'], sender: ChatroomMember.fromJson(data['sender']), message: data['message'], v: 0); 
      print(chatMessage.message);
      state = [...state, chatMessage]; // Update state with the new message
    });

    // Join the room(s) upon socket connection
    await joinRooms(socket);
  }).catchError((error) {
    print('Error initializing socket: $error');
  });
}

Future<void> joinRooms(IO.Socket socket) async {
  try {
    // Fetch the list of rooms to join (e.g., from your application state)
    List<String> roomsToJoin = ['room1', 'room2']; // Replace with your logic

    // Emit a "join rooms" event for each room
    for (String room in roomsToJoin) {
      socket.emit('join rooms', room);
      print('Joined room: $room');
    }
  } catch (e) {
    print('Error joining rooms: $e');
  }
}
 Future<void> sendMessage(String message, String roomId,String username) async {
   socketFuture.then((socket) {
     socket.emit('new message', {'message': message, 'roomID': roomId});
    }); 
  }
Future<void> deleteMessage(String messageId) async {
  try {
    final url = Uri.parse('http://${AppConstants.local}:8000/api/v1/chatmessages/$messageId');
    String? token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    final response = await http.delete(
      url,
      headers: headers
    );
    if (response.statusCode == 204) {
       state = state.where((message) => message.id != messageId).toList();
      
    } else {
      throw Exception('Failed to delete message. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error deleting message: $e');
    throw Exception('Failed to delete message : $e');
  }
  }


  @override
  void dispose() {
    socketFuture.then((socket) {
      socket.dispose();
    });
    super.dispose();
  }
}

