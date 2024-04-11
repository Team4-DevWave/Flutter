// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

import 'package:threddit_clone/models/post.dart';

class SharedPost {
  final String? title;
  final String? string;
  final Post? post;
  final String? postIn;
  final String? postInName;
  final bool NSFW;
  final bool spoiler;
  final bool postCommentNotifications;
  SharedPost({
    this.title,
    this.string,
    this.post,
    required this.postIn,
    required this.postInName,
    required this.NSFW,
    required this.spoiler,
    required this.postCommentNotifications,
  });

  SharedPost copyWith({
    String? title,
    String? string,
    Post? post,
    String? postIn,
    String? postInName,
    bool? NSFW,
    bool? spoiler,
    bool? postCommentNotifications,
  }) {
    return SharedPost(
      title: title ?? this.title,
      string: string ?? this.string,
      post: post ?? this.post,
      postIn: postIn ?? this.postIn,
      postInName: postInName ?? this.postInName,
      NSFW: NSFW ?? this.NSFW,
      spoiler: spoiler ?? this.spoiler,
      postCommentNotifications:
          postCommentNotifications ?? this.postCommentNotifications,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'string': string,
      //  'post': post?.toMap(),
      'postIn': postIn,
      'postInName': postInName,
      'NSFW': NSFW,
      'spoiler': spoiler,
      'postCommentNotifications': postCommentNotifications,
    };
  }

  factory SharedPost.fromMap(Map<String, dynamic> map) {
    return SharedPost(
      title: map['title'] != null ? map['title'] as String : null,
      string: map['string'] != null ? map['string'] as String : null,
      post: map['post'] != null
          ? Post.fromMap(map['post'] as Map<String, dynamic>)
          : null,
      postIn: map['postIn'] != null ? map['postIn'] as String : null,
      postInName:
          map['postInName'] != null ? map['postInName'] as String : null,
      NSFW: map['NSFW'] as bool,
      spoiler: map['spoiler'] as bool,
      postCommentNotifications: map['postCommentNotifications'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SharedPost.fromJson(String source) =>
      SharedPost.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SharedPost(title: $title, string: $string, post: $post, postIn: $postIn, postInName: $postInName, NSFW: $NSFW, spoiler: $spoiler, postCommentNotifications: $postCommentNotifications)';
  }

  @override
  bool operator ==(covariant SharedPost other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.string == string &&
        other.post == post &&
        other.postIn == postIn &&
        other.postInName == postInName &&
        other.NSFW == NSFW &&
        other.spoiler == spoiler &&
        other.postCommentNotifications == postCommentNotifications;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        string.hashCode ^
        post.hashCode ^
        postIn.hashCode ^
        postInName.hashCode ^
        NSFW.hashCode ^
        spoiler.hashCode ^
        postCommentNotifications.hashCode;
  }
}
