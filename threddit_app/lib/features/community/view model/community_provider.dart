import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/community/model/community_repository.dart';
import 'package:threddit_clone/models/subreddit.dart';

///this class is used to provide the community repository to the widgets that need it
///the community repository is used to create a community, fetch a community and join/unsubscribe from a community
///the community repository is used to create a community by calling the createCommunity function
///the createCommunity function takes the name, nsfw and type of the community as it's parameters
/// the createCommunity function returns a Future that is used to create the community
/// the community repository is used to fetch a community by calling the fetchCommunity function
/// the fetchCommunity function takes the subreddit name as it's parameter
/// the fetchCommunity function returns a Future that is used to fetch the community
/// the community repository is used to join a community by calling the joinSubreddit function
/// the joinSubreddit function takes the subreddit name as it's parameter
/// the community repository is used to unsubscribe from a community by calling the unsubscribeFromSubreddit function
/// the unsubscribeFromSubreddit function takes the subreddit name as it's parameter


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
