// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommunityTypesModel {
  int? restriction;
  bool? isAdult;
  CommunityTypesModel({
    this.restriction,
    this.isAdult,
  });

  CommunityTypesModel copyWith({
    int? restriction,
    bool? isAdult,
  }) {
    return CommunityTypesModel(
      restriction: restriction ?? this.restriction,
      isAdult: isAdult ?? this.isAdult,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '-NwubXKo-QzNyJj67QUX': {
        'restriction': restriction,
        'isAdult': isAdult,
      }
    };
  }

  factory CommunityTypesModel.fromMap(Map<String, dynamic> map) {
    return CommunityTypesModel(
      restriction:
          map['restriction'] != null ? map['restriction'] as int : null,
      isAdult: map['isAdult'] != null ? map['isAdult'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommunityTypesModel.fromJson(String source) =>
      CommunityTypesModel.fromMap(
          json.decode(source)["-NwubXKo-QzNyJj67QUX"] as Map<String, dynamic>);

  @override
  String toString() =>
      'CommunityTypesModel(restriction: $restriction, isAdult: $isAdult)';

  @override
  bool operator ==(covariant CommunityTypesModel other) {
    if (identical(this, other)) return true;

    return other.restriction == restriction && other.isAdult == isAdult;
  }

  @override
  int get hashCode => restriction.hashCode ^ isAdult.hashCode;
}
