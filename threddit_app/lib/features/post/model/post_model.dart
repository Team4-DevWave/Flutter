// // ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostData {
  final String title;
  final String? text_body;
  final String? url;
  final bool NSFW;
  final bool spoiler;
  //final ByteData? image;
  final String?image;
  final String?video;
  final String type;
  final bool locked;
  final String? community;
  //final ByteData? video;
  final String? imageURL;
  final String? videoURL;

  PostData({
    required this.title,
    this.text_body,
    this.url,
    required this.NSFW,
    required this.spoiler,
    this.image,
    required this.type,
    required this.locked,
    this.community,
    this.video,
    this.imageURL,
    this.videoURL,
  });

  PostData copyWith({
    String? title,
    String? text_body,
    String? url,
    bool? NSFW,
    bool? spoiler,
    String? image,
    String? type,
    bool? locked,
    String? community,
    String? video,
  }) {
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
    );
  }

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
    };
  }

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
      videoURL: map['video'] != null ? map['video']as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostData.fromJson(String source) => PostData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostData(title: $title, text_body: $text_body, url: $url, NSFW: $NSFW, spoiler: $spoiler, image: $image, type: $type, locked: $locked, community: $community, video: $video)';
  }

  @override
  bool operator ==(covariant PostData other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
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
