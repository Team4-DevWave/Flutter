

class Post {
  final String title;
  final String? postBody;
  final String? link;
  final bool NSFW;
  final bool spoiler;
  final String? imageUrl;
  final String? community;
  final String? videoUrl;
  final List<String> upvotes;
  final List<String> downvotes;
  final List<String> commentsID;
  final List<String> mentioned;
  final String userID;
  final DateTime postedTime;
  final String id;
  final int numViews;
  final bool locked;
  final bool approved;

  Post({
    required this.title,
    this.postBody,
    this.link,
    required this.NSFW,
    required this.spoiler,
    this.imageUrl,
    this.community,
    this.videoUrl,
    required this.upvotes,
    required this.downvotes,
    required this.commentsID,
    required this.mentioned,
    required this.userID,
    required this.postedTime,
    required this.id,
    required this.numViews,
    required this.locked,
    required this.approved,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
  return Post(
    title: json['title'] ?? '',
    postBody: json['postBody'],
    link: json['link'],
    NSFW: json['NSFW'] ?? false,
    spoiler: json['spoiler'] ?? false,
    imageUrl: json['imageUrl'],
    community: json['community'],
    videoUrl: json['videoUrl'],
    upvotes: List<String>.from(json['upvotes'] ?? []),
    downvotes: List<String>.from(json['downvotes'] ?? []),
    commentsID: List<String>.from(json['commentsID'] ?? []),
    mentioned: List<String>.from(json['mentioned'] ?? []),
    userID: json['uid'] ?? '',
    postedTime: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    id: json['_id'] ?? '',
    numViews: json['numViews'] ?? 0,
    locked: json['locked'] ?? false,
    approved: json['approved'] ?? false,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'postBody': postBody,
      'link': link,
      'NSFW': NSFW,
      'spoiler': spoiler,
      'imageUrl': imageUrl,
      'community': community,
      'videoUrl': videoUrl,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentsID': commentsID,
      'mentioned': mentioned,
      'uid': userID,
      'createdAt': postedTime.toIso8601String(),
      '_id': id,
      'numViews': numViews,
      'locked': locked,
      'approved': approved,

    };
  }
}
