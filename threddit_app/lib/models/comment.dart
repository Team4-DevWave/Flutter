class Comment {
  final String user;
  final String content;
  final DateTime createdAt;
  final int votes;
  final List<String> upvotes;
  final List<String> downvotes;
  final String post;
  final bool hidden;
  final bool saved;
  final bool collapsed;
  final List<String> mentioned;
  final String id;
  final int version;

  Comment({
    required this.user,
    required this.content,
    required this.createdAt,
    required this.votes,
    required this.upvotes,
    required this.downvotes,
    required this.post,
    required this.hidden,
    required this.saved,
    required this.collapsed,
    required this.mentioned,
    required this.id,
    required this.version,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: json['user'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      votes: json['votes'],
      upvotes: List<String>.from(json['upvotes']),
      downvotes: List<String>.from(json['downvotes']),
      post: json['post'],
      hidden: json['hidden'],
      saved: json['saved'],
      collapsed: json['collapsed'],
      mentioned: List<String>.from(json['mentioned']),
      id: json['_id'],
      version: json['__v'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'votes': votes,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'post': post,
      'hidden': hidden,
      'saved': saved,
      'collapsed': collapsed,
      'mentioned': mentioned,
      '_id': id,
      '__v': version,
    };
  }
}
