import 'dart:convert';

/// Represents various types of posts, including text, image, video, and poll posts.
///
/// This class provides a flexible data structure for defining different types of posts that users can create or interact with in an application.
/// It supports attributes for specifying the type of post, whether it contains text, images, videos, or polls, and various other metadata associated with posts.
///
/// Attributes:
/// - `postTypesOptions`: A string representing options for post types, such as 'text', 'image', 'video', or 'poll'.
/// - `imagePosts`: A boolean indicating whether image posts are enabled.
/// - `videoPosts`: A boolean indicating whether video posts are enabled.
/// - `pollPosts`: A boolean indicating whether poll posts are enabled.
///
/// Methods:
/// - `copyWith`: Creates a copy of the instance with optional new values for its fields.
/// - `toMap`: Converts the post types instance into a map.
/// - `fromMap`: Constructs an instance from a map.
/// - `toJson`: Converts the instance into a JSON string.
/// - `fromJson`: Constructs an instance from a JSON string.
///
/// Example:
/// ```dart
/// final postTypes = PostTypes(
///   postTypesOptions: 'image',
///   imagePosts: true,
///   videoPosts: false,
///   pollPosts: false,
/// );
/// print(postTypes);
/// ```
class PostTypes {
  /// Options for post types, such as text, image, video, or poll.
  String? postTypesOptions;

  /// Indicates whether image posts are enabled.
  bool? imagePosts;

  /// Indicates whether video posts are enabled.
  bool? videoPosts;

  /// Indicates whether poll posts are enabled.
  bool? pollPosts;

  /// Constructs a new instance of [PostTypes].
  ///
  /// [postTypesOptions] specifies the options for post types, such as 'text', 'image', 'video', or 'poll'.
  /// [imagePosts] indicates whether image posts are enabled.
  /// [videoPosts] indicates whether video posts are enabled.
  /// [pollPosts] indicates whether poll posts are enabled.
  PostTypes({
    this.postTypesOptions,
    this.imagePosts,
    this.videoPosts,
    this.pollPosts,
  });

  /// Creates a copy of this [PostTypes] instance with the given fields replaced by new values.
  ///
  /// Returns a new [PostTypes] instance with the specified fields replaced by new values.
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

  /// Converts this [PostTypes] instance to a map.
  ///
  /// This method serializes the [PostTypes] instance into a map representation,
  /// which can be converted to JSON or used for other purposes.
  ///
  /// Returns a map representation of this [PostTypes] instance.
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

  /// Constructs a [PostTypes] instance from a map.
  ///
  /// This factory method constructs a new [PostTypes] instance from a map,
  /// typically obtained from deserializing JSON data.
  ///
  /// Returns a new [PostTypes] instance constructed from the provided map.
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

  /// Converts this [PostTypes] instance to a JSON string.
  ///
  /// This method serializes the [PostTypes] instance into a JSON string,
  /// which can be stored or transmitted over the network.
  ///
  /// Returns a JSON representation of this [PostTypes] instance.
  String toJson() => json.encode(toMap());

  /// Constructs a [PostTypes] instance from a JSON string.
  ///
  /// This factory method constructs a new [PostTypes] instance from a JSON string,
  /// typically obtained from a network response or a file.
  ///
  /// Returns a new [PostTypes] instance constructed from the provided JSON string.
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
