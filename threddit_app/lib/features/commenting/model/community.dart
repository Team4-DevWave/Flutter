import 'package:flutter/foundation.dart';

class Community {
  final String id;
  final String name;
  final String avatar;
  final List<String> members;
  final List<String> mods;
  String? description;
  Community({
    required this.id,
    required this.name,
    required this.avatar,
    required this.members,
    required this.mods,
    this.description,
  });

  Community copyWith({
    String? id,
    String? name,
    String? banner,
    String? avatar,
    List<String>? members,
    List<String>? mods,
    String? description,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      members: members ?? this.members,
      mods: mods ?? this.mods,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'members': members,
      'mods': mods,
      'description':description,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '',
      members: List<String>.from(map['members']),
      mods: List<String>.from(map['mods']),
      description: map['description'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Community(id: $id, name: $name,  avatar: $avatar, members: $members, mods: $mods, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Community &&
        other.id == id &&
        other.name == name &&
        other.avatar == avatar &&
        listEquals(other.members, members) &&
        listEquals(other.mods, mods);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^  avatar.hashCode ^ members.hashCode ^ mods.hashCode ^ description.hashCode;
  }
}