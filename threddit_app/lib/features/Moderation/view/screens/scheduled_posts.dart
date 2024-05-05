
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class ScheduledPosts extends ConsumerStatefulWidget {
  const ScheduledPosts({super.key, required this.communityName});
  final String?communityName;
  @override
  ConsumerState<ScheduledPosts> createState() => _ScheduledPostsState();
}

class _ScheduledPostsState extends ConsumerState<ScheduledPosts> {
  
  @override
  Widget build(BuildContext context) {
    String communityName = widget.communityName ?? "nothing";


    return Scaffold(
      appBar: AppBar(
        title: const Text("Scheduled posts"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [ 
          const Icon(Icons.watch_later_outlined, color: Colors.white,),
          SizedBox(height: 5.h,),
          Center(
            child: Text(
              maxLines: 2,
              "There aren't any scheduled posts in r/$communityName yet",
              style: AppTextStyles.primaryButtonHideTextStyle,
            ),
          ),
           SizedBox(height: 5.h,),
          ElevatedButton(
            onPressed: () {
              ref.read(postDataProvider.notifier).updateCommunityName(communityName);
              Navigator.pushNamed(context, RouteClass.confirmPostScreen,);
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColors.blueColor)),
            child: Text("Schedule a post", style: AppTextStyles.buttonTextStyle,),
          )
        ],
      ),
    );
  }
}
