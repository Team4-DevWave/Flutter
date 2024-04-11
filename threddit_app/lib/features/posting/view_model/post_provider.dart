import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/models/post.dart';

// import 'package:threddit_clone/features/posting/model/repository/post_repository.dart';
// import 'package:threddit_clone/models/votes.dart';

// import 'package:threddit_clone/features/posting/model/repository/post_repository.dart';


// final postRepositoryProvider = Provider((ref) => PostRepository());


// final getUserUpvotesProvider = FutureProvider<Votes>((ref) async {
//   final repository = ref.watch(postRepositoryProvider);
//   return repository.getUserUpvotes();
// });

// final getUserDownvotesProvider = FutureProvider<Votes>((ref) async {
//   final repository = ref.watch(postRepositoryProvider);
//   return repository.getUserDownvotes();
// });
// final fetchpostProvider =
//     FutureProvider.family<Post, String>((ref, id) async {
//   final repository = ref.watch(postRepositoryProvider);

// final postUpvoteProvider =
//     Provider.autoDispose.family<void Function(String), Post>((ref, post) {
//   final repository = ref.watch(postRepositoryProvider);
//   return (String userID) {
//     repository.upVote(post, userID);
//   };
// });

// final postDownvoteProvider =
//     Provider.autoDispose.family<void Function(String), Post>((ref, post) {
//   final repository = ref.watch(postRepositoryProvider);
//   return (String userID) {
//     repository.downVote(post, userID);
//   };
// });


//   return repository.fetchPost(id);
// });
