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
          destination: null,
          postIn: null,
          postInName: null,
          nsfw: false,
          spoiler: false,
        ));

  void setToBeSharedPost(Post post) {
    state = state.copyWith(post: post);
  }

  void setPostInAndInName(String postIn, String postInName) {
    state = state.copyWith(postIn: postIn, postInName: postInName);
  }

  void setDestination(String destination) {
    state = state.copyWith(destination: destination);
  }

  void setNSFW(bool nsfw, bool spoiler) {
    state = state.copyWith(nsfw: nsfw, spoiler: spoiler);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void resetShared() {
    state = SharedPost(
      post: null,
      title: '',
      destination: null,
      postIn: null,
      postInName: null,
      nsfw: false,
      spoiler: false,
    );
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
final isFirstTimeEnter = StateProvider<bool>((ref) => true);
final isChanged = StateProvider<bool>((ref) => false);
