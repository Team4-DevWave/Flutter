import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';

import 'package:threddit_clone/features/posting/model/repository/post_repository.dart';
import 'package:threddit_clone/models/votes.dart';

/// This provider is used to provide the post repository to the widgets that need it
/// The post repository is used to fetch the user's upvotes and downvotes
/// The user's upvotes and downvotes are fetched by calling the getUserUpvotes and getUserDownvotes functions
/// The getUserUpvotes function returns a Future that is used to get the user's upvotes
/// The getUserDownvotes function returns a Future that is used to get the user's downvotes
/// The post repository is used to fetch a post by it's ID
/// The fetchPost function takes the post ID as it's parameter
/// The fetchPost function returns a Future that is used to get the post
/// The post repository is used to toggle the NSFW status of a post
/// The togglePostNSFW function takes the post ID as it's parameter
/// The togglePostNSFW function returns a Future that is used to toggle the NSFW status of the post
/// The post repository is used to toggle the spoiler status of a post
/// The togglePostSpoiler function takes the post ID as it's parameter
/// The togglePostSpoiler function returns a Future that is used to toggle the spoiler status of the post

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