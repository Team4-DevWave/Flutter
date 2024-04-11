import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

class Post {
  final String id;
  final String title;
  final String? textBody;
  final String? image;
  final bool nsfw;
  final bool spoiler;
  final bool locked;
  final bool approved;
  final String postedTime;
  final int numViews;
  final int commentsCount;
  final User? userID;
  final Subreddit? subredditID;
  final Votes? votes;
  final Post? parentPost;

  Post({
    required this.id,
    required this.title,
    this.textBody,
    this.image,
    required this.nsfw,
    required this.spoiler,
    required this.locked,
    required this.approved,
    required this.postedTime,
    required this.numViews,
    this.userID,
    this.subredditID,
    this.votes,
    required this.commentsCount,
    this.parentPost,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      textBody: json['text_body'],
      image: json['image'],
      nsfw: json['nsfw'],
      spoiler: json['spoiler'],
      locked: json['locked'],
      approved: json['approved'],
      postedTime: json['postedTime'],
      numViews: json['numViews'],
      commentsCount: json['commentsCount'],
      userID: json['userID'] != null
          ? User.fromJson(json['userID'] as Map<String, dynamic>)
          : null,
      subredditID: json['subredditID'] != null
          ? Subreddit.fromJson(json['subredditID'] as Map<String, dynamic>)
          : null,
      votes: json['votes'] != null
          ? Votes.fromJson(json['votes'] as Map<String, dynamic>)
          : null,
      parentPost: json['parentPost'] != null
          ? Post.fromJson(json['parentPost'] as Map<String, dynamic>)
          : null,
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

class Subreddit {
  final String id;
  final String name;

  Subreddit({required this.id, required this.name});

  factory Subreddit.fromJson(Map<String, dynamic> json) {
    return Subreddit(
      id: json['_id'],
      name: json['name'],
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

class PostApiResponse {
  final String status;
  final List<Post> posts;

  PostApiResponse({
    required this.status,
    required this.posts,
  });

  factory PostApiResponse.fromJson(Map<String, dynamic> json) {
    return PostApiResponse(
      status: json['status'],
      posts: json['data']['posts'] != null
          ? (json['data']['posts'] as List)
              .map((i) => Post.fromJson(i))
              .toList()
          : [],
    );
  }
}

Future<PostApiResponse> fetchPosts() async {
  String? token = await getToken();
  print(token);
  final response = await http.get(
    Uri.parse("http://10.0.2.2:8000/api/v1/posts/best"),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    return PostApiResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load posts');
  }
}
