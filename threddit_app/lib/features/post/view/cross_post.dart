import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/post/view/rules_screen.dart';
import 'package:threddit_clone/features/post/view/widgets/classic_post_card.dart';
import 'package:threddit_clone/features/post/view/widgets/onexit_share.dart';
import 'package:threddit_clone/features/post/viewmodel/share_post.dart';
import 'package:threddit_clone/features/post/viewmodel/share_post_provider.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class CrossPost extends ConsumerStatefulWidget {
  const CrossPost({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CrossPostState();
}

class _CrossPostState extends ConsumerState<CrossPost> {
  TextEditingController _titleController = TextEditingController();
  late String postingIn;
  bool isOn = false;
  bool isNSFW = false;
  bool isSpoiler = false;
  bool isNotProfile = true;
  bool _isLoading = false;

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
    showModalBottomSheet(
      backgroundColor: AppColors.backgroundColor,
      context: context,
      builder: (ctx) {
        return const RulesPage();
      },
    );
  }

  Future<void> onPost() async {
    ref.watch(sharedPostProvider.notifier).setNSFW(isNSFW, isSpoiler);
    ref.watch(sharedPostProvider.notifier).setTitle(_titleController.text);
    final shared = ref.watch(sharedPostProvider);
    final message =
        shared.postIn == 'user profile' ? 'your profile' : shared.postInName;

    //send shared post to backend and recieve the responsed from the provider
    //to show user a message
    final response = await ref.watch(sharePostsProvider.notifier).sharePost();
    response.fold(
        (failure) =>
            showSnackBar(navigatorKey.currentContext!, failure.message),
        (success) => showSnackBar(
            navigatorKey.currentContext!, 'Your post shared to $message'));
  }

  @override
  void initState() {
    _titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sharedPost = ref.watch(sharedPostProvider);
    _titleController.text = sharedPost.post?.title ?? "";

    _isLoading = ref.watch(sharePostsProvider);
    ref.watch(sharedPostProvider.notifier).getPostIn()! == 'user profile'
        ? postingIn = 'My Profile'
        : postingIn = ref.watch(sharedPostProvider.notifier).getPostInName()!;

    isNotProfile =
        (ref.watch(sharedPostProvider.notifier).getPostIn()! != 'user profile');

    return _isLoading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
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
                  onPressed: onPost,
                  child: Text(
                    'Post',
                    style: AppTextStyles.primaryTextStyle.copyWith(
                        fontSize: 20.spMin,
                        color: AppColors.blueColor,
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
                          .watch(popCounter.notifier)
                          .update((state) => state = state + 1);
                      Navigator.pushNamed(context, RouteClass.chooseCommunity);
                    },
                    leading: Icon(Icons.account_circle,
                        size: 38.sp, color: AppColors.whiteColor),
                    title: Row(
                      children: [
                        Text(
                          postingIn,
                          style: AppTextStyles.primaryTextStyle.copyWith(
                            fontSize: 20.spMin,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_outlined),
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
                    controller: _titleController,
                    // initialValue: ref
                    //     .watch(sharedPostProvider.notifier)
                    //     .getShared()
                    //     .post!
                    //     .title,
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
                  PostClassic(post: ref.watch(sharedPostProvider).post!),
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
                                side: const BorderSide(
                                  color: AppColors.whiteColor,
                                  width: 2.0,
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
                                side: const BorderSide(
                                  color: AppColors.whiteColor,
                                  width: 2.0,
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