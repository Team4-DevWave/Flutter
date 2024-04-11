class Votes {
  final List<String> votedPosts;
  final List<String> votedComments;

  Votes({
    required this.votedPosts,
    required this.votedComments,
  });

  factory Votes.fromJson(Map<String, dynamic> json) {
    return Votes(
      votedPosts: List<String>.from(json['data']['posts'] ?? []),
      votedComments: List<String>.from(json['data']['comments'] ?? []),
    );
  }
  bool containsPost(String postId) {
    return votedPosts.contains(postId);
  }

  bool containsComment(String commentId) {
    return votedComments.contains(commentId);
  }

  
}
 