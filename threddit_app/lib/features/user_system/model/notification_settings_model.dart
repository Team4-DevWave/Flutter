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
  });

  factory NotificationsSettingsModel.fromJson(Map<String, dynamic> json) {
    json = json['data']['notificationsSettings'];
    print(json);
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
    );
  }
}
