import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/model/user_settings.dart';

// Define the main user data model
class UserModelNotMe {
  /// The URL of the user's profile picture.
  final String? profilePicture;

  /// The display name of the user.
  final String? displayName;

  /// The upvotes received by the user.
  final Votes? upvotes;

  /// The downvotes received by the user.
  final Votes? downvotes;

  /// The karma of the user.
  final Karma? karma;

  /// The unique identifier of the user.
  final String? id;

  /// The username of the user.
  final String? username;

  /// The email address of the user.
  final String? email;

  /// The date when the user joined the platform.
  final DateTime? dateJoined;

  /// The country of the user.
  final String? country;

  /// The list of subreddits the user has joined.
  final List<dynamic>? joinedSubreddits;

  /// The list of posts made by the user.
  final List<dynamic>? posts;

  /// The user's profile settings.
  final UserProfile? userProfileSettings;

  /// The user's safety and privacy settings.
  final SafetyAndPrivacy? safetyAndPrivacySettings;

  /// The user's feed settings.
  final FeedSettings? feedSettings;

  /// Constructs a [UserModelNotMe] instance with the specified parameters.
  ///
  /// [profilePicture] represents the URL of the user's profile picture. It defaults to `null`.
  ///
  /// [displayName] represents the display name of the user. It defaults to `null`.
  ///
  /// [upvotes] represents the upvotes received by the user. It defaults to `null`.
  ///
  /// [downvotes] represents the downvotes received by the user. It defaults to `null`.
  ///
  /// [karma] represents the karma of the user. It defaults to `null`.
  ///
  /// [id] represents the unique identifier of the user. It defaults to `null`.
  ///
  /// [username] represents the username of the user. It defaults to `null`.
  ///
  /// [email] represents the email address of the user. It defaults to `null`.
  ///
  /// [dateJoined] represents the date when the user joined the platform. It defaults to `null`.
  ///
  /// [country] represents the country of the user. It defaults to `null`.
  ///
  /// [joinedSubreddits] represents the list of subreddits the user has joined. It defaults to `null`.
  ///
  /// [posts] represents the list of posts made by the user. It defaults to `null`.
  ///
  /// [userProfileSettings] represents the user's profile settings. It defaults to `null`.
  ///
  /// [safetyAndPrivacySettings] represents the user's safety and privacy settings. It defaults to `null`.
  ///
  /// [feedSettings] represents the user's feed settings. It defaults to `null`.
  UserModelNotMe({
    this.profilePicture,
    this.displayName,
    this.upvotes,
    this.downvotes,
    this.karma,
    this.id,
    this.username,
    this.email,
    this.dateJoined,
    this.country,
    this.joinedSubreddits,
    this.posts,
    //this.settings,
    this.userProfileSettings,
    this.safetyAndPrivacySettings,
    this.feedSettings,
  });

  /// Factory method to create a [UserModelNotMe] instance from JSON data.
  ///
  /// The [json] parameter should contain the user data in JSON format.
  ///
  /// Returns a [UserModelNotMe] instance constructed from the provided JSON data.
  factory UserModelNotMe.fromJson(Map<String, dynamic> json) {
    final userData = json['data']['user'];
    return UserModelNotMe(
      profilePicture: userData['profilePicture'],
      displayName: userData['displayName'],
      upvotes: Votes.fromJson(userData['upvotes']),
      downvotes: Votes.fromJson(userData['downvotes']),
      karma: Karma.fromJson(userData['karma']),
      id: userData['_id'],
      username: userData['username'],
      email: userData['email'],
      dateJoined: DateTime.parse(userData['dateJoined']),
      country: userData['country'],
      joinedSubreddits: List<dynamic>.from(userData['joinedSubreddits']),
      posts: List<dynamic>.from(userData['posts']),
      //settings: userData['settings'] as UserSettings,
      userProfileSettings:
          UserProfile.fromJson(userData['settings']['userProfile']),
    );
  }
}
