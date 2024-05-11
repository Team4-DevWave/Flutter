/// model for the User received with any chat response 

class UserProfile {
  final String about;
  final bool nsfw;
  final bool allowFollowers;
  final bool contentVisibility;
  final bool activeCommunitiesVisibility;
  final List<SocialLink> socialLinks;

  UserProfile({
    required this.about,
    required this.nsfw,
    required this.allowFollowers,
    required this.contentVisibility,
    required this.activeCommunitiesVisibility,
    required this.socialLinks,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      about: json['about'] ?? '',
      nsfw: json['NSFW'] ?? false,
      allowFollowers: json['allowFollowers'] ?? true,
      contentVisibility: json['contentVisibility'] ?? true,
      activeCommunitiesVisibility: json['activeCommunitiesVisibility'] ?? true,
      socialLinks: (json['socialLinks'] as List<dynamic>?)
              ?.map((link) => SocialLink.fromJson(link))
              .toList() ??
          [],
    );
  }
}

class SocialLink {
  final String socialType;
  final String url;
  final String username;

  SocialLink({
    required this.socialType,
    required this.url,
    required this.username,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      socialType: json['socialType'] ?? '',
      url: json['url'] ?? '',
      username: json['username'] ?? '',
    );
  }
}

class SafetyAndPrivacy {
  final List<String> blockedCommunities;

  SafetyAndPrivacy({
    required this.blockedCommunities,
  });

  factory SafetyAndPrivacy.fromJson(Map<String, dynamic> json) {
    return SafetyAndPrivacy(
      blockedCommunities: List<String>.from(json['blockedCommunities'] ?? []),
    );
  }
}

class FeedSettings {
  final bool matureContent;
  final bool autoplayMedia;
  final bool communityThemes;
  final String communityContentSort;
  final String globalContentView;
  final bool openPostInNewTab;

  FeedSettings({
    required this.matureContent,
    required this.autoplayMedia,
    required this.communityThemes,
    required this.communityContentSort,
    required this.globalContentView,
    required this.openPostInNewTab,
  });

  factory FeedSettings.fromJson(Map<String, dynamic> json) {
    return FeedSettings(
      matureContent: json['matureContent'] ?? false,
      autoplayMedia: json['autoplayMedia'] ?? true,
      communityThemes: json['communityThemes'] ?? true,
      communityContentSort: json['communityContentSort'] ?? 'hot',
      globalContentView: json['globalContentView'] ?? 'card',
      openPostInNewTab: json['openPostInNewTab'] ?? false,
    );
  }
}

class UserSettings {
  final UserProfile userProfile;
  final SafetyAndPrivacy safetyAndPrivacy;
  final FeedSettings feedSettings;

  UserSettings({
    required this.userProfile,
    required this.safetyAndPrivacy,
    required this.feedSettings,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userProfile: UserProfile.fromJson(json['userProfile'] ?? {}),
      safetyAndPrivacy: SafetyAndPrivacy.fromJson(json['safetyAndPrivacy'] ?? {}),
      feedSettings: FeedSettings.fromJson(json['feedSettings'] ?? {}),
    );
  }
}

class User {
  final String profilePicture;
  final String displayName;
  final SavedPostsAndComments savedPostsAndComments;
  final UpvotesDownvotes upvotes;
  final UpvotesDownvotes downvotes;
  final Karma karma;
  final List<String> disabledSubredditNotifications;
  final int notificationCount;
  final String id;
  final String username;
  final String email;
  final bool verified;
  final String verificationToken;
  final String dateJoined;
  final String country;
  final String gender;
  final List<String> interests;
  final List<FollowedUser> followedUsers;
  final List<BlockedUser> blockedUsers;
  final List<String> joinedSubreddits;
  final List<String> followedPosts;
  final List<String> viewedPosts;
  final List<String> hiddenPosts;
  final List<String> posts;
  final int v;
  final UserSettings settings;

  User({
    required this.profilePicture,
    required this.displayName,
    required this.savedPostsAndComments,
    required this.upvotes,
    required this.downvotes,
    required this.karma,
    required this.disabledSubredditNotifications,
    required this.notificationCount,
    required this.id,
    required this.username,
    required this.email,
    required this.verified,
    required this.verificationToken,
    required this.dateJoined,
    required this.country,
    required this.gender,
    required this.interests,
    required this.followedUsers,
    required this.blockedUsers,
    required this.joinedSubreddits,
    required this.followedPosts,
    required this.viewedPosts,
    required this.hiddenPosts,
    required this.posts,
    required this.v,
    required this.settings,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      profilePicture: json['profilePicture'] ?? '',
      displayName: json['displayName'] ?? '',
      savedPostsAndComments: SavedPostsAndComments.fromJson(json['savedPostsAndComments'] ?? {}),
      upvotes: UpvotesDownvotes.fromJson(json['upvotes'] ?? {}),
      downvotes: UpvotesDownvotes.fromJson(json['downvotes'] ?? {}),
      karma: Karma.fromJson(json['karma'] ?? {}),
      disabledSubredditNotifications: List<String>.from(json['disabledSubredditNotifications'] ?? []),
      notificationCount: json['notificationCount'] ?? 0,
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      verified: json['verified'] ?? false,
      verificationToken: json['verificationToken'] ?? '',
      dateJoined: json['dateJoined'] ?? '',
      country: json['country'] ?? '',
      gender: json['gender'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
      followedUsers: (json['followedUsers'] as List<dynamic>?)
              ?.map((user) => FollowedUser.fromJson(user))
              .toList() ??
          [],
      blockedUsers: (json['blockedUsers'] as List<dynamic>?)
              ?.map((user) => BlockedUser.fromJson(user))
              .toList() ??
          [],
      joinedSubreddits: List<String>.from(json['joinedSubreddits'] ?? []),
      followedPosts: List<String>.from(json['followedPosts'] ?? []),
      viewedPosts: List<String>.from(json['viewedPosts'] ?? []),
      hiddenPosts: List<String>.from(json['hiddenPosts'] ?? []),
      posts: List<String>.from(json['posts'] ?? []),
      v: json['__v'] ?? 0,
      settings: UserSettings.fromJson(json['settings'] ?? {}),
    );
  }
}

class SavedPostsAndComments {
  final List<String> comments;
  final List<String> posts;

  SavedPostsAndComments({
    required this.comments,
    required this.posts,
  });

  factory SavedPostsAndComments.fromJson(Map<String, dynamic> json) {
    return SavedPostsAndComments(
      comments: List<String>.from(json['comments'] ?? []),
      posts: List<String>.from(json['posts'] ?? []),
    );
  }
}

class UpvotesDownvotes {
  final List<String> comments;
  final List<String> posts;

  UpvotesDownvotes({
    required this.comments,
    required this.posts,
  });

  factory UpvotesDownvotes.fromJson(Map<String, dynamic> json) {
    return UpvotesDownvotes(
      comments: List<String>.from(json['comments'] ?? []),
      posts: List<String>.from(json['posts'] ?? []),
    );
  }
}

class Karma {
  final int comments;
  final int posts;

  Karma({
    required this.comments,
    required this.posts,
  });

  factory Karma.fromJson(Map<String, dynamic> json) {
    return Karma(
      comments: json['comments'] ?? 0,
      posts: json['posts'] ?? 0,
    );
  }
}

class FollowedUser {
  final String id;
  final String username;

  FollowedUser({
    required this.id,
    required this.username,
  });

  factory FollowedUser.fromJson(Map<String, dynamic> json) {
    return FollowedUser(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
    );
  }
}

class BlockedUser {
  final String id;
  final String username;

  BlockedUser({
    required this.id,
    required this.username,
  });

  factory BlockedUser.fromJson(Map<String, dynamic> json) {
    return BlockedUser(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
    );
  }
}
