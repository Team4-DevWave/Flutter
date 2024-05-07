import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/model/shared_post_model.dart';

/// A provider responsible for managing the shared post data.
final sharedPostProvider = StateNotifierProvider<SharedNotifier, SharedPost>(
    (ref) => SharedNotifier());

/// A notifier for managing the shared post data.
///
/// This class handles the management of data related to a post
/// that is intended to be shared. It provides methods for setting
/// various attributes of the shared post and resetting the shared
/// post data when necessary.
class SharedNotifier extends StateNotifier<SharedPost> {
  SharedNotifier()
      : super(SharedPost(
          title: null,
          post: null,
          destination: null,
          postIn: null,
          postInName: null,
          nsfw: false,
          spoiler: false,
        ));

  /// Sets the post to be shared.
  void setToBeSharedPost(Post post) {
    state = state.copyWith(post: post);
  }

  /// Sets the destination for sharing the post.
  void setDestination(String destination) {
    state = state.copyWith(destination: destination);
  }

  /// Sets the NSFW and spoiler attributes of the shared post.
  void setNSFW(bool nsfw, bool spoiler) {
    state = state.copyWith(nsfw: nsfw, spoiler: spoiler);
  }

  /// Sets the title of the shared post.
  void setTitle(String title) {
    state = state.copyWith(title: title);
  }
}

/// A provider for managing the counter for pop navigation events.
final popCounter = StateProvider<int>((ref) => 1);

/// A provider for managing the flag indicating the first time entering a screen.
final isFirstTimeEnter = StateProvider<bool>((ref) => true);

/// A provider for managing the flag indicating if there are changes in data.
final isChanged = StateProvider<bool>((ref) => false);

final shareProfilePic = StateProvider<String>((ref) => "");
