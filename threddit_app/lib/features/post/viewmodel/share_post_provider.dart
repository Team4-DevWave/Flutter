import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/model/shared_post_model.dart';

final sharedPostProvider = StateNotifierProvider<SharedNotifier, SharedPost>(
    (ref) => SharedNotifier());

class SharedNotifier extends StateNotifier<SharedPost> {
  SharedNotifier()
      : super(SharedPost(
            title: null,
            post: null,
            postIn: null,
            postInName: null,
            NSFW: false,
            spoiler: false,
            postCommentNotifications: true));

  void setToBeSharedPost(Post post) {
    state = state.copyWith(post: post);
  }

  void setPostInAndInName(String postIn, String postInName) {
    state = state.copyWith(postIn: postIn, postInName: postInName);
  }

  void setNSFW(bool nsfw, bool spoiler) {
    state = state.copyWith(NSFW: nsfw, spoiler: spoiler);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void resetShared() {
    state = SharedPost(
        post: null,
        postIn: null,
        postInName: null,
        NSFW: false,
        spoiler: false,
        postCommentNotifications: true);
  }

  String? getPostIn() {
    return state.postIn;
  }

  String? getPostInName() {
    return state.postInName;
  }

  SharedPost getShared() {
    return state;
  }
}

final popCounter = StateProvider<int>((ref) => 1);
