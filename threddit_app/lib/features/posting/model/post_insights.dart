

// Data model for post insights
class PostInsights {
  final String postID;
  final int numViews;
  final double upvotesRate;
  final int numComments;
  final int numShares;

  PostInsights({
    required this.postID,
    required this.numViews,
    required this.upvotesRate,
    required this.numComments,
    required this.numShares,
  });

  factory PostInsights.fromJson(Map<String, dynamic> json) {
    return PostInsights(
      postID: json['postID'],
      numViews: json['numViews'],
      upvotesRate: json['upvotesRate'].toDouble(),
      numComments: json['numComments'],
      numShares: json['numShares'],
    );
  }
}

