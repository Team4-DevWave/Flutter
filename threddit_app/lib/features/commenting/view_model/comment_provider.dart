import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/commenting/model/comment_repository.dart';
import 'package:threddit_clone/models/comment.dart';

///this class is used to provide the comment repository to the widgets that need it
///the comment repository is used to fetch all the comments of a post, create a comment, vote on a comment, edit a comment and delete a comment
///the comment repository is used to fetch all the comments of a post by calling the fetchAllComments function
///the fetchAllComments function takes the post ID as it's parameter
///the fetchAllComments function returns a stream of comments
///the comment repository is used to create a comment by calling the createComment function
///the createComment function takes the post ID, the content of the comment and the user ID as it's parameters
///the createComment function returns a Future that is used to add the comment to the post
///the comment repository is used to vote on a comment by calling the voteComment function
///the voteComment function takes the comment ID and the vote type as it's parameters
///the voteComment function returns a Future that is used to vote on the comment
///the comment repository is used to edit a comment by calling the editComment function
///the editComment function takes the comment ID and the new content as it's parameters

final commentRepositoryProvider = Provider((ref) => CommentRepository());

final commentsProvider =
    StreamProvider.family<List<Comment>, String>((ref, postId) {
  final repository = ref.watch(commentRepositoryProvider);
  return repository.getCommentsStream(postId);
});
typedef parameters = ({String postId, String content, String uid});
final addCommentProvider = FutureProvider.autoDispose.family<void, parameters>((
  ref,
  arguments,
) async {
  final repository = ref.watch(commentRepositoryProvider);
  repository.createComment(arguments.postId, arguments.content);
});

typedef votingParameters = ({String commentID, int voteType});
final commentVoteProvider = FutureProvider.autoDispose
    .family<void, votingParameters>((ref, arguments) async {
  final repository = ref.watch(commentRepositoryProvider);
  repository.voteComment(arguments.commentID, arguments.voteType);
});
typedef editParameters = ({String commentId, String newContent});
final editCommentProvider =
    FutureProvider.autoDispose.family<void, editParameters>((
  ref,
  arguments,
) async {
  final repository = ref.watch(commentRepositoryProvider);
  repository.editComment(arguments.commentId, arguments.newContent);
});

typedef deleteParameters = ({String postId, String commentId});
final deleteCommentProvider =
    FutureProvider.autoDispose.family<void, deleteParameters>((
  ref,
  arguments,
) async {
  final repository = ref.watch(commentRepositoryProvider);
  repository.deleteComment(arguments.postId, arguments.commentId);
});
