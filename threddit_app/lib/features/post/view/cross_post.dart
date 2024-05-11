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

// Callback function toggles the visibilty of the Spoiler flag and NSFW flag buttons
bool onIsOn(bool isOn) {
  return !isOn;
}

/// Callback function to toggle the NSFW (Not Safe For Work) status.
bool onIsNSFW(bool isNSFW) {
  return !isNSFW;
}

/// Callback function to toggle the spoiler status.
bool onIsSpoiler(bool isSpoiler) {
  return !isSpoiler;
}

/// Determines the color of the post button based on its validity.
Color postButtonColor(bool isValid) {
  return isValid ? AppColors.blueColor : AppColors.whiteHideColor;
}

/// Determines the background color of the NSFW button based on its status.
Color isNSFWButtonBackgroundColor(bool isNSFW) {
  return isNSFW ? AppColors.redColor : AppColors.backgroundColor;
}

/// Determines the text color of the NSFW button based on its status.
Color isNSFWButtonTextColor(bool isNSFW) {
  return isNSFW ? AppColors.backgroundColor : AppColors.whiteColor;
}

/// Determines the text color of the spoiler button based on its status.
Color isSpoilerButtonTextColor(bool isSpoiler) {
  return isSpoiler ? AppColors.backgroundColor : AppColors.whiteColor;
}

/// Determines the background color of the spoiler button based on its status.
Color isSpoilerButtonBackgroundColor(bool isSpoiler) {
  return isSpoiler ? AppColors.whiteGlowColor : AppColors.backgroundColor;
}

/// Updates the validity of the form based on the last input value.
bool updateFormValidity(String lastValue) {
  return lastValue.trim().isNotEmpty ? true : false;
}

/// A widget for creating a crosspost.
///
/// This widget allows users to create a crosspost, which is a post shared
/// from one community or user profile to another. Users can select the
/// destination community or profile, set the post title, and optionally
/// mark the post as NSFW (Not Safe For Work) or spoiler.
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

  /// Handles the action to be taken when the user exits the crosspost screen.
  void onExit() {
    for (int i = 0; i <= ref.watch(popCounter); i++) {
      Navigator.pop(context);
    }
    ref.read(isFirstTimeEnter.notifier).update((state) => true);
    ref.read(popCounter.notifier).update((state) => state = 1);
  }

  /// Opens the rules overlay for the selected community.
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

  /// Posts the crosspost to the selected destination.
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
                        color: postButtonColor(_isValid),
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
                      setState(() {
                        _isValid = updateFormValidity(lastValue);
                      });
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
                    onPressed: () {
                      setState(() {
                        isOn = onIsOn(isOn);
                      });
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                  isOn
                      ? Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                isNSFW = onIsNSFW(isNSFW);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isNSFWButtonBackgroundColor(isNSFW),
                                side: BorderSide(
                                  color: AppColors.whiteColor,
                                  width: 2.0.spMin,
                                ),
                              ),
                              child: Text(
                                'NSFW',
                                style: AppTextStyles.primaryTextStyle.copyWith(
                                    color: isNSFWButtonTextColor(isNSFW)),
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                isSpoiler = onIsSpoiler(isSpoiler);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isSpoilerButtonBackgroundColor(isSpoiler),
                                side: BorderSide(
                                  color: AppColors.whiteColor,
                                  width: 2.0.spMin,
                                ),
                              ),
                              child: Text(
                                'SPOILER',
                                style: AppTextStyles.primaryTextStyle.copyWith(
                                    color: isSpoilerButtonTextColor(isSpoiler)),
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
