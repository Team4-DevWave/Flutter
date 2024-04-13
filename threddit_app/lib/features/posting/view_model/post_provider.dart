import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';

import 'package:threddit_clone/features/posting/model/repository/post_repository.dart';
import 'package:threddit_clone/models/votes.dart';

final postRepositoryProvider = Provider((ref) => PostRepository());

final getUserUpvotesProvider = FutureProvider<Votes>((ref) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getUserUpvotes();
});

final getUserDownvotesProvider = FutureProvider<Votes>((ref) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getUserDownvotes();
});
final fetchpostProvider = FutureProvider.family<Post, String>((ref, id) async {
  final repository = ref.watch(postRepositoryProvider);

  return repository.fetchPost(id);
});

final toggleNSFW = FutureProvider.autoDispose.family<void, String>((ref, postId,) async {
  final repository = ref.watch(postRepositoryProvider);
  repository.togglePostNSFW(postId);
});
final toggleSpoiler = FutureProvider.autoDispose.family<void, String>((ref, postId,) async {
  final repository = ref.watch(postRepositoryProvider);
  repository.togglePostSpoiler(postId);
});