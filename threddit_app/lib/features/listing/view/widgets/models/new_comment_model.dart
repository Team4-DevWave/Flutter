import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

class CommentNew {
  final Votes votes;
  final String id;
  final User user;
  final String content;
  final String createdAt;
  final String post;
  final bool hidden;
  final bool saved;
  final bool collapsed;
  List<dynamic>? mentioned;
  final int v;

  CommentNew({
    required this.votes,
    required this.id,
    required this.user,
    required this.content,
    required this.createdAt,
    required this.post,
    required this.hidden,
    required this.saved,
    required this.collapsed,
    this.mentioned,
    required this.v,
  });

  factory CommentNew.fromJson(Map<String, dynamic> json) {
    return CommentNew(
      votes: Votes.fromJson(json['votes']),
      id: json['_id'],
      user: User.fromJson(json['user']),
      content: json['content'],
      createdAt: json['createdAt'],
      post: json['post'],
      hidden: json['hidden'],
      saved: json['saved'],
      collapsed: json['collapsed'],
      mentioned: json['mentioned'],
      v: json['__v'],
    );
  }
}

class Votes {
  final int upvotes;
  final int downvotes;

  Votes({required this.upvotes, required this.downvotes});

  factory Votes.fromJson(Map<String, dynamic> json) {
    return Votes(
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
    );
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

Future<List<CommentNew>> fetchCommentNews(String username, int numPage) async {
  String? token = await getToken();

  final response = await http.get(
    Uri.parse(
        "http://www.threadit.tech/api/v1/users/${username}/comments?page=$numPage"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  print("DDDDDDDDDDDDDDDDDDDDDDDDDDD");
  print(response.body);
  if (response.statusCode == 200) {
    List<CommentNew> CommentNews = [];
    var data = jsonDecode(response.body)['data']['CommentNews'];
    for (var CommentNew in data) {
      CommentNews.add(CommentNew.fromJson(CommentNew));
    }
    return CommentNews;
  } else {
    throw Exception('Failed to load CommentNews');
  }
}
