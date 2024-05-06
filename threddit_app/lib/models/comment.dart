import 'dart:convert';

import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/models/subreddit.dart';

class Vote {
  int upvotes;
  int downvotes;

  Vote({
    required this.upvotes,
    required this.downvotes,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      upvotes: json['upvotes'] ?? 0,
      downvotes: json['downvotes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
  }
}

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

class Comment {
  final User user;
  final String content;
  final DateTime createdAt;
  Vote votes;
  final String post;
  final bool collapsed;
  final List<User> mentioned;
  final String id;
  final int version;
   bool? saved;
  String? userVote;

  Comment({
    required this.user,
    required this.content,
    required this.createdAt,
    required this.votes,
    required this.post,
    required this.collapsed,
    required this.mentioned,
    required this.id,
    required this.version,
    this.userVote,
    this.saved,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      user: User.fromJson(json['user']),
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      votes: Vote.fromJson(json['votes']),
      post: json['post'] ?? " ",
      collapsed: json['collapsed'],
      mentioned: List<User>.from(
          json['mentioned'].map((i) => User.fromJson(i)).toList()),
      id: json['_id'],
      version: json['__v'],
       saved: json['saved'],
      userVote: json['userVote'],
    );
  }
}

Future<List<Comment>> fetchComments(String username) async {
  String? token = await getToken();

  final response = await http.get(
    Uri.parse("http://10.0.2.2:8000/api/v1/users/$username/comments"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> commentsJson =
        json.decode(response.body)['data']['comments'];
    return commentsJson
        .map((commentJson) => Comment.fromJson(commentJson))
        .toList();
  } else {
    throw Exception('Failed to load comments');
  }
}
