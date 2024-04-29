class Chatroom {
  final String id;
  final DateTime dateCreated;
  final String chatroomName;
  final List<ChatroomMember> chatroomMembers;
  final ChatroomMember chatroomAdmin;
  final bool isGroup;
  final dynamic latestMessage; // Can be null for new groups or deleted messages
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

  factory Chatroom.fromJson(Map<String, dynamic> json) => Chatroom(
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

class ChatroomMember {
  final String displayName;
  final String id;
  final String username;

  ChatroomMember({
    required this.displayName,
    required this.id,
    required this.username,
  });

  factory ChatroomMember.fromJson(Map<String, dynamic> json) => ChatroomMember(
        displayName: json['displayName'],
        id: json['_id'],
        username: json['username'],
      );

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        '_id': id,
        'username': username,
      };
}
