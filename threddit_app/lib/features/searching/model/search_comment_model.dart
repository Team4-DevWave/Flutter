import 'dart:convert';

import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';
import 'package:http/http.dart' as http;

/// Mention class responsible for holding and parsing the mentioned users data in the comment search result.

class Mention {
  final String id;
  final String username;

  Mention({
    required this.id,
    required this.username,
  });

  factory Mention.fromJson(Map<String, dynamic> json) {
    return Mention(
      id: json['_id'],
      username: json['username'],
    );
  }
}

/// Vote class responsible for holding and parsing the votes data in the comment search result.

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

/// User class responsible for holding and parsing the user data in the comment search result.
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

/// Comments Model for the search comment model results

class SearchCommentModel {
  final User user; //
  final String content; //
  final DateTime createdAt; //
  Vote votes; //
  final Post? post; //
  final bool? hidden; //
  final bool? saved; //
  final bool collapsed; //
  final List<Mention> mentioned; //
  final String id; //
  final int version; //
  SearchCommentModel({
    required this.user,
    required this.content,
    required this.createdAt,
    required this.votes,
    required this.post,
    required this.hidden,
    required this.saved,
    required this.collapsed,
    required this.mentioned,
    required this.id,
    required this.version,
  });

  factory SearchCommentModel.fromJson(Map<String, dynamic> json) {
    Post? tempPost;
    if (json["post"] == null) {
      tempPost = null;
    } else {
      tempPost = Post.fromJson(json['post']);
    }
    return SearchCommentModel(
      user: User.fromJson(json['user']),
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      votes: Vote.fromJson(json['votes']),
      post: tempPost,
      hidden: json['hidden'],
      saved: json['saved'],
      collapsed: json['collapsed'],
      mentioned: (json['mentioned'] as List)
          .map((mentionJson) => Mention.fromJson(mentionJson))
          .toList(),
      id: json['_id'],
      version: json['__v'],
    );
  }
}

class SearchCommentsList {
  final List<SearchCommentModel> comments;

  SearchCommentsList({required this.comments});

  factory SearchCommentsList.fromJson(List<dynamic> json) {
    List<SearchCommentModel> comments =
        json.map((i) => SearchCommentModel.fromJson(i)).toList();

    return SearchCommentsList(
      comments: comments,
    );
  }
}
