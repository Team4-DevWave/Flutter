// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

///This provider is user for making applying the right state managment for the user data
///where it will hold the all the user data fetched
final userModelProvider = StateProvider<UserModelMe?>(
  (ref) => UserModelMe(),
);

///The class of [UserModelMe] is a data model class that holds all the parameteres of the user
///fetched from the backend and could be used to fill all the user depend on screen and widgets
///such as the user profile data, feed and making app functionalites
class UserModelMe {
  final String? id;
  final String? username;
  final String? displayName;
  //final String? profilePicture;
  final String? email;
  final bool? verified;
  final String? verificationToken;
  final DateTime? dateJoined;
  final String? country;
  final String? gender;
  final List<String>? interests;
  final List<Map<String, dynamic>>? followedUsers;
  final List<BlockedUsers>? blockedUsers;
  final List<String>? joinedSubreddits;
  final List<String>? followedPosts;
  final List<String>? viewedPosts;
  final List<String>? hiddenPosts;
  final List<String>? posts;
  final Karma? karma;
  final SavedPostsAndComments? savedPostsAndComments;
  final Votes? upvotes;
  final Votes? downvotes;
  final String? settings;

  UserModelMe({
    this.id,
    this.username,
    this.email,
    //this.profilePicture,
    this.displayName,
    this.verified,
    this.verificationToken,
    this.dateJoined,
    this.country,
    this.gender,
    this.interests,
    this.followedUsers,
    this.blockedUsers,
    this.joinedSubreddits,
    this.followedPosts,
    this.viewedPosts,
    this.hiddenPosts,
    this.posts,
    this.karma,
    this.savedPostsAndComments,
    this.upvotes,
    this.downvotes,
    this.settings,
  });

  factory UserModelMe.fromJson(Map<String, dynamic> json) {
    final user = json['data']['user'] as Map<String, dynamic>?;

    if (user == null) return UserModelMe(); // Handle null user data
    return UserModelMe(
      id: user['_id'] as String?,
      username: user['username'] as String?,
      email: user['email'] as String?,
      verified: user['verified'] as bool?,
      displayName: user['displayName'] as String?,
      //profilePicture: user['profilePicture'] as String,
      verificationToken: user['verificationToken'] as String?,
      dateJoined: user['dateJoined'] != null
          ? DateTime.parse(user['dateJoined'] as String)
          : null,
      country: user['country'] as String?,
      gender: user['gender'] as String?,
      interests: (user['interests'] as List<dynamic>?)
          ?.map((interest) => interest as String)
          .toList(),
      followedUsers: (user['followedUsers'] as List<dynamic>?)
          ?.map<Map<String, dynamic>>((followedUser) => {
                '_id': followedUser['_id'] as String?,
                'username': followedUser['username'] as String?,
              })
          .toList(),
      blockedUsers: (user['blockedUsers'] as List<dynamic>?)
          ?.map((blockedUser) =>
              BlockedUsers.fromJson(blockedUser as Map<String, dynamic>))
          .toList(),
      joinedSubreddits: (user['joinedSubreddits'] as List<dynamic>?)
          ?.map((subreddit) => subreddit as String)
          .toList(),
      followedPosts: (user['followedPosts'] as List<dynamic>?)
          ?.map((post) => post as String)
          .toList(),
      viewedPosts: (user['viewedPosts'] as List<dynamic>?)
          ?.map((post) => post as String)
          .toList(),
      hiddenPosts: (user['hiddenPosts'] as List<dynamic>?)
          ?.map((post) => post as String)
          .toList(),
      posts: (user['posts'] as List<dynamic>?)
          ?.map((post) => post as String)
          .toList(),
      karma: Karma.fromJson(user['karma'] as Map<String, dynamic>),
      savedPostsAndComments: SavedPostsAndComments.fromJson(
          user['savedPostsAndComments'] as Map<String, dynamic>),
      upvotes: Votes.fromJson(user['upvotes'] as Map<String, dynamic>),
      downvotes: Votes.fromJson(user['downvotes'] as Map<String, dynamic>),
      settings: user['settings'] as String?,
    );
  }

  UserModelMe copyWith({
    String? id,
    String? username,
    String? displayName,
    String? email,
    bool? verified,
    String? verificationToken,
    DateTime? dateJoined,
    String? country,
    String? gender,
    List<String>? interests,
    List<Map<String, dynamic>>? followedUsers,
    List<BlockedUsers>? blockedUsers,
    List<String>? joinedSubreddits,
    List<String>? followedPosts,
    List<String>? viewedPosts,
    List<String>? hiddenPosts,
    List<String>? posts,
    Karma? karma,
    SavedPostsAndComments? savedPostsAndComments,
    Votes? upvotes,
    Votes? downvotes,
    String? settings,
  }) {
    return UserModelMe(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      verified: verified ?? this.verified,
      verificationToken: verificationToken ?? this.verificationToken,
      dateJoined: dateJoined ?? this.dateJoined,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      interests: interests ?? this.interests,
      followedUsers: followedUsers ?? this.followedUsers,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      joinedSubreddits: joinedSubreddits ?? this.joinedSubreddits,
      followedPosts: followedPosts ?? this.followedPosts,
      viewedPosts: viewedPosts ?? this.viewedPosts,
      hiddenPosts: hiddenPosts ?? this.hiddenPosts,
      posts: posts ?? this.posts,
      karma: karma ?? this.karma,
      savedPostsAndComments:
          savedPostsAndComments ?? this.savedPostsAndComments,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      settings: settings ?? this.settings,
    );
  }

  factory UserModelMe.fromJsonSearch(Map<String, dynamic> json) {
    if (json == null) return UserModelMe(); // Handle null user data
    return UserModelMe(
      id: json['_id'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      verified: json['verified'] as bool?,
      verificationToken: json['verificationToken'] as String?,
      dateJoined: json['dateJoined'] != null
          ? DateTime.parse(json['dateJoined'] as String)
          : null,
      country: json['country'] as String?,
      gender: json['gender'] as String?,
      interests: (json['interests'] as List<dynamic>?)
          ?.map((interest) => interest as String)
          .toList(),
      // followedUsers: (json['followedUsers'] as List<dynamic>?)
      //     ?.map((e) => e as String)
      //     .toList(),
      joinedSubreddits: (json['joinedSubreddits'] as List<dynamic>?)
          ?.map((subreddit) => subreddit as String)
          .toList(),
      followedPosts: (json['followedPosts'] as List<dynamic>?)
          ?.map((post) => post as String)
          .toList(),
      viewedPosts: (json['viewedPosts'] as List<dynamic>?)
          ?.map((post) => post as String)
          .toList(),
      hiddenPosts: (json['hiddenPosts'] as List<dynamic>?)
          ?.map((post) => post as String)
          .toList(),
      posts: (json['posts'] as List<dynamic>?)
          ?.map((post) => post as String)
          .toList(),
      karma: Karma.fromJson(json['karma'] as Map<String, dynamic>),
      savedPostsAndComments: SavedPostsAndComments.fromJson(
          json['savedPostsAndComments'] as Map<String, dynamic>),
      upvotes: Votes.fromJson(json['upvotes'] as Map<String, dynamic>),
      downvotes: Votes.fromJson(json['downvotes'] as Map<String, dynamic>),
      settings: json['settings'] as String?,
    );
  }
}

class Karma {
  final int comments;
  final int posts;

  Karma({required this.comments, required this.posts});

  factory Karma.fromJson(Map<String, dynamic> json) {
    return Karma(
      comments: json['comments'] as int,
      posts: json['posts'] as int,
    );
  }
}

class SavedPostsAndComments {
  final List<String> comments;
  final List<String> posts;

  SavedPostsAndComments({required this.comments, required this.posts});

  factory SavedPostsAndComments.fromJson(Map<String, dynamic> json) {
    return SavedPostsAndComments(
      comments: (json['comments'] as List<dynamic>)
          .map((comment) => comment as String)
          .toList(),
      posts: (json['posts'] as List<dynamic>)
          .map((post) => post as String)
          .toList(),
    );
  }
}

class Votes {
  final List<String> comments;
  final List<String> posts;

  Votes({required this.comments, required this.posts});

  factory Votes.fromJson(Map<String, dynamic> json) {
    return Votes(
      comments: (json['comments'] as List<dynamic>)
          .map((comment) => comment as String)
          .toList(),
      posts: (json['posts'] as List<dynamic>)
          .map((post) => post as String)
          .toList(),
    );
  }
}

class BlockedUsers {
  final String id;
  final String username;

  BlockedUsers({required this.id, required this.username});

  factory BlockedUsers.fromJson(Map<String, dynamic> json) {
    return BlockedUsers(
      id: json['_id'] as String,
      username: json['username'] as String,
    );
  }
}
