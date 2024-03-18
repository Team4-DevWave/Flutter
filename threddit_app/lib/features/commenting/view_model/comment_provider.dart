import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/features/commenting/model/comment.dart';
import 'package:threddit_app/features/commenting/model/comment_repository.dart';

final commentRepositoryProvider = Provider((ref) => CommentRepository());

final commentsProvider = FutureProvider.autoDispose
    .family<List<Comment>, String>((ref, postId) async {
  final repository = ref.watch(commentRepositoryProvider);
  return repository.fetchComments(postId);
});

final addCommentProvider =
    FutureProvider.autoDispose.family<void, List<String>>((
  ref,
  data,
) async {
  final repository = ref.watch(commentRepositoryProvider);
  await repository.addComment(
      data[0],
      data[1],
      data[
          2]); //the give list should include 3 values: the comment text, the post ID, the userID
});

final commentUpvoteProvider =
    Provider.autoDispose.family<void Function(String), Comment>((ref, comment) {
  final repository = ref.watch(commentRepositoryProvider);
  return (String userID) {
    repository.upVote(comment, userID);
  };
});

final commentDownvoteProvider =
    Provider.autoDispose.family<void Function(String), Comment>((ref, comment) {
  final repository = ref.watch(commentRepositoryProvider);
  return (String userID) {
    repository.downVote(comment, userID);
  };
});
