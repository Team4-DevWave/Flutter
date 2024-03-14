

class Comment {
  final String id;
  final String content;
  final String username; // Ensure that this property is declared
  final DateTime date;
  final List<String> upvotes = [];
  final List<String> downvotes = [];
  final int replyCount = 0;

  Comment({
    required this.id,
    required this.content,
    required this.username, // Make sure to include this property
    required this.date,
  });

  
  
}
