import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';

class ChatMessage {
  final String id;
  final ChatroomMember sender;
  final String dateSent;
  final String message;
  final ModifiedChatroom? chatID;
  final int v; // Version number (assuming "_v" refers to version)

  ChatMessage({
    required this.id,
    required this.dateSent,
    required this.sender,
    required this.message,
    this.chatID,
    required this.v,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['_id'],
        dateSent: json['dateSent'],
        sender: ChatroomMember.fromJson(json['sender']),
        message: json['message'],
        chatID: ModifiedChatroom.fromJson(json['chatID']),
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'dateSent': dateSent,
        'sender': sender.toJson(),
        'message': message,
        'chatID': chatID?.toJson(),
        '__v': v,
      };
}


class ModifiedChatroom {
  final String id;
  final DateTime dateCreated;
  final String chatroomName;
  final List<ChatroomMember> chatroomMembers;
  final ChatroomMember chatroomAdmin;
  final bool isGroup;
  final String? latestMessage; // Can be null for new groups or deleted messages
  final int v; // Version number (assuming "_v" refers to version)

  ModifiedChatroom({
    required this.id,
    required this.dateCreated,
    required this.chatroomName,
    required this.chatroomMembers,
    required this.chatroomAdmin,
    required this.isGroup,
    this.latestMessage,
    required this.v,
  });

  factory ModifiedChatroom.fromJson(Map<String, dynamic> json) => ModifiedChatroom(
        id: json['_id'],
        dateCreated: DateTime.parse(json['dateCreated']),
        chatroomName: json['chatroomName'],
        chatroomMembers: List<ChatroomMember>.from(
            json['chatroomMembers'].map((x) => ChatroomMember.fromJson(x))),
        chatroomAdmin: ChatroomMember.fromJson(json['chatroomAdmin']),
        isGroup: json['isGroup'],
        latestMessage: json['latestMessage'],
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'dateCreated': dateCreated.toIso8601String(),
        'chatroomName': chatroomName,
        'chatroomMembers': chatroomMembers.map((x) => x.toJson()).toList(),
        'chatroomAdmin': chatroomAdmin.toJson(),
        'isGroup': isGroup,
        'latestMessage': latestMessage,
        '__v': v,
      };
}


