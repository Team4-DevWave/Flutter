// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';

///This model class holds the Post data
class PostData {

  final String title;
  final String? postBody;
  final String? link;
  final bool isNSFW;
  final bool isSpoiler; 
  final List<XFile>? images;
  final String?community;
  final XFile?video;
  PostData({
    required this.title,
    this.postBody,
    this.link,
    required this.isNSFW,
    required this.isSpoiler,
    this.images,
    this.community,
    this.video,
  });

  PostData copyWith({
    String? title,
    String? postBody,
    String? link,
    bool? isNSFW,
    bool? isSpoiler,
    List<XFile>? images,
    String? community,
    XFile? video,
  }) {
    return PostData(
      title: title ?? this.title,
      postBody: postBody ?? this.postBody,
      link: link ?? this.link,
      isNSFW: isNSFW ?? this.isNSFW,
      isSpoiler: isSpoiler ?? this.isSpoiler,
      images: images ?? this.images,
      community: community ?? this.community,
      video: video ?? this.video,
    );
  }


// Map<String, dynamic> xFileToMap(XFile file) {
//   return {
//     'path': file.path,
//   };
// }

// XFile mapToXFile(Map<String, dynamic> map) {
//   return XFile(map['path']);
// }


//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'title': title,
//       'postBody': postBody,
//       'link': link,
//       'isNSFW': isNSFW,
//       'isSpoiler': isSpoiler,
//       'images': images?.asMap()
//         .map((index, img) => MapEntry('image$index', img.path))
//         .values.toList(),
//     };
//   }

//   factory PostData.fromMap(Map<String, dynamic> map) {
//     return PostData(
//       title: map['title'] as String,
//       postBody: map['postBody'] != null ? map['postBody'] as String : null,
//       link: map['link'] != null ? map['link'] as String : null,
//       isNSFW: map['isNSFW'] as bool,
//       isSpoiler: map['isSpoiler'] as bool,
//       images: map['images'] != null
//     ? List<XFile>.from((map['images'] as List<dynamic>)
//         .map((x) => mapToXFile(x as Map<String, dynamic>))
//         .toList())
//     : null,
//     );
//   }

  // String toJson() => json.encode(toMap());

  // factory PostData.fromJson(String source) => PostData.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // String toString() {
  //   return 'PostData(title: $title, postBody: $postBody, link: $link, isNSFW: $isNSFW, isSpoiler: $isSpoiler, images: $images)';
  // }

  @override
  bool operator ==(covariant PostData other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.title == title &&
      other.postBody == postBody &&
      other.link == link &&
      other.isNSFW == isNSFW &&
      other.isSpoiler == isSpoiler &&
      listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return title.hashCode ^
      postBody.hashCode ^
      link.hashCode ^
      isNSFW.hashCode ^
      isSpoiler.hashCode ^
      images.hashCode;
  }
}



