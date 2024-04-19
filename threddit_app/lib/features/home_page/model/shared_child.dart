import 'package:threddit_clone/features/home_page/model/newpost_model.dart';

class ChildPost {
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
  final String userID;
  final String? subredditID;
  final VotesList? votes;
  final String? parentPost;

  ChildPost({
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
    required this.userID,
    this.subredditID,
    this.votes,
    required this.commentsCount,
    this.parentPost,
  });

  factory ChildPost.fromJson(Map<String, dynamic> json) {
    return ChildPost(
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
        userID: json['userID'],
        subredditID: json['subredditID'],
        votes: json['votes'] != null
            ? VotesList.fromJson(json['votes'] as Map<String, dynamic>)
            : null,
        parentPost: json['parentPost']);
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
      'userID': userID,
      'subredditID': subredditID,
      'votes': votes?.toJson(),
      'parentPost': parentPost,
    };
  }
}

class SharedChildPost {
  final String status;
  final List<SharedChildPost> post;

  SharedChildPost({
    required this.status,
    required this.post,
  });

  factory SharedChildPost.fromJson(Map<String, dynamic> json) {
    return SharedChildPost(
      status: json['status'],
      post: json['data']['post'] != null
          ? (json['data']['post'] as List)
              .map((i) => SharedChildPost.fromJson(i))
              .toList()
          : [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': {
        'post': post.map((childPost) => childPost.toJson()).toList(),
      },
    };
  }
}
