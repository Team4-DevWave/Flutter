import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/community/model/community_repository.dart';
import 'package:threddit_clone/models/subreddit.dart';

class CreateCommunityParams {
  final String name;
  final bool nsfw;
  final String type;

  CreateCommunityParams({
    required this.name,
    required this.nsfw,
    required this.type,
  });
}

final communityRepositoryProvider = Provider((ref) => CommunityRepository());

final createCommunityProvider = FutureProvider.autoDispose
    .family<int, CreateCommunityParams>((ref, params) async {
  final repository = ref.watch(communityRepositoryProvider);
  int status= await repository.createCommunity(
    params.name,
    params.nsfw,
    params.type,
  );
  return status;
});

final fetchcommunityProvider =
    FutureProvider.family<Subreddit, String>((ref, id) async {
  final repository = ref.watch(communityRepositoryProvider);

  return repository.fetchCommunity(id);
});

final joinCommunityProvider =
    Provider.autoDispose.family<void , String>((ref, name) {
  final repository = ref.watch(communityRepositoryProvider);
    repository.joinSubreddit(name);
});

final unjoinCommunityProvider =
    Provider.autoDispose.family<void, String>((ref, name) {
  final repository = ref.watch(communityRepositoryProvider);
    repository.unsubscribeFromSubreddit(name);
  
});
