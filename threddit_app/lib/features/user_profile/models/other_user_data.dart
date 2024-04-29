import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/model/user_settings.dart';


// Define the main user data model
class UserModelNotMe {
  final String? profilePicture;
  final String? displayName;
  final Votes? upvotes;
  final Votes? downvotes;
  final Karma? karma;
  final String? id;
  final String? username;
  final String? email;
  final DateTime? dateJoined;
  final String? country;
  final List<dynamic>? joinedSubreddits;
  final List<dynamic>? posts;
  //final UserSettings? settings;
  final UserProfile? userProfileSettings;
  final SafetyAndPrivacy? safetyAndPrivacySettings;
  final FeedSettings? feedSettings;

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
