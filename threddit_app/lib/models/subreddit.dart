class Subreddit {
  final String id;
  final String name;
  final List<String> moderators;
  final List<String> members;
  final String status;
  final SubredditSettings srSettings;
  final SubredditLooks srLooks;
  final SubredditUserManagement userManagement;
  final List<dynamic> postsToBeApproved;
  final List<dynamic> posts;
  final List<dynamic> rules;
  final List<dynamic> invitedUsers;
  final int version;
  String? description;

  Subreddit({
    required this.id,
    required this.name,
    required this.moderators,
    required this.members,
    required this.status,
    required this.srSettings,
    required this.srLooks,
    required this.userManagement,
    required this.postsToBeApproved,
    required this.posts,
    required this.rules,
    required this.invitedUsers,
    required this.version,
    this.description,
  });

  factory Subreddit.fromJson(Map<String, dynamic> json) {
    return Subreddit(
      id: json['_id'],
      name: json['name'],
      moderators: List<String>.from(json['moderators'] ?? []),
      members: List<String>.from(json['members'] ?? []),
      status: json['status'] ?? "",
      srSettings: SubredditSettings.fromJson(json['srSettings'] ?? {}),
      srLooks: SubredditLooks.fromJson(json['srLooks'] ?? {}),
      userManagement: SubredditUserManagement.fromJson(json['userManagement'] ?? {}),
      postsToBeApproved: List<dynamic>.from(json['postsToBeApproved'] ?? []),
      posts: List<dynamic>.from(json['posts'] ?? []),
      rules: List<dynamic>.from(json['rules'] ?? []),
      invitedUsers: List<dynamic>.from(json['invitedUsers'] ?? []),
      version: json['__v'] ?? 0,
      description: json['description'],
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
      spamFilterStrength: Map<String, String>.from(json['spamFilterStrength'] ?? {}),
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
      collapseDeletedRemovedComments: json['collapseDeletedRemovedComments'] ?? false,
      welcomeMessageEnabled: json['welcomeMessageEnabled'] ?? false,
    );
  }
}

class SubredditLooks {
   String? banner;
  String? icon;
   String? color;
   bool darkMode;

  SubredditLooks({
    this.banner,
    this.icon,
    this.color,
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
