

class Comment {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String username;
  final String? profilePic;
  final List<String> upvotes;
  final List<String> downvotes;

  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.username,
    this.profilePic,
    required this.upvotes,
    required this.downvotes,
  });

  Comment copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? username,
    String? profilePic,
    List<String>? upvotes,
    List<String>? downvotes,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      username: username ?? this.username,
      profilePic: profilePic ?? this.profilePic,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'username': username,
      'profilePic': profilePic,
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      postId: map['postId'] ?? '',
      username: map['username'] ?? '',
      profilePic: map['profilePic'] ?? '',
      upvotes: List<String>.from(map['upvotes']),
      downvotes: List<String>.from(map['downvotes']),
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, text: $text, createdAt: $createdAt, postId: $postId, username: $username, profilePic: $profilePic,upvotes: $upvotes, downvotes: $downvotes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.id == id &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.postId == postId &&
        other.username == username &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        upvotes.hashCode ^
        downvotes.hashCode ^
        postId.hashCode ^
        username.hashCode ^
        profilePic.hashCode;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'postId': postId,
      'username': username,
      'profilePic': profilePic,
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }

  // Factory method to create a Comment object from a JSON map
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      postId: json['postId'],
      username: json['username'],
      profilePic: json['profilePic'],
      upvotes: List<String>.from(json['upvotes']),
      downvotes: List<String>.from(json['downvotes']),
    );
  }
}
