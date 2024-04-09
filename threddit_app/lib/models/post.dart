

class Post {
  final String title;
  final String? postBody;
  final String? link;
  final bool isNSFW;
  final bool isSpoiler;
  final String? imageUrl;
  final String? community;
  final String? videoUrl;
  final List<String> upvotes;
  final List<String> downvotes;
  final String commentCount;
  final String uid;
  final DateTime createdAt;

  Post({
    required this.title,
    this.postBody,
    this.link,
    required this.isNSFW,
    required this.isSpoiler,
    this.imageUrl,
    this.community,
    this.videoUrl,
    required this.upvotes,
    required this.downvotes,
    required this.commentCount,
    required this.uid,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      postBody: json['postBody'],
      link: json['link'],
      isNSFW: json['isNSFW'],
      isSpoiler: json['isSpoiler'],
      imageUrl: json['imageUrl'],
      community: json['community'],
      videoUrl: json['videoUrl'],
      upvotes: List<String>.from(json['upvotes']),
      downvotes: List<String>.from(json['downvotes']),
      commentCount: json['commentCount'],
      uid: json['uid'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'postBody': postBody,
      'link': link,
      'isNSFW': isNSFW,
      'isSpoiler': isSpoiler,
      'imageUrl': imageUrl,
      'community': community,
      'videoUrl': videoUrl,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'commentCount': commentCount,
      'uid': uid,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
