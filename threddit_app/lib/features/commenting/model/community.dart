import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum CommunityType { Restricted, Public, Private }

class Community {
  final String id;
  final String name;
  final String avatar;
  final List<String> members;
  final List<String> mods;
  final String? description;
  final CommunityType type;
  final bool is18plus;

  Community({
    required this.name,
    required this.avatar,
    required this.members,
    required this.mods,
    this.description,
    required this.type,
    required this.is18plus,
  }): id = uuid.v4();

  Community copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatar,
    List<String>? members,
    List<String>? mods,
    String? description,
    CommunityType? type,
  }) {
    return Community(
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      members: members ?? this.members,
      mods: mods ?? this.mods,
      description: description ?? this.description,
      type: type ?? this.type,
      is18plus: is18plus ?? this.is18plus,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'members': members,
      'mods': mods,
      'description': description,
      'type': type.toString().split('.').last, // Convert enum to string
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      mods: List<String>.from(map['mods'] ?? []),
      description: map['description'],
      type: _parseCommunityType(map['type']), // Parse enum from string
      is18plus: map['is18plus']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'members': members,
      'mods': mods,
      'description': description,
      'type': type.toString().split('.').last, // Convert enum to string
    };
  }

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      members: List<String>.from(json['members'] ?? []),
      mods: List<String>.from(json['mods'] ?? []),
      description: json['description'],
      type: _parseCommunityType(json['type']), // Parse enum from string
      is18plus:json['is18plus']?? '',
    );
  }

  @override
  String toString() {
    return 'Community(id: $id, name: $name,  avatar: $avatar, members: $members, mods: $mods, description: $description, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Community &&
        other.id == id &&
        other.name == name &&
        other.avatar == avatar &&
        listEquals(other.members, members) &&
        listEquals(other.mods, mods) &&
        other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        avatar.hashCode ^
        members.hashCode ^
        mods.hashCode ^
        description.hashCode ^
        type.hashCode;
  }

  static CommunityType _parseCommunityType(String? type) {
    switch (type) {
      case 'Restricted':
        return CommunityType.Restricted;
      case 'Public':
        return CommunityType.Public;
      case 'Private':
        return CommunityType.Private;
      default:
        return CommunityType.Public;
    }
  }
}
