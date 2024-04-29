import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';

class ChatMessage {
  final String id;
  final DateTime dateSent;
  final ChatroomMember sender;
  final String message;
  final Chatroom chatID;
  final int v; // Version number (assuming "_v" refers to version)

  ChatMessage({
    required this.id,
    required this.dateSent,
    required this.sender,
    required this.message,
    required this.chatID,
    required this.v,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['_id'],
        dateSent: json['dateSent'],
        sender: ChatroomMember.fromJson(json['sender']),
        message: json['message'],
        chatID: Chatroom.fromJson(json['chatID']),
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'dateSent': dateSent,
        'sender': sender.toJson(),
        'message': message,
        'chatID': chatID.toJson(),
        '__v': v,
      };
}
