// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

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
  final File? imagePath;
  final List<List<String>> socialLinks;

  UserProfile({
    required this.displayName,
    required this.about,
    required this.nsfw,
    required this.allowFollowers,
    required this.contentVisibility,
    required this.activeCommunitiesVisibility,
    required this.profilePicture,
    this.imagePath,
    required this.socialLinks,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawSocialLinks = json['socialLinks'] ?? [];
    final List<List<String>> socialLinks = rawSocialLinks.map((socialLink) {
      final Map<String, dynamic> linkData = socialLink as Map<String, dynamic>;
      final List<String> linkDetails = [
        linkData['socialType'] ?? '',
        linkData['username'] ?? '',
      ];
      if (linkData['url'] != null) {
        linkDetails.add(linkData['url']);
      }
      return linkDetails;
    }).toList();
    return UserProfile(
      displayName: json['displayName'] ?? '',
      about: json['about'] ?? '',
      nsfw: json['NSFW'] ?? false,
      allowFollowers: json['allowFollowers'] ?? true,
      contentVisibility: json['contentVisibility'] ?? true,
      activeCommunitiesVisibility: json['activeCommunitiesVisibility'] ?? true,
      profilePicture: json['profilePicture'] ?? '',
      socialLinks: socialLinks,
    );
  }

  UserProfile copyWith({
    String? displayName,
    String? about,
    bool? nsfw,
    bool? allowFollowers,
    bool? contentVisibility,
    bool? activeCommunitiesVisibility,
    String? profilePicture,
    File? imagePath,
    List<List<String>>? socialLinks,
  }) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      about: about ?? this.about,
      nsfw: nsfw ?? this.nsfw,
      allowFollowers: allowFollowers ?? this.allowFollowers,
      contentVisibility: contentVisibility ?? this.contentVisibility,
      activeCommunitiesVisibility:
          activeCommunitiesVisibility ?? this.activeCommunitiesVisibility,
      profilePicture: profilePicture ?? this.profilePicture,
      socialLinks: socialLinks ?? this.socialLinks,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userProfile': {
        if (displayName.isNotEmpty) 'displayName': displayName,
        if (about.isNotEmpty) 'about': about,
        'nsfw': nsfw,
        'allowFollowers': allowFollowers,
        'contentVisibility': contentVisibility,
        'activeCommunitiesVisibility': activeCommunitiesVisibility,
        if (profilePicture.isNotEmpty) 'profilePicture': profilePicture,
      }
    };
  }
    String toJson() => json.encode(toMap());

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
