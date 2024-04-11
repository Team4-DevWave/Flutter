import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/models/post.dart';
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
final fetchpostProvider =
    FutureProvider.family<Post, String>((ref, id) async {
  final repository = ref.watch(postRepositoryProvider);

  return repository.fetchPost(id);
});
