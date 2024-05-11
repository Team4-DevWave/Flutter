import 'package:threddit_clone/features/chatting/model/chat_message_model.dart';

class Chatroom {
  final String id;
  final DateTime dateCreated;
  String chatroomName;
  final List<ChatroomMember> chatroomMembers;
  final ChatroomMember chatroomAdmin;
  final bool isGroup;
  final ChatMessage? latestMessage; // Can be null for new groups or deleted messages
  final int v; // Version number (assuming "_v" refers to version)

  Chatroom({
    required this.id,
    required this.dateCreated,
    required this.chatroomName,
    required this.chatroomMembers,
    required this.chatroomAdmin,
    required this.isGroup,
    this.latestMessage,
    required this.v,
  });

  factory Chatroom.fromJson(Map<String, dynamic> json) {
     final latestMessageJson = json['latestMessage'];
    ChatMessage? latestMessage;
    if (latestMessageJson != null) {
      latestMessage = ChatMessage.fromJson(latestMessageJson);
    }
    return Chatroom(
        id: json['_id'],
        dateCreated: DateTime.parse(json['dateCreated']),
        chatroomName: json['chatroomName'],
        chatroomMembers: List<ChatroomMember>.from(
            json['chatroomMembers'].map((x) => ChatroomMember.fromJson(x))),
        chatroomAdmin: ChatroomMember.fromJson(json['chatroomAdmin']),
        isGroup: json['isGroup'],
        latestMessage: latestMessage,
        v: json['__v'],
      );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'dateCreated': dateCreated.toIso8601String(),
        'chatroomName': chatroomName,
        'chatroomMembers': chatroomMembers.map((x) => x.toJson()).toList(),
        'chatroomAdmin': chatroomAdmin.toJson(),
        'isGroup': isGroup,
        'latestMessage': latestMessage?.toJson(),
        '__v': v,
      };
}

class ChatroomMember {
  final String displayName;
  final String id;
  String username;
  String? profilePicture;

  ChatroomMember({
    required this.displayName,
    required this.id,
    required this.username,
    this.profilePicture,
  });

  factory ChatroomMember.fromJson(Map<String, dynamic> json) => ChatroomMember(
        displayName: json['displayName'],
        id: json['_id'],
        username: json['username'],
        profilePicture: json['profilePicture'],
      );

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        '_id': id,
        'username': username,
        'profilePicture': profilePicture,
      };
      @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatroomMember &&
          runtimeType == other.runtimeType &&
          username == other.username;
}
