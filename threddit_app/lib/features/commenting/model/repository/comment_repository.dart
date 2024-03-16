import 'package:threddit_app/models/comment.dart';

import 'package:threddit_app/features/posting/data/data.dart';

class CommentRepository {
  Future<List<Comment>> fetchComments(String postId) async {
    // Simulate an asynchronous operation (e.g., fetching data from a backend)
    await Future.delayed(Duration(seconds: 1));
  List<Comment> postComments = comments
        .where((comment) => comment.postId == postId)
        .toList();
    // Return the mock comments 
    return postComments;
  }

  Future<void> addComment(String commentText,String postID,String uid) async {
    // Simulate adding a comment to a backend
    await Future.delayed(Duration(seconds: 1));

    Comment newComment = Comment(
      upvotes: [],
      downvotes: [],
      postId: postID,
      text: commentText,
      username: uid, 
      createdAt: DateTime.now(), 
    );

    comments.add(newComment);
    print(comments.where((element) => element.postId=="1"));
  }
Future<void> upVote(Comment comment, String userID) async {
    if (comment.downvotes.contains(userID)) {
      comment.downvotes.remove(userID);
    }
    if (comment.upvotes.contains(userID)) {
      comment.upvotes.remove(userID);
    } else {
      comment.upvotes.add(userID);
    }
   
  }
Future<void> downVote(Comment comment, String userID) async {
    if (comment.upvotes.contains(userID)) {
      comment.upvotes.remove(userID);
    }
    if (comment.downvotes.contains(userID)) {
      comment.downvotes.remove(userID);
    } else {
      comment.downvotes.add(userID);
    }

}
}
