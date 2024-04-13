import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/user_system/model/user_settings.dart';

class UserProfileNotifier extends StateNotifier<UserProfile> {
  //link returned to null here and in reset all
  UserProfileNotifier()
      : super(UserProfile(
            displayName: "",
            about: "",
            nsfw: false,
            allowFollowers: true,
            contentVisibility: true,
            activeCommunitiesVisibility: true,
            profilePicture: "",
            socialLinks: []));
  void updateDiplayName(String disName) =>
      state = state.copyWith(displayName: disName);
  void updateAbout(String about) => state = state.copyWith(about: about);
  void updateContetnVis(bool vis) =>
      state = state.copyWith(contentVisibility: vis);
  void updateActiveCom(bool active) =>
      state = state.copyWith(activeCommunitiesVisibility: active);
  void updateProfilePic(String pic) =>
      state = state.copyWith(profilePicture: pic);
  void updateSocialLinks(List<String> social) =>
      state = state.copyWith(socialLinks: social);
  void addLink(String link) => state.socialLinks.add(link);
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>(
        (ref) => UserProfileNotifier());
