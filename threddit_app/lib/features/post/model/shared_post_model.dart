import 'dart:convert';

import 'package:threddit_clone/features/home_page/model/newpost_model.dart';

/// `SharedPost` represents a shared instance of a post within the application.
/// This model encapsulates the details of a post that can be shared across communities
/// of the application or user profile, maintaining references to the original post's
/// context and adding details specific to the sharing action.
///
/// Attributes:
///   - `title`: An optional title for the shared post, providing context or a summary.
///   - `post`: The post being shared, which can include content such as text, images, videos or url.
///   - `destination`: An optional destination ID where the post is being shared, could represent
///     a user ID, channel, or another entity within the application.
///   - `postIn`: A required identifier indicating where the post is originally located or being shared.
///   - `postInName`: A required name or title of the location where the post is originally located or being shared.
///   - `nsfw`: A flag indicating whether the shared post contains Not Safe For Work (NSFW) content.
///   - `spoiler`: A flag indicating whether the content of the shared post should be considered a spoiler.
///
/// The class provides functionality to:
///   - Clone itself with potentially modified attributes via `copyWith`.
///   - Serialize and deserialize from and to JSON format, facilitating the easy transmission
///     and storage of its data.
///   - Generate string representations for easier logging and debugging.
///   - Compare instances for equality based on their attributes, useful in tests and when detecting changes.
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
