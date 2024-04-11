class UserModelMe {
  final String? id;
  final String? username;
  final String? email;
  final bool? verified;
  final String? verificationToken;
  final DateTime? dateJoined;
  final String? country;
  final String? gender;
  final List<String>? interests;
  final List<String>? followedUsers;
  final List<BlockedUsers>? blockedUsers; // Adjusted type here
  final List<String>? joinedSubreddits;
  final List<String>? followedPosts;
  final List<String>? viewedPosts;
  final List<String>? hiddenPosts;
  final List<String>? comments;
  final List<String>? posts;
  final Karma? karma;

  UserModelMe({
    this.id,
    this.username,
    this.email,
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
    this.comments,
    this.posts,
    this.karma,
  });

  factory UserModelMe.fromJson(Map<String, dynamic> json) {
    final user = json['data']['user'] as Map<String, dynamic>?;

    if (user == null) return UserModelMe(); // Handle null user data
    return UserModelMe(
      id: user['_id'] as String?,
      username: user['username'] as String?,
      email: user['email'] as String?,
      verified: user['verified'] as bool?,
      verificationToken: user['verificationToken'] as String?,
      dateJoined: user['dateJoined'] != null
          ? DateTime.parse(user['dateJoined'] as String)
          : null,
      country: user['country'] as String?,
      gender: user['gender'] as String?,
      interests: user['interests']?.cast<String>(),
      followedUsers: user['followedUsers']?.cast<String>(),
      blockedUsers: (user['blockedUsers'] as List<dynamic>?)?.map((blockedUser) =>
          BlockedUsers.fromJson(blockedUser as Map<String, dynamic>)).toList(),
      joinedSubreddits: user['joinedSubreddits']?.cast<String>(),
      followedPosts: user['followedPosts']?.cast<String>(),
      viewedPosts: user['viewedPosts']?.cast<String>(),
      hiddenPosts: user['hiddenPosts']?.cast<String>(),
      comments: user['comments']?.cast<String>(),
      posts: user['posts']?.cast<String>(),
      karma: user['karma'] != null
          ? Karma.fromJson(user['karma'] as Map<String, dynamic>)
          : null,
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

class BlockedUsers {
  final String id; // Adjusted to non-nullable
  final String username; // Adjusted to non-nullable

  BlockedUsers({required this.id, required this.username});

  factory BlockedUsers.fromJson(Map<String, dynamic> json) {
    return BlockedUsers(
      id: json['_id'] as String,
      username: json['username'] as String,
    );
  }
}
