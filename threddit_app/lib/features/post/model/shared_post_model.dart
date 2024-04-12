// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:threddit_clone/models/post.dart';

class SharedPost {
  final String? title;
  final Post? post;
  final String? destination;
  final String? postIn;
  final String? postInName;
  final bool nsfw;
  final bool spoiler;
  SharedPost({
    this.title,
    this.post,
    this.destination,
    required this.postIn,
    required this.postInName,
    required this.nsfw,
    required this.spoiler,
  });

  SharedPost copyWith({
    String? title,
    Post? post,
    String? destination,
    String? postIn,
    String? postInName,
    bool? nsfw,
    bool? spoiler,
  }) {
    return SharedPost(
      title: title ?? this.title,
      post: post ?? this.post,
      destination: destination ?? this.destination,
      postIn: postIn ?? this.postIn,
      postInName: postInName ?? this.postInName,
      nsfw: nsfw ?? this.nsfw,
      spoiler: spoiler ?? this.spoiler,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'destination': destination,
      'postIn': postIn,
      'postInName': postInName,
      'nsfw': nsfw,
      'spoiler': spoiler,
    };
  }

  factory SharedPost.fromMap(Map<String, dynamic> map) {
    return SharedPost(
      title: map['title'] != null ? map['title'] as String : null,
      post: map['post'] != null
          ? Post.fromMap(map['post'] as Map<String, dynamic>)
          : null,
      destination:
          map['destination'] != null ? map['destination'] as String : null,
      postIn: map['postIn'] != null ? map['postIn'] as String : null,
      postInName:
          map['postInName'] != null ? map['postInName'] as String : null,
      nsfw: map['nsfw'] as bool,
      spoiler: map['spoiler'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SharedPost.fromJson(String source) =>
      SharedPost.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SharedPost(title: $title, post: $post, destination: $destination, postIn: $postIn, postInName: $postInName, nsfw: $nsfw, spoiler: $spoiler)';
  }

  @override
  bool operator ==(covariant SharedPost other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.post == post &&
        other.destination == destination &&
        other.postIn == postIn &&
        other.postInName == postInName &&
        other.nsfw == nsfw &&
        other.spoiler == spoiler;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        post.hashCode ^
        destination.hashCode ^
        postIn.hashCode ^
        postInName.hashCode ^
        nsfw.hashCode ^
        spoiler.hashCode;
  }
}
