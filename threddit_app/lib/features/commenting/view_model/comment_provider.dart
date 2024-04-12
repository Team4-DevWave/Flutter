import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/commenting/model/comment_repository.dart';
import 'package:threddit_clone/models/comment.dart';

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
