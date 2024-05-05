class NotificationsSettingsModel {
  final bool privateMessages;
  final bool chatMessages;
  final bool chatRequests;
  final bool mentionsOfUsername;
  final bool commentsOnYourPost;
  final bool upvotesOnYourPost;
  final bool upvotesOnYourComments;
  final bool newFollowers;
  final bool modNotifications;

  // Subreddit specific notification settings (complex structure)
  final Map<String, SubredditSettings> subredditsUserMods;

  NotificationsSettingsModel({
    required this.privateMessages,
    required this.chatMessages,
    required this.chatRequests,
    required this.mentionsOfUsername,
    required this.commentsOnYourPost,
    required this.upvotesOnYourPost,
    required this.upvotesOnYourComments,
    required this.newFollowers,
    required this.modNotifications,
    required this.subredditsUserMods,
  });

  factory NotificationsSettingsModel.fromJson(Map<String, dynamic> json) {
    json = json['data']['notificationsSettings'];
    return NotificationsSettingsModel(
      privateMessages: json['privateMessages'] as bool,
      chatMessages: json['chatMessages'] as bool,
      chatRequests: json['chatRequests'] as bool,
      mentionsOfUsername: json['mentionsOfUsername'] as bool,
      commentsOnYourPost: json['commentsOnYourPost'] as bool,
      upvotesOnYourPost: json['upvotesOnYourPost'] as bool,
      upvotesOnYourComments: json['upvotesOnYourComments'] as bool,
      newFollowers: json['newFollowers'] as bool,
      modNotifications: json['modNotifications'] as bool,
      subredditsUserMods: (json['subredditsUserMods'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(
                key,
                SubredditSettings.fromJson({
                  ...value,
                  'subredditName': key,
                }),
              )),
    );
  }
}

class SubredditSettings {
  final String? subredditName;
  final bool allowModNotifications;
  final Activity activity;
  final Reports reports;

  SubredditSettings({
    this.subredditName,
    required this.allowModNotifications,
    required this.activity,
    required this.reports,
  });

  factory SubredditSettings.fromJson(Map<String, dynamic> json) {
    return SubredditSettings(
      allowModNotifications: json['allowModNotifications'] as bool,
      activity: Activity.fromJson(json['activity'] as Map<String, dynamic>),
      reports: Reports.fromJson(json['reports'] as Map<String, dynamic>),
    );
  }
}

class Activity {
  final bool newPosts;
  final PostWithUpvotesActivity postsWithUpvotes;
  final PostWithCommentsActivity postsWithComments;

  Activity({
    required this.newPosts,
    required this.postsWithUpvotes,
    required this.postsWithComments,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      newPosts: json['newPosts'] as bool,
      postsWithUpvotes: PostWithUpvotesActivity.fromJson(
          json['postsWithUpvotes'] as Map<String, dynamic>),
      postsWithComments: PostWithCommentsActivity.fromJson(
          json['postsWithComments'] as Map<String, dynamic>),
    );
  }
}

class PostWithUpvotesActivity {
  final bool allowNotification;
  final bool advancedSetup;
  final int numberOfUpvotes; // Assuming upvotes is a number

  PostWithUpvotesActivity({
    required this.allowNotification,
    required this.advancedSetup,
    required this.numberOfUpvotes,
  });

  factory PostWithUpvotesActivity.fromJson(Map<String, dynamic> json) {
    return PostWithUpvotesActivity(
      allowNotification: json['allowNotification'] as bool,
      advancedSetup: json['advancedSetup'] as bool,
      numberOfUpvotes: json['numberOfUpvotes'] as int,
    );
  }
}
class PostWithCommentsActivity {
  final bool allowNotification;
  final bool advancedSetup;
  final int numberOfComments;// Assuming upvotes is a number

  PostWithCommentsActivity({
    required this.allowNotification,
    required this.advancedSetup,
    required this.numberOfComments,
  });

  factory PostWithCommentsActivity.fromJson(Map<String, dynamic> json) {
    return PostWithCommentsActivity(
      allowNotification: json['allowNotification'] as bool,
      advancedSetup: json['advancedSetup'] as bool,
      numberOfComments: json['numberOfComments'] as int,
    );
  }
}
class Reports {
  final Report posts;
  final Report comments;

  Reports({
    required this.posts,
    required this.comments,
  });

  factory Reports.fromJson(Map<String, dynamic> json) {
    return Reports(
      posts: Report.fromJson(json['posts'] as Map<String, dynamic>),
      comments: Report.fromJson(json['comments'] as Map<String, dynamic>),
    );
  }
}

class Report {
  final bool allowNotification;
  final bool advancedSetup;
  final int numberOfReports;

  Report({
    required this.allowNotification,
    required this.advancedSetup,
    required this.numberOfReports,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      allowNotification: json['allowNotification'] as bool,
      advancedSetup: json['advancedSetup'] as bool,
      numberOfReports: json['numberOfReports'] as int,
    );
  }
}
