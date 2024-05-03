import 'dart:convert';

class UserModel {
  final String id;
  final String username;

  UserModel({required this.id, required this.username});
   @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.id == id;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      username: json['username'],
    );
  }
}

class Subreddit {
  final String id;
  final String name;
  final List<UserModel> moderators;
  final List<UserModel> members;
  final String status;
  final SubredditSettings srSettings;
  final SubredditLooks srLooks;
  final SubredditUserManagement userManagement;
  final List<dynamic> rules;
  final List<dynamic> invitedUsers;
  final int version;

  Subreddit({
    required this.id,
    required this.name,
    required this.moderators,
    required this.members,
    required this.status,
    required this.srSettings,
    required this.srLooks,
    required this.userManagement,
    required this.rules,
    required this.invitedUsers,
    required this.version,
  });

  factory Subreddit.fromJson(Map<String, dynamic> json) {
    return Subreddit(
      id: json['_id'],
      name: json['name'],
      moderators: List<UserModel>.from(
          json['moderators'].map((i) => UserModel.fromJson(i)).toList()),
      members: List<UserModel>.from(
          json['members'].map((i) => UserModel.fromJson(i)).toList()),
      status: json['status'] ?? "",
      srSettings: SubredditSettings.fromJson(json['srSettings'] ?? {}),
      srLooks: SubredditLooks.fromJson(json['srLooks'] ?? {}),
      userManagement:
          SubredditUserManagement.fromJson(json['userManagement'] ?? {}),
      rules: List<dynamic>.from(json['rules'] ?? []),
      invitedUsers: List<dynamic>.from(json['invitedUsers'] ?? []),
      version: json['__v'] ?? 0,
    );
  }
}

class SubredditSettings {
  final Map<String, String> spamFilterStrength;
  final String srType;
  final bool nsfw;
  final String postType;
  final bool allowCrossPosting;
  final bool archivePosts;
  final bool enableSpoilerTag;
  final bool allowImages;
  final bool allowMultipleImages;
  final bool allowPolls;
  final bool postReviewing;
  final bool collapseDeletedRemovedComments;
  final bool welcomeMessageEnabled;

  SubredditSettings({
    required this.spamFilterStrength,
    required this.srType,
    required this.nsfw,
    required this.postType,
    required this.allowCrossPosting,
    required this.archivePosts,
    required this.enableSpoilerTag,
    required this.allowImages,
    required this.allowMultipleImages,
    required this.allowPolls,
    required this.postReviewing,
    required this.collapseDeletedRemovedComments,
    required this.welcomeMessageEnabled,
  });

  factory SubredditSettings.fromJson(Map<String, dynamic> json) {
    return SubredditSettings(
      spamFilterStrength:
          Map<String, String>.from(json['spamFilterStrength'] ?? {}),
      srType: json['srType'] ?? "",
      nsfw: json['nsfw'] ?? false,
      postType: json['postType'] ?? "",
      allowCrossPosting: json['allowCrossPosting'] ?? false,
      archivePosts: json['archivePosts'] ?? false,
      enableSpoilerTag: json['enableSpoilerTag'] ?? false,
      allowImages: json['allowImages'] ?? false,
      allowMultipleImages: json['allowMultipleImages'] ?? false,
      allowPolls: json['allowPolls'] ?? false,
      postReviewing: json['postReviewing'] ?? false,
      collapseDeletedRemovedComments:
          json['collapseDeletedRemovedComments'] ?? false,
      welcomeMessageEnabled: json['welcomeMessageEnabled'] ?? false,
    );
  }
}

class SubredditLooks {
  String banner;
  String icon;
  String color;
  bool darkMode;

  SubredditLooks({
    required this.banner,
    required this.icon,
    required this.color,
    required this.darkMode,
  });

  factory SubredditLooks.fromJson(Map<String, dynamic> json) {
    return SubredditLooks(
      banner: json['banner'],
      icon: json['icon'],
      color: json['color'],
      darkMode: json['darkMode'] ?? false,
    );
  }
}

class SubredditUserManagement {
  final List<dynamic> banList;
  final List<dynamic> mutedList;
  final List<dynamic> approvedList;

  SubredditUserManagement({
    required this.banList,
    required this.mutedList,
    required this.approvedList,
  });

  factory SubredditUserManagement.fromJson(Map<String, dynamic> json) {
    return SubredditUserManagement(
      banList: List<dynamic>.from(json['banList'] ?? []),
      mutedList: List<dynamic>.from(json['mutedList'] ?? []),
      approvedList: List<dynamic>.from(json['approvedList'] ?? []),
    );
  }
}

class SubredditList {
  final List<Subreddit> subreddits;

  SubredditList({required this.subreddits});

  factory SubredditList.fromJson(List<dynamic> json) {
    List<Subreddit> subreddits =
        json.map((i) => Subreddit.fromJson(i)).toList();

    return SubredditList(
      subreddits: subreddits,
    );
  }
}

SubredditList decodeSubredditList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return SubredditList.fromJson(parsed);
}
