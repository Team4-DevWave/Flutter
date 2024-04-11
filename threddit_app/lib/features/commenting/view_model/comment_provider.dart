import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/commenting/model/comment_repository.dart';
import 'package:threddit_clone/models/comment.dart';


final commentRepositoryProvider = Provider((ref) => CommentRepository());

typedef Parameters= ({String postID, String uid,List<String> commentIds});
final commentsProvider = StreamProvider.family<List<Comment>, Parameters>((ref, arguments) {
final repository = ref.watch(commentRepositoryProvider);
return repository.getCommentsStream(arguments.commentIds, arguments.postID,arguments.uid );
});
typedef parameters=({String postId,String content,String uid});
final addCommentProvider =
    FutureProvider.autoDispose.family<void, parameters>((ref,arguments,) async {
  final repository = ref.watch(commentRepositoryProvider);
  repository.addComment(arguments.postId,arguments.content,arguments.uid); 
});

typedef votingParameters=({String commentID,int voteType,String uid});
final commentVoteProvider =
    FutureProvider.autoDispose.family<void, votingParameters>((ref, arguments) async {
  final repository = ref.watch(commentRepositoryProvider);
  repository.voteComment(arguments.commentID,arguments.voteType,arguments.uid);
});
typedef editParameters=({String postId,String commentId,String newContent,String uid});
final editCommentProvider=FutureProvider.autoDispose.family<void, editParameters>((ref,arguments,) async {
  final repository = ref.watch(commentRepositoryProvider);
  repository.editComment(arguments.postId, arguments.commentId, arguments.newContent, arguments.uid); 
});

typedef deleteParameters=({String postId, String commentId,String uid});
final deleteCommentProvider=FutureProvider.autoDispose.family<void, deleteParameters>((ref,arguments,) async {
  final repository = ref.watch(commentRepositoryProvider);
  repository.deleteComment(arguments.postId, arguments.commentId, arguments.uid); 
});

