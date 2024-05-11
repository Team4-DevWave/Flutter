// // ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

/// `PostData` is a class that supports various types of posts including text, image, video, and link posts.
/// It provides functionalities such as functions to and from JSON, copying of post data with modifications,
/// and custom equality checks based on post attributes.
///
/// Attributes:
/// - `title`: Mandatory string representing the title of the post.
/// - `text_body`: Optional string that holds the body text of the post, if any.
/// - `url`: Optional string that represents a URL embedded within the post, relevant for link-type posts.
/// - `imagePath`: Optional [File] object pointing to a local file path of an image associated with the post.
/// - `videoPath`: Optional [File] object pointing to a local file path of a video associated with the post.
/// - `NSFW`: A boolean flag indicating whether the post contains content that is not safe for work.
/// - `spoiler`: A boolean flag indicating whether the post contains spoilers.
/// - `image`: Optional string representing an identifier or URL for an externally hosted image.
/// - `video`: Optional string representing an identifier or URL for an externally hosted video.
/// - `type`: A string indicating the type of the post (e.g., 'text', 'image', 'video').
/// - `locked`: A boolean flag that, when true, prevents further modifications to the post.
/// - `community`: Optional string representing the community or group within which the post is shared.
/// - `imageURL`: Optional string representing a direct URL to an image.
/// - `videoURL`: Optional string representing a direct URL to a video.
///
/// Methods include functionality to copy the post data, serialize to and from a map, convert to and from JSON,
/// and standard overrides for `toString`, `==`, and `hashCode` to facilitate debugging and ensure correct
/// handling in collections respectively.
class PostData {
  final String title;
  final String? text_body;
  final String? url;
  final bool NSFW;
  final bool spoiler;
  final String? image;
  final String? video;
  final String type;
  final bool locked;
  final String? community;
  final File? imagePath;
  final File? videoPath;
  final String? imageURL;
  final String? videoURL;
  final int? duration;
  final bool? availableForVoting;
  final Map<String, dynamic>? poll;

  PostData({
    required this.title,
    this.text_body,
    this.url,
    this.imagePath,
    this.videoPath,
    required this.NSFW,
    required this.spoiler,
    this.image,
    required this.type,
    required this.locked,
    this.community,
    this.video,
    this.imageURL,
    this.videoURL,
    this.availableForVoting,
    this.duration,
    this.poll,
  });

  PostData copyWith(
      {String? title,
      String? text_body,
      String? url,
      bool? NSFW,
      bool? spoiler,
      String? image,
      String? type,
      bool? locked,
      String? community,
      String? video,
      File? imagePath,
      File? videoPath,
      bool? availableForVoting,
      int? duration,
      Map<String, dynamic>? poll}) {
    return PostData(
      title: title ?? this.title,
      text_body: text_body ?? this.text_body,
      url: url ?? this.url,
      NSFW: NSFW ?? this.NSFW,
      spoiler: spoiler ?? this.spoiler,
      image: image ?? this.image,
      type: type ?? this.type,
      locked: locked ?? this.locked,
      community: community ?? this.community,
      video: video ?? this.video,
      imagePath: imagePath ?? this.imagePath,
      videoPath: videoPath ?? this.videoPath,
      availableForVoting: availableForVoting ?? this.availableForVoting,
      duration: duration ?? this.duration,
      poll: poll ?? this.poll,
    );
  }

  /// Converts the post data into a map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'text_body': text_body,
      'url': url,
      'NSFW': NSFW,
      'spoiler': spoiler,
      'image': image,
      'type': type,
      'locked': locked,
      'community': community,
      'video': video,
      'availableForVoting': availableForVoting,
      'duration': duration,
      'poll': poll
    };
  }

  /// Creates an instance from a map.
  factory PostData.fromMap(Map<String, dynamic> map) {
    return PostData(
        title: map['title'] as String,
        text_body: map['text_body'] != null ? map['text_body'] as String : null,
        url: map['url'] != null ? map['url'] as String : null,
        NSFW: map['NSFW'] as bool,
        spoiler: map['spoiler'] as bool,
        imageURL: map['image'] != null ? map['image'] as String : null,
        type: map['type'] as String,
        locked: map['locked'] as bool,
        community: map['community'] != null ? map['community'] as String : null,
        videoURL: map['video'] != null ? map['video'] as String : null,
        availableForVoting: map['availableForVoting'] as bool,
        duration: map['duration'] as int,
        poll: map['poll'] as Map<String, dynamic>);
  }

  /// Converts the instance into a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates an instance from a JSON string.
  factory PostData.fromJson(String source) =>
      PostData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostData(title: $title, text_body: $text_body, url: $url, NSFW: $NSFW, spoiler: $spoiler, image: $image, type: $type, locked: $locked, community: $community, video: $video)';
  }

  @override
  bool operator ==(covariant PostData other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.text_body == text_body &&
        other.url == url &&
        other.NSFW == NSFW &&
        other.spoiler == spoiler &&
        other.image == image &&
        other.type == type &&
        other.locked == locked &&
        other.community == community &&
        other.video == video;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        text_body.hashCode ^
        url.hashCode ^
        NSFW.hashCode ^
        spoiler.hashCode ^
        image.hashCode ^
        type.hashCode ^
        locked.hashCode ^
        community.hashCode ^
        video.hashCode;
  }
}
