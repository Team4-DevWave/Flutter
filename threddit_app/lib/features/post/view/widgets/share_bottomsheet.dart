import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/viewmodel/share_post_provider.dart';

import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/photos.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class SharePost extends ConsumerStatefulWidget {
  const SharePost({
    super.key,
    required this.post,
  });
  final Post post;

  @override
  ConsumerState<SharePost> createState() => _SharePostState();
}

class _SharePostState extends ConsumerState<SharePost> {
  void onCommunity() {
    ref.watch(sharedPostProvider.notifier).setToBeSharedPost(widget.post);

    Navigator.pushNamed(context, RouteClass.chooseCommunity);
  }

  ///This function navigates to the cross post screen
  void onProfile(String username) {
    ref.watch(sharedPostProvider.notifier).setToBeSharedPost(widget.post);
    ref
        .watch(sharedPostProvider.notifier)
        .setPostInAndInName('user profile', username);
    Navigator.pushNamed(context, RouteClass.crossPost);
  }

  @override
  Widget build(BuildContext context) {
    ///This function navigates to the choose communtiy screen

    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.backgroundColor),
        onPressed: () {
          showModalBottomSheet<void>(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15.0),
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
                                  onPressed: () => onCommunity(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppColors.registerButtonColor,
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
                                onPressed: () => onProfile('She3bo'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.registerButtonColor,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(15),
                                ),
                                child: Image.asset(
                                  Photos.thinkingSno,
                                  fit: BoxFit.cover,
                                  width: 17.w,
                                  height: 17.h,
                                ),
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
        },
        child: const Text(
          'Share',
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
