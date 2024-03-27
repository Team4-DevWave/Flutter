import 'package:threddit_clone/features/commenting/model/post.dart';

class PostRepository {
  Future<void> upVote(Post post, String userID) async {
    if (post.downvotes.contains(userID)) {
      post.downvotes.remove(userID);
    }
    if (post.upvotes.contains(userID)) {
      post.upvotes.remove(userID);
    } else {
      post.upvotes.add(userID);
    }
  }

  Future<void> downVote(Post post, String userID) async {
    if (post.upvotes.contains(userID)) {
      post.upvotes.remove(userID);
    }
    if (post.downvotes.contains(userID)) {
      post.downvotes.remove(userID);
    } else {
      post.downvotes.add(userID);
    }
  }
}
