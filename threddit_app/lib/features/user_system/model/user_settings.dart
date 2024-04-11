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
    // Check if the top-level 'settings' key exists
    if (json['data'] == null) {
      throw Exception('Missing "data" key in JSON response');
    }

    final data = json['data'] as Map<String, dynamic>;

    // Check for nested 'settings' key
    if (data['settings'] == null) {
      throw Exception('Missing "settings" key in JSON response');
    }

    final settings = data['settings'] as Map<String, dynamic>;
    return UserSettings(
      userProfile: UserProfile.fromJson(settings['userProfile']),
      safetyAndPrivacy: SafetyAndPrivacy.fromJson(settings['safetyAndPrivacy']),
      feedSettings: FeedSettings.fromJson(settings['feedSettings']),
      id: settings['_id'] as String, // Ensure id is a String
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
  final List<String> socialLinks; // Specify String type

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
      socialLinks:
          json['socialLinks']?.cast<String>() ?? [], // Cast to String list
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
