import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/models/comment.dart';
import 'package:threddit_app/features/posting/model/repository/post_repository.dart';
import 'package:threddit_app/models/post.dart';

final postRepositoryProvider = Provider((ref) => PostRepository());

final postUpvoteProvider = Provider.autoDispose.family<void Function(String), Post>((ref, post) {
  final repository = ref.watch(postRepositoryProvider);
  return (String userID) {
    repository.upVote(post, userID);
    
  };
});

final postDownvoteProvider = Provider.autoDispose.family<void Function(String), Post>((ref, post) {
  final repository = ref.watch(postRepositoryProvider);
  return (String userID) {
    repository.downVote(post, userID);
    
  };
});


