import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/community/model/community_repository.dart';
import 'package:threddit_clone/models/fetch_community.dart';

class CreateCommunityParams {
  final String name;
  final bool nsfw;
  final String uid;
  final String type;

  CreateCommunityParams({
    required this.name,
    required this.nsfw,
    required this.uid,
    required this.type,
  });
}

final communityRepositoryProvider = Provider((ref) => CommunityRepository());

final createCommunityProvider = FutureProvider.autoDispose
    .family<void, CreateCommunityParams>((ref, params) async {
  final repository = ref.watch(communityRepositoryProvider);
  await repository.createCommunity(
    params.name,
    params.nsfw,
    params.uid,
    params.type,
  );
});

final fetchcommunityProvider =
    FutureProvider.family<FetchCommunity, String>((ref, id) async {
  final repository = ref.watch(communityRepositoryProvider);

  return repository.fetchCommunity(id);
});

final joinCommunityProvider =
    Provider.autoDispose.family<void Function(String), String>((ref, id) {
  final repository = ref.watch(communityRepositoryProvider);
  return (String userID) {
    repository.joinCommunity(id, userID);
    
  };
});

final unjoinCommunityProvider =
    Provider.autoDispose.family<void Function(String), String>((ref, id) {
  final repository = ref.watch(communityRepositoryProvider);
  return (String userID) {
    repository.unJoinCommunity(id, userID);
  };
});
