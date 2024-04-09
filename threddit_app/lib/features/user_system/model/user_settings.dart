class UserSettings {
  final String displayName;
  final String about;
  final bool nsfw;
  final bool allowFollowers;
  final bool contentVisibility;
  final bool activeCommunitiesVisibility;
  final String profilePicture;
  final List<String> socialLinks;

  final SafetyAndPrivacy safetyAndPrivacy;

  UserSettings({
    required this.displayName,
    required this.about,
    required this.nsfw,
    required this.allowFollowers,
    required this.contentVisibility,
    required this.activeCommunitiesVisibility,
    required this.profilePicture,
    required this.socialLinks,
    required this.safetyAndPrivacy,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      displayName: json['settings']['userProfile']['displayName'] ?? '',
      about: json['settings']['userProfile']['about'] ?? '',
      nsfw: json['settings']['userProfile']['NSFW'] ?? false,
      allowFollowers: json['settings']['userProfile']['allowFollowers'] ?? true,
      contentVisibility: json['settings']['userProfile']['contentVisibility'] ?? true,
      activeCommunitiesVisibility: json['settings']['userProfile']['activeCommunitiesVisibility'] ?? true,
      profilePicture: json['settings']['userProfile']['profilePicture'] ?? '',
      socialLinks: List<String>.from(json['settings']['userProfile']['socialLinks'] ?? []),
      safetyAndPrivacy: SafetyAndPrivacy.fromJson(json['settings']['safetyAndPrivacy']),
    );
  }
}

class SafetyAndPrivacy {
  final List<String> blockedPeople;
  final List<String> blockedCommunities;

  SafetyAndPrivacy({
    required this.blockedPeople,
    required this.blockedCommunities,
  });

  factory SafetyAndPrivacy.fromJson(Map<String, dynamic> json) {
    return SafetyAndPrivacy(
      blockedPeople: List<String>.from(json['blockedPeople'] ?? []),
      blockedCommunities: List<String>.from(json['blockedCommunities'] ?? []),
    );
  }
}