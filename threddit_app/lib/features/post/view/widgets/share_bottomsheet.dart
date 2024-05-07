import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/viewmodel/share_post_provider.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';

import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// Displays a modal bottom sheet for sharing a post.
///
/// This function displays a modal bottom sheet for sharing a post with options
/// to share it in a community or on the user's profile.
///
/// [context] is the BuildContext used to show the modal bottom sheet.
///
/// [ref] is the WidgetRef used to access Riverpod providers.
///
/// [post] is the Post object to be shared.
void share(BuildContext context, WidgetRef ref, Post post) {
  ref.read(isFirstTimeEnter.notifier).update((state) => true);
  ref.read(isChanged.notifier).update((state) => false);
  final userProfile = ref.read(userModelProvider)!.profilePicture ?? "";
  showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0.r),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      builder: (context) {
        return Container(
          height: 150.h,
          padding: EdgeInsets.fromLTRB(10.w, 10.h, 5.w, 5.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share',
                style: AppTextStyles.primaryButtonGlowTextStyle
                    .copyWith(fontSize: 20.spMin),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            ref
                                .read(sharedPostProvider.notifier)
                                .setToBeSharedPost(post);
                            Navigator.pushNamed(
                                context, RouteClass.chooseCommunity);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.registerButtonColor,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(15),
                          ),
                          child: const Icon(
                            Icons.share,
                            color: AppColors.whiteGlowColor,
                          )),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        'Communtiy',
                        style: AppTextStyles.primaryTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(sharedPostProvider.notifier)
                              .setToBeSharedPost(post);
                          ref
                              .read(sharedPostProvider.notifier)
                              .setDestination("");
                          ref
                              .read(shareProfilePic.notifier)
                              .update((state) => userProfile);
                          Navigator.pushNamed(context, RouteClass.crossPost);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.registerButtonColor,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        child: userProfile == ""
                            ? CircleAvatar(
                                radius: 15.r,
                                backgroundImage:
                                    const AssetImage(Photos.profileDefault))
                            : CircleAvatar(
                                radius: 15.r,
                                backgroundImage: NetworkImage(userProfile)),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        'Profile',
                        style: AppTextStyles.primaryTextStyle,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      });
}
