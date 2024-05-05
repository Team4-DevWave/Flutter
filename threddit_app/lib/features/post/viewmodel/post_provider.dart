import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/post/model/post_model.dart';

/// A state notifier responsible for managing the creation of posts.
///
/// This class provides methods to update various attributes of a post,
/// such as title, body text, images, links, community, and post type.
///
/// It also allows for the removal of specific attributes and resetting
/// all fields to their default values.
class PostNotifier extends StateNotifier<PostData> {
  /// Constructs a new [PostNotifier] instance.
  ///
  /// Initializes a new post data object with default values.
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

  /// Updates the title of the post.
  void updateTitle(String newTitle) => state = state.copyWith(title: newTitle);

  /// Updates the NSFW flag of the post.
  void updateNFSW(bool nsfw) => state = state.copyWith(NSFW: nsfw);

  /// Updates the spoiler flag of the post.
  void updateIsSpoiler(bool spoiler) =>
      state = state.copyWith(spoiler: spoiler);

  /// Updates the image path of the post.
  void updateImagePath(File imgePath) =>
      state = state.copyWith(imagePath: imgePath);

  /// Updates the video path of the post.
  void updateVideoPath(File videoPath) =>
      state = state.copyWith(videoPath: videoPath);

  /// Updates the images of the post.
  void updateImages(String newImage) => state = state.copyWith(image: newImage);

  /// Updates the body text of the post.
  void updateBodyText(String newBody) =>
      state = state.copyWith(text_body: newBody);

  /// Updates the link of the post.
  void updateLink(String newLink) => state = state.copyWith(url: newLink);

  /// Updates the community name of the post.
  void updateCommunityName(String newCommunity) =>
      state = state.copyWith(community: newCommunity);

  /// Updates the type of the post.
  void updateType(String type) => state = state.copyWith(type: type);

  /// Updates the video of the post.
  void updateVideo(String newVideo) => state = state.copyWith(video: newVideo);

  void removeLink() => state = state.copyWith(url: null);

  /// Removes the images from the post.
  void removeImages() => state = state.copyWith(image: null);

  /// Removes the body text from the post.
  void removeBody() => state = state.copyWith(text_body: "");

  /// Removes the video from the post.
  void removeVideo() => state = state.copyWith(video: null);

  /// Resets the spoiler and NSFW flags of the post.
  void resetSpoilerAndNFSW() =>
      state = state.copyWith(NSFW: false, spoiler: false);

  /// Resets all fields of the post.
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

/// A provider responsible for managing the state of the post data during post creation.
///
/// This provider holds a [PostNotifier] instance to manage the state of the post data.
final postDataProvider =
    StateNotifierProvider<PostNotifier, PostData?>((ref) => PostNotifier());

/// A provider responsible for managing the validity of the link in the post data.
///
/// This provider holds a boolean value to track the validity of the link in the post data.
final validLink = StateProvider<bool>((ref) => false);
