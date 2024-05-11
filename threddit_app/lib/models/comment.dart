import 'dart:convert';

import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
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
  String content;
  final DateTime createdAt;
  Vote votes;
  String post;
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
  Comment copyWith({
    User? user,
    String? content,
    DateTime? createdAt,
    Vote? votes,
    String? post,
    bool? collapsed,
    List<User>? mentioned,
    String? id,
    int? version,
    bool? saved,
    String? userVote,
  }) {
    return Comment(
      user: user ?? this.user,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      votes: votes ?? this.votes,
      post: post ?? this.post,
      collapsed: collapsed ?? this.collapsed,
      mentioned: mentioned ?? this.mentioned,
      id: id ?? this.id,
      version: version ?? this.version,
      saved: saved ?? this.saved,
      userVote: userVote ?? this.userVote,
    );
  }

  void addComment(User user, String post,String content,UserModelMe meModel)
  {
    Comment newComment = Comment(
      user: user,
      content: content,
      createdAt: DateTime.now(),
      votes: Vote(upvotes: 0, downvotes: 0),
      post: post,
      collapsed: false,
      mentioned: [],
      id: 'newId',
      version: 0,
    );
    newComment.post=post;
    meModel.karma!.comments++;
  }
  void deleteComment(UserModelMe me,Comment comment)
  {
    if(me.id==comment.user.id)
    {
      me.karma!.comments--;
    }
  
 
  }
   void editComment(UserModelMe me,Comment comment,String content)
  {
    if(me.id==comment.user.id)
    {
      comment.content=content;
    }
  }
  void upVoteComment(UserModelMe me,Comment comment)
  {
    if(comment.userVote=='upvote')
    {
      comment.votes.upvotes--;
      comment.userVote='none';
      me.upvotes!.comments.remove(comment.id);
    }
    else if(comment.userVote=='downvote')
    {
      comment.votes.upvotes++;
      comment.votes.downvotes--;
      comment.userVote='upvote';
      me.upvotes!.comments.add(comment.id);
      me.downvotes!.comments.remove(comment.id);
    }
    else
    {
      comment.votes.upvotes++;
      comment.userVote='upvote';
      me.upvotes!.comments.add(comment.id);
    }
  
  }
  void downVoteComment(UserModelMe me,Comment comment)
  {
    if(comment.userVote=='downvote')
    {
      comment.votes.downvotes--;
      comment.userVote='none';
      me.downvotes!.comments.remove(comment.id);
    }
    else if(comment.userVote=='upvote')
    {
      comment.votes.downvotes++;
      comment.votes.upvotes--;
      comment.userVote='downvote';
      me.downvotes!.comments.add(comment.id);
      me.upvotes!.comments.remove(comment.id);
    }
    else
    {
      comment.votes.downvotes++;
      comment.userVote='downvote';
      me.downvotes!.comments.add(comment.id);
    }
  }

}

Future<List<Comment>> fetchComments(String username) async {
  String? token = await getToken();

  final response = await http.get(
    Uri.parse("https://www.threadit.tech/api/v1/users/$username/comments"),
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
