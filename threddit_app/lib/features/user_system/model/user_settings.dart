class UserSettings {
  final UserProfile userProfile;
  final SafetyAndPrivacy safetyAndPrivacy;
  final FeedSettings feedSettings;
  final String id;

  UserSettings({
    required this.userProfile,
    required this.safetyAndPrivacy,
    required this.feedSettings,
    required this.id,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userProfile: UserProfile.fromJson(json['userProfile']),
      safetyAndPrivacy: SafetyAndPrivacy.fromJson(json['safetyAndPrivacy']),
      feedSettings: FeedSettings.fromJson(json['feedSettings']),
      id: json['_id'],
    );
  }
}

class UserProfile {
  final String displayName;
  final String about;
  final bool nsfw;
  final bool allowFollowers;
  final bool contentVisibility;
  final bool activeCommunitiesVisibility;
  final String profilePicture;
  final List<dynamic> socialLinks;

  UserProfile({
    required this.displayName,
    required this.about,
    required this.nsfw,
    required this.allowFollowers,
    required this.contentVisibility,
    required this.activeCommunitiesVisibility,
    required this.profilePicture,
    required this.socialLinks,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      displayName: json['displayName'] ?? '',
      about: json['about'] ?? '',
      nsfw: json['NSFW'] ?? false,
      allowFollowers: json['allowFollowers'] ?? true,
      contentVisibility: json['contentVisibility'] ?? true,
      activeCommunitiesVisibility: json['activeCommunitiesVisibility'] ?? true,
      profilePicture: json['profilePicture'] ?? '',
      socialLinks: json['socialLinks'] ?? [],
    );
  }
}

class SafetyAndPrivacy {
  final List<dynamic> blockedPeople;
  final List<dynamic> blockedCommunities;

  SafetyAndPrivacy({
    required this.blockedPeople,
    required this.blockedCommunities,
  });

  factory SafetyAndPrivacy.fromJson(Map<String, dynamic> json) {
    return SafetyAndPrivacy(
      blockedPeople: json['blockedPeople'] ?? [],
      blockedCommunities: json['blockedCommunities'] ?? [],
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
