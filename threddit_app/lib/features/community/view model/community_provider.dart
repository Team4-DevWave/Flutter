import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/models/community.dart';
import 'package:threddit_clone/features/community/model/community_repository.dart';

class CreateCommunityParams {
  final String name;
  final bool is18plus;
  final String uid;
  final CommunityType type;

  CreateCommunityParams({
    required this.name,
    required this.is18plus,
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
    params.is18plus,
    params.uid,
    params.type,
  );
});

final fetchcommunityProvider =
    FutureProvider.family<Community, String>((ref, id) async {
  final repository = ref.watch(communityRepositoryProvider);

  return repository.fetchCommunity(id);
});
