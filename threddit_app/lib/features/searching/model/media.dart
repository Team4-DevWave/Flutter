import 'package:threddit_clone/features/home_page/model/newpost_model.dart';

class Media {
  final String? id;
  final VotesList? votes;
  final int commentsCount;
  final User? userID;
  final DateTime? postedTime;
  final int numViews;
  final SubredditInfo? subredditID;
  final String? title;
  final String? type;
  final bool spoiler;
  final bool nsfw;
  final String? image;
  final String? video;
  final bool locked;
  final List<String>? mentioned;
  final bool approved;
  final String? textBody;

  Media({
    required this.id,
    required this.votes,
    required this.commentsCount,
    required this.userID,
    required this.postedTime,
    required this.numViews,
    required this.subredditID,
    required this.title,
    required this.type,
    required this.spoiler,
    required this.nsfw,
    required this.image,
    required this.video,
    required this.locked,
    required this.mentioned,
    required this.approved,
    required this.textBody,
  });
  factory Media.fromJson(Map<String, dynamic> json) {
    print(json['mentioned']); // Add this line

    return Media(
      id: json['_id'],
      votes: json['votes'] != null
          ? VotesList.fromJson(json['votes'] as Map<String, dynamic>)
          : null,
      commentsCount: json['commentsCount'],
      userID: json['userID'] != null
          ? User.fromJson(json['userID'] as Map<String, dynamic>)
          : null,
      postedTime: json['postedTime'] != null
          ? DateTime.parse(json['postedTime'])
          : DateTime.now(),
      numViews: json['numViews'],
      subredditID: json['subredditID'] != null
          ? SubredditInfo.fromJson(json['subredditID'] as Map<String, dynamic>)
          : null,
      title: json['title'],
      type: json['type'],
      spoiler: json['spoiler'],
      nsfw: json['nsfw'],
      image: json['image'],
      video: json['video'],
      locked: json['locked'],
      mentioned: json['mentioned'] != null
          ? List<String>.from(json['mentioned'])
          : null,
      approved: json['approved'],
      textBody: json['textBody'],
    );
  }
}
