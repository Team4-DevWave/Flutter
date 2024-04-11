class Subreddit {
  final String id;
  final String name;
  String? description;
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
  int version;

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
      moderators: List<String>.from(json['moderators']),
      members: List<String>.from(json['members']),
      status: json['status'],
      srSettings: SubredditSettings.fromJson(json['srSettings']),
      srLooks: SubredditLooks.fromJson(json['srLooks']),
      userManagement: SubredditUserManagement.fromJson(json['userManagement']),
      postsToBeApproved: List<dynamic>.from(json['postsToBeApproved']),
      posts: List<dynamic>.from(json['posts']),
      rules: List<dynamic>.from(json['rules']),
      invitedUsers: List<dynamic>.from(json['invitedUsers']),
      version: json['__v'],
      description: json['description'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'moderators': moderators,
      'members': members,
      'status': status,
      'srSettings': srSettings.toJson(),
      'srLooks': srLooks.toJson(),
      'userManagement': userManagement.toJson(),
      'postsToBeApproved': postsToBeApproved,
      'posts': posts,
      'rules': rules,
      'invitedUsers': invitedUsers,
      '__v': version,
      'description': description,
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }
}

class SubredditLooks {
   String? banner;
   String? icon;
  String? color;
  bool darkMode;

  SubredditLooks({
    this.banner="https://htmlcolorcodes.com/assets/images/colors/bright-blue-color-solid-background-1920x1080.png",
    this.icon="https://st2.depositphotos.com/1432405/8410/v/450/depositphotos_84106432-stock-illustration-saturn-icon-simple.jpg",
    this.color,
    required this.darkMode,
  });

  factory SubredditLooks.fromJson(Map<String, dynamic> json) {
    return SubredditLooks(
      banner: json['banner'],
      icon: json['icon'],
      color: json['color'],
      darkMode: json['darkMode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'banner': banner,
      'icon': icon,
      'color': color,
      'darkMode': darkMode,
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
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
      spamFilterStrength: Map<String, String>.from(json['spamFilterStrength']),
      srType: json['srType'],
      nsfw: json['nsfw'],
      postType: json['postType'],
      allowCrossPosting: json['allowCrossPosting'],
      archivePosts: json['archivePosts'],
      enableSpoilerTag: json['enableSpoilerTag'],
      allowImages: json['allowImages'],
      allowMultipleImages: json['allowMultipleImages'],
      allowPolls: json['allowPolls'],
      postReviewing: json['postReviewing'],
      collapseDeletedRemovedComments: json['collapseDeletedRemovedComments'],
      welcomeMessageEnabled: json['welcomeMessageEnabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spamFilterStrength': spamFilterStrength,
      'srType': srType,
      'nsfw': nsfw,
      'postType': postType,
      'allowCrossPosting': allowCrossPosting,
      'archivePosts': archivePosts,
      'enableSpoilerTag': enableSpoilerTag,
      'allowImages': allowImages,
      'allowMultipleImages': allowMultipleImages,
      'allowPolls': allowPolls,
      'postReviewing': postReviewing,
      'collapseDeletedRemovedComments': collapseDeletedRemovedComments,
      'welcomeMessageEnabled': welcomeMessageEnabled,
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
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
      banList: List<dynamic>.from(json['banList']),
      mutedList: List<dynamic>.from(json['mutedList']),
      approvedList: List<dynamic>.from(json['approvedList']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'banList': banList,
      'mutedList': mutedList,
      'approvedList': approvedList,
    };
  }

  Map<String, dynamic> toMap() {
    return toJson();
  }
}
