import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';

class PostNotifier extends StateNotifier<PostData> {
  //link returned to null here and in reset all
  PostNotifier() : super(PostData(title: "", link: "", isNSFW: false, isSpoiler: false));

  void updateTitle(String newTitle) => state = state.copyWith(title: newTitle);

  void updateIsNsfw(bool nfsw) => state = state.copyWith(isNSFW: nfsw);

  void updateIsSpoiler(bool spoiler) =>
      state = state.copyWith(isSpoiler: spoiler);

  void updateImages(List<XFile> newImages) =>
      state = state.copyWith(images: newImages);

  void updateBodyText(String newBody) =>
      state = state.copyWith(postBody: newBody);

  void updateLink(String newLink) => state = state.copyWith(link: newLink);

  void updateCommunityName(String newCommunity) =>
      state = state.copyWith(community: newCommunity);

  void updateVideo(XFile newVideo) => state = state.copyWith(video: newVideo);

  void removeLink() =>
    state = state.copyWith(link: '');

  void removeImages() => state = state.copyWith(images: null);

  void removeBody() => state = state.copyWith(postBody: null);

  void removeVideo() => state = state.copyWith(video: null);

  void resetSpoilerAndNFSW() =>
      state = state.copyWith(isNSFW: false, isSpoiler: false);

  void resetAll() {
    state = PostData(title: "",link: "", isNSFW: false, isSpoiler: false);
  }
}

final postDataProvider =
    StateNotifierProvider<PostNotifier, PostData?>((ref) => PostNotifier());

final validLink = StateProvider<bool>((ref) => false);
