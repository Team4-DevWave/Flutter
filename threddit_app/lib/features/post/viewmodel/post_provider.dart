import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';

class PostNotifier extends StateNotifier<PostData> {
  //link returned to null here and in reset all
  PostNotifier()
      : super(PostData(
            title: "",
            text_body: "",
            url: null,
            community: null,
            NSFW: false,
            spoiler: false,
            type: "",
            locked: false));

  void updateTitle(String newTitle) => state = state.copyWith(title: newTitle);

  void updateNFSW(bool nsfw) => state = state.copyWith(NSFW: nsfw);

  void updateIsSpoiler(bool spoiler) =>
      state = state.copyWith(spoiler: spoiler);

  void updateImagePath(File imgePath) =>
      state = state.copyWith(imagePath: imgePath);
  void updateVideoPath(File videoPath) =>
      state = state.copyWith(videoPath: videoPath);

  void updateImages(String newImage) => state = state.copyWith(image: newImage);

  void updateBodyText(String newBody) =>
      state = state.copyWith(text_body: newBody);

  void updateLink(String newLink) => state = state.copyWith(url: newLink);

  void updateCommunityName(String newCommunity) =>
      state = state.copyWith(community: newCommunity);

  void updateType(String type) => state = state.copyWith(type: type);

  void updateVideo(String newVideo) => state = state.copyWith(video: newVideo);

  void removeLink() => state = state.copyWith(url: null);

  void removeImages() => state = state.copyWith(image: null);

  void removeBody() => state = state.copyWith(text_body: "");

  void removeVideo() => state = state.copyWith(video: null);

  void resetSpoilerAndNFSW() =>
      state = state.copyWith(NSFW: false, spoiler: false);

  void resetAll() {
    state = PostData(
        title: "",
        image: null,
        video: null,
        text_body: "",
        url: null,
        community: null,
        NSFW: false,
        spoiler: false,
        type: "",
        locked: false);
  }
}

final postDataProvider =
    StateNotifierProvider<PostNotifier, PostData?>((ref) => PostNotifier());

final validLink = StateProvider<bool>((ref) => false);
