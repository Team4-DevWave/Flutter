import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

class Post {
  final String id;
  final String title;
   String? textBody;
  final String? image;
   bool nsfw;
   bool spoiler;
   bool locked;
  final bool approved;
  final DateTime postedTime;
  String? video;
  final int numViews;
   int commentsCount;
  final User? userID;
  final SubredditInfo? subredditID;
  final VotesList? votes;
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
    this.video,
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
      video: json['video'],
      postedTime: json['postedTime'] != null
          ? DateTime.parse(json['postedTime'])
          : DateTime.now(),
      numViews: json['numViews'],
      commentsCount: json['commentsCount'],
      userID: json['userID'] != null
          ? User.fromJson(json['userID'] as Map<String, dynamic>)
          : null,
      subredditID: json['subredditID'] != null
          ? SubredditInfo.fromJson(json['subredditID'] as Map<String, dynamic>)
          : null,
      votes: json['votes'] != null
          ? VotesList.fromJson(json['votes'] as Map<String, dynamic>)
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

class SubredditInfo {
  final String id;
  final String name;

  SubredditInfo({required this.id, required this.name});

  factory SubredditInfo.fromJson(Map<String, dynamic> json) {
    return SubredditInfo(
      id: json['_id'],
      name: json['name'],
    );
  }
}

class VotesList {
  final int upvotes;
  final int downvotes;

  VotesList({required this.upvotes, required this.downvotes});

  factory VotesList.fromJson(Map<String, dynamic> json) {
    return VotesList(
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
