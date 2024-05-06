import 'dart:convert';

class PostTypes {
  String? postTypesOptions;
  bool? imagePosts;
  bool? videoPosts;
  bool? pollPosts;
  PostTypes({
    this.postTypesOptions,
    this.imagePosts,
    this.videoPosts,
    this.pollPosts,
  });

  PostTypes copyWith({
    String? postTypesOptions,
    bool? imagePosts,
    bool? videoPosts,
    bool? pollPosts,
  }) {
    return PostTypes(
      postTypesOptions: postTypesOptions ?? this.postTypesOptions,
      imagePosts: imagePosts ?? this.imagePosts,
      videoPosts: videoPosts ?? this.videoPosts,
      pollPosts: pollPosts ?? this.pollPosts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "-Nwaw3NhVyf1OkiIfPKU": {
        'postTypesOptions': postTypesOptions,
        'imagePosts': imagePosts,
        'videoPosts': videoPosts,
        'pollPosts': pollPosts,
      }
    };
  }

  factory PostTypes.fromMap(Map<String, dynamic> map) {
    return PostTypes(
      postTypesOptions: map['postTypesOptions'] != null
          ? map['postTypesOptions'] as String
          : null,
      imagePosts: map['imagePosts'] != null ? map['imagePosts'] as bool : null,
      videoPosts: map['videoPosts'] != null ? map['videoPosts'] as bool : null,
      pollPosts: map['pollPosts'] != null ? map['pollPosts'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostTypes.fromJson(String source) => PostTypes.fromMap(
      json.decode(source)["-Nwaw3NhVyf1OkiIfPKU"] as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostTypes(postTypesOptions: $postTypesOptions, imagePosts: $imagePosts, videoPosts: $videoPosts, pollPosts: $pollPosts)';
  }

  @override
  bool operator ==(covariant PostTypes other) {
    if (identical(this, other)) return true;

    return other.postTypesOptions == postTypesOptions &&
        other.imagePosts == imagePosts &&
        other.videoPosts == videoPosts &&
        other.pollPosts == pollPosts;
  }

  @override
  int get hashCode {
    return postTypesOptions.hashCode ^
        imagePosts.hashCode ^
        videoPosts.hashCode ^
        pollPosts.hashCode;
  }
}
