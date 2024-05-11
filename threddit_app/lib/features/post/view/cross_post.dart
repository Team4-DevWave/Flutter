import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/post/view/rules_screen.dart';
import 'package:threddit_clone/features/post/view/widgets/classic_post_card.dart';
import 'package:threddit_clone/features/post/view/widgets/onexit_share.dart';
import 'package:threddit_clone/features/post/viewmodel/delete_post.dart';
import 'package:threddit_clone/features/post/viewmodel/share_post.dart';
import 'package:threddit_clone/features/post/viewmodel/share_post_provider.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

/// The [CrossPost] widget allows users to cross-post an existing post to other communities.
///
/// Users can select a community to cross-post to, and optionally mark the post as NSFW or a spoiler.
///
/// The [CrossPost] widget relies on the [sharedPostProvider] for managing the post being cross-posted, and
/// the [sharePostsProvider] for handling the cross-posting action.
class CrossPost extends ConsumerStatefulWidget {
  const CrossPost({super.key});

  @override
  ConsumerState<CrossPost> createState() => _CrossPostState();
}

class _CrossPostState extends ConsumerState<CrossPost> {
  /// The current title value for the post being shared.
  String lastValue = '';

  /// The destination where the post is being shared, defaults to 'My Profile'.
  String? postingIn;

  /// Flag to control visibility of NSFW and Spoiler options.
  bool isOn = false;

  /// Flag to mark a post as NSFW.
  bool isNSFW = false;

  /// Flag to mark a post as spoiler.
  bool isSpoiler = false;

  /// Flag to indicate if the post is not being shared to the user's own profile.
  bool isNotProfile = true;

  /// Flag to indicate if a loading indicator should be displayed.
  bool _isLoading = false;

  /// Flag to indicate if the current form input is valid for submission.
  bool _isValid = true;

  /// Updates the validity of the form based on the title input.
  void _updateFormValidity() {
    setState(() {
      _isValid = lastValue.trim().isNotEmpty;
    });
  }

  /// Navigates back to the previous screens and resets navigation-related states.
  void onExit() {
    for (int i = 0; i <= ref.watch(popCounter); i++) {
      Navigator.pop(context);
    }
    ref.read(isFirstTimeEnter.notifier).update((state) => true);
    ref.read(popCounter.notifier).update((state) => state = 1);
  }

  void onIsOn() {
    setState(() {
      isOn = !isOn;
    });
  }

  void onIsNSFW() {
    setState(() {
      isNSFW = !isNSFW;
    });
  }

  void onIsSpoiler() {
    setState(() {
      isSpoiler = !isSpoiler;
    });
  }

  void openRulesOverlay() {
    final shared = ref.read(sharedPostProvider);
    showModalBottomSheet(
      backgroundColor: AppColors.backgroundColor,
      context: context,
      builder: (ctx) {
        return RulesPage(
          communityName: shared.destination!,
        );
      },
    );
  }

  Future<void> onPost() async {
    ref.read(sharedPostProvider.notifier).setNSFW(isNSFW, isSpoiler);
    ref.read(sharedPostProvider.notifier).setTitle(lastValue);
    final shared = ref.read(sharedPostProvider);
    final message =
        shared.destination == '' ? 'your profile' : shared.destination;

    //send shared post to backend and recieve the responsed from the provider
    //to show user a message
    final response = await ref.read(sharePostsProvider.notifier).sharePost();
    response.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (post) {
      showSnackBar(
          navigatorKey.currentContext!, 'Your post shared to $message');
      ref.read(deletePostScreen.notifier).update((state) => true);
      Navigator.pushNamed(context, RouteClass.postScreen, arguments: {
        'currentpost': post,
        'uid': ref.read(userModelProvider)?.id
      }).then((value) {
        ref.read(deletePostScreen.notifier).update((state) => false);
        onExit();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    lastValue = ref.read(sharedPostProvider).post?.title ?? "";

    _isLoading = ref.watch(sharePostsProvider);
    ref.read(sharedPostProvider).destination == ''
        ? postingIn = 'My Profile'
        : postingIn = ref.read(sharedPostProvider).destination;

    isNotProfile = (ref.read(sharedPostProvider).destination != '');

    return _isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              leading: const ExitShare(),
              backgroundColor: AppColors.backgroundColor,
              title: Text(
                'Crosspost',
                style:
                    AppTextStyles.primaryTextStyle.copyWith(fontSize: 24.spMin),
              ),
              actions: [
                TextButton(
                  onPressed: _isValid ? onPost : null,
                  child: Text(
                    'Post',
                    style: AppTextStyles.primaryTextStyle.copyWith(
                        fontSize: 20.spMin,
                        color: _isValid
                            ? AppColors.blueColor
                            : AppColors.whiteHideColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            body: Container(
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.h),
              height: MediaQuery.of(context).size.height.h,
              width: MediaQuery.of(context).size.width.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () {
                      ref
                          .read(popCounter.notifier)
                          .update((state) => state = state + 1);
                      Navigator.pushNamed(context, RouteClass.chooseCommunity);
                    },
                    leading: ref.read(shareProfilePic) == ""
                        ? CircleAvatar(
                            radius: 15.r,
                            backgroundImage: AssetImage(
                                postingIn == "My Profile"
                                    ? Photos.profileDefault
                                    : Photos.communityDefault))
                        : CircleAvatar(
                            radius: 15.r,
                            backgroundImage:
                                NetworkImage(ref.read(shareProfilePic))),
                    title: Row(
                      children: [
                        Text(
                          postingIn!,
                          style: AppTextStyles.primaryTextStyle.copyWith(
                            fontSize: 20.spMin,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 38.spMin,
                        ),
                      ],
                    ),
                    trailing: isNotProfile
                        ? TextButton(
                            onPressed: () {
                              openRulesOverlay();
                            },
                            child: Text(
                              'Rules',
                              style: AppTextStyles.primaryTextStyle.copyWith(
                                  fontSize: 17.spMin,
                                  color: AppColors.blueColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    onChanged: (value) {
                      ref
                          .read(isFirstTimeEnter.notifier)
                          .update((state) => false);
                      ref.read(sharedPostProvider.notifier).setTitle(value);

                      lastValue = value;
                      _updateFormValidity();
                    },
                    initialValue: ref.read(isFirstTimeEnter)
                        ? lastValue =
                            ref.read(sharedPostProvider).post?.title ?? ""
                        : lastValue = ref.read(sharedPostProvider).title ?? "",
                    style: AppTextStyles.primaryTextStyle
                        .copyWith(fontSize: 20.spMin),
                    decoration: InputDecoration(
                      hintText: 'An interesting title',
                      hintStyle: AppTextStyles.primaryTextStyle
                          .copyWith(fontSize: 20.spMin),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.whiteHideColor,
                        ),
                      ),
                    ),
                    cursorColor: AppColors.blueColor,
                  ),
                  SizedBox(height: 30.h),
                  PostClassic(post: ref.read(sharedPostProvider).post!),
                ],
              ),
            ),
            bottomSheet: Container(
              color: AppColors.backgroundColor,
              child: Row(
                children: [
                  IconButton(
                    onPressed: onIsOn,
                    icon: const Icon(Icons.more_vert),
                  ),
                  isOn
                      ? Row(
                          children: [
                            ElevatedButton(
                              onPressed: onIsNSFW,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isNSFW
                                    ? AppColors.redColor
                                    : AppColors.backgroundColor,
                                side: BorderSide(
                                  color: AppColors.whiteColor,
                                  width: 2.0.spMin,
                                ),
                              ),
                              child: Text(
                                'NSFW',
                                style: AppTextStyles.primaryTextStyle.copyWith(
                                    color: isNSFW
                                        ? AppColors.backgroundColor
                                        : AppColors.whiteColor),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            ElevatedButton(
                              onPressed: onIsSpoiler,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSpoiler
                                    ? AppColors.whiteGlowColor
                                    : AppColors.backgroundColor,
                                side: BorderSide(
                                  color: AppColors.whiteColor,
                                  width: 2.0.spMin,
                                ),
                              ),
                              child: Text(
                                'SPOILER',
                                style: AppTextStyles.primaryTextStyle.copyWith(
                                    color: isSpoiler
                                        ? AppColors.backgroundColor
                                        : AppColors.whiteColor),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
  }
}
