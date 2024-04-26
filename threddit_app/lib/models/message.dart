class User {
  final String id;
  final String username;

  User({required this.id, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
    );
  }
}
class Message {
  final String id;
  final User from;
  final String fromType;
  final User to;
  final String toType;
  final String subject;
  final String message;
  final DateTime createdAt;
  final bool read;
  final bool collapsed;
  final String? comment;
  final String? post;
  final int version;

  Message({
    required this.id,
    required this.from,
    required this.fromType,
    required this.to,
    required this.toType,
    required this.subject,
    required this.message,
    required this.createdAt,
    required this.read,
    required this.collapsed,
     this.comment,
     this.post,
    required this.version,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      from: User.fromJson(json['from']),
      fromType: json['fromType'],
      to: User.fromJson(json['to']),
      toType: json['toType'],
      subject: json['subject'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      read: json['read'],
      collapsed: json['collapsed'],
      comment: json['comment'],
      post: json['post'],
      version: json['__v'],
    );
  }
}
