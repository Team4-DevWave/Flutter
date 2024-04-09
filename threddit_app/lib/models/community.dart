import 'package:flutter/foundation.dart';

enum CommunityType { Restricted, Public, Private }

class Community {
  final String id;
  final String name;
  final String avatar;
  final String banner;
  final List<String> members;
  final List<String> mods;
  final String? description;
  final CommunityType type;
  final bool nsfw; // Renamed is18plus to nsfw
  final List<String> rules; // Added list of rules

  Community({
    required this.id,
    required this.name,
    this.avatar = 'https://st2.depositphotos.com/1432405/8410/v/450/depositphotos_84106432-stock-illustration-saturn-icon-simple.jpg',
    this.banner = 'https://htmlcolorcodes.com/assets/images/colors/bright-blue-color-solid-background-1920x1080.png',
    required this.members,
    required this.mods,
    this.description,
    required this.type,
    required this.nsfw,
    required this.rules, // Added rules parameter
  });

  Community copyWith({
    String? id,
    String? name,
    String? avatar,
    String? banner,
    List<String>? members,
    List<String>? mods,
    String? description,
    CommunityType? type,
    bool? nsfw,
    List<String>? rules,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      banner: banner ?? this.banner,
      members: members ?? this.members,
      mods: mods ?? this.mods,
      description: description ?? this.description,
      type: type ?? this.type,
      nsfw: nsfw ?? this.nsfw,
      rules: rules ?? this.rules,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'banner': banner,
      'members': members,
      'mods': mods,
      'description': description,
      'type': type.toString().split('.').last,
      'nsfw': nsfw,
      'rules': rules, // Added rules
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '',
      banner: map['banner'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      mods: List<String>.from(map['mods'] ?? []),
      description: map['description'],
      type: _parseCommunityType(map['type']),
      nsfw: map['nsfw'] ?? false,
      rules: List<String>.from(map['rules'] ?? []), // Added rules
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'banner': banner,
      'members': members,
      'mods': mods,
      'description': description,
      'type': type.toString().split('.').last,
      'nsfw': nsfw,
      'rules': rules, // Added rules
    };
  }

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      // avatar: json['avatar'] ?? '',
      // banner: json['banner'] ?? '',
      members: List<String>.from(json['members'] ?? []),
      mods: List<String>.from(json['mods'] ?? []),
      description: json['description'],
      type: _parseCommunityType(json['type']),
      nsfw: json['nsfw'] ?? false,
      rules: List<String>.from(json['rules'] ?? []), // Added rules
    );
  }

  @override
  String toString() {
    return 'Community(id: $id, name: $name,  avatar: $avatar, members: $members, mods: $mods, description: $description, type: $type, nsfw: $nsfw)';
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
        other.type == type &&
        other.nsfw == nsfw;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        avatar.hashCode ^
        members.hashCode ^
        mods.hashCode ^
        description.hashCode ^
        type.hashCode ^
        nsfw.hashCode;
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