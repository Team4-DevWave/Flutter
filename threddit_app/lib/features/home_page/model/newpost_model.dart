import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threddit_clone/app/pref_constants.dart';
import 'package:threddit_clone/features/user_system/model/token_storage.dart';

class Post {
  final String id;
  final String title;
  String? textBody;
  String? image;
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
  VotesList? votes;
  final Post? parentPost;
  bool? hidden;
  bool? saved;
  String? userVote;

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
    this.hidden,
    this.saved,
    this.userVote,
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
      hidden: json['hidden'],
      saved: json['saved'],
      userVote: json['userVote'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'text_body': textBody,
      'image': image,
      'nsfw': nsfw,
      'spoiler': spoiler,
      'locked': locked,
      'approved': approved,
      'postedTime': postedTime.toIso8601String(),
      'numViews': numViews,
      'commentsCount': commentsCount,
      'video': video,
      'userID': userID?.toJson(),
      'subredditID': subredditID?.toJson(),
      'votes': votes?.toJson(),
      'parentPost': parentPost?.toJson(),
      'hidden': hidden,
      'saved': saved,
      'userVote': userVote,
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
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
    };
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
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class VotesList {
  int upvotes;
  int downvotes;

  VotesList({required this.upvotes, required this.downvotes});

  factory VotesList.fromJson(Map<String, dynamic> json) {
    return VotesList(
      upvotes: json['upvotes'],
      downvotes: json['downvotes'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'upvotes': upvotes,
      'downvotes': downvotes,
    };
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
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': {
        'posts': posts.map((post) => post.toJson()).toList(),
      },
    };
  }
}

Future<PostApiResponse> fetchPosts(
    String feedID, String subreddit, int pageNumber) async {
  String? token = await getToken();

  String url = "http://10.0.2.2:8000/api/v1/posts/best?page=$pageNumber";
  if (feedID == 'Hot Posts') {
    url = "http://10.0.2.2:8000/api/v1/r/$subreddit/hot?page=$pageNumber";
  }
  if (feedID == 'New Posts') {
    url = "http://10.0.2.2:8000/api/v1/r/$subreddit/new?page=$pageNumber";
  }
  if (feedID == 'Top Posts') {
    url = "http://10.0.2.2:8000/api/v1/r/$subreddit/top?page=$pageNumber";
  }

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return PostApiResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load posts');
  }
}
