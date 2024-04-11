// ignore_for_file: non_constant_identifier_names
class Vote {
  final int upvotes;
  final int downvotes;

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

class Post {
  final String title;
  final String? textBody;
  final String? video;
  final String? image;
  final String? community;
  final bool spoiler;
  final bool nsfw;
  final bool locked;
  final List<String> commentsID;
  final String userID;
  final DateTime postedTime;
  final int numViews;
  final String id;
  final Vote votes;

  Post({
    required this.title,
    this.textBody,
    this.community,
    this.video,
    this.image,
    required this.spoiler,
    required this.nsfw,
    required this.locked,
    required this.commentsID,
    required this.userID,
    required this.postedTime,
    required this.numViews,
    required this.id,
    required this.votes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'] ?? '',
      textBody: json['text_body'] ?? '',
      video: json['video'],
      spoiler: json['spoiler'] ?? false,
      nsfw: json['nsfw'] ?? false,
      locked: json['locked'] ?? false,
      commentsID: List<String>.from(json['commentsID'] ?? []),
      userID: json['userID'] ?? '',
      postedTime: json['postedTime'] != null
          ? DateTime.parse(json['postedTime'])
          : DateTime.now(),
      numViews: json['numViews'] ?? 0,
      id: json['_id'] ?? '',
      votes: Vote.fromJson(json['votes']),
      community: json['community'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text_body': textBody,
      'video': video,
      'spoiler': spoiler,
      'nsfw': nsfw,
      'locked': locked,
      'commentsID': commentsID,
      'userID': userID,
      'postedTime': postedTime.toIso8601String(),
      'numViews': numViews,
      '_id': id,
      'votes': votes.toJson(),
      'community': community,
    };
  }

  static fromMap(Map<String, dynamic> map) {}
}

class PostApiResponse {
  final String status;
  final List<Post> data;

  PostApiResponse({
    required this.status,
    required this.data,
  });

  factory PostApiResponse.fromJson(Map<String, dynamic> json) {
    return PostApiResponse(
      status: json['status'],
      data: (json['data'] as List).map((i) => Post.fromJson(i)).toList(),
    );
  }
}
