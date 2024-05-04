import 'package:flutter/material.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class ScheduledPosts extends StatefulWidget {
  const ScheduledPosts({super.key});

  @override
  State<ScheduledPosts> createState() => _ScheduledPostsState();
}

class _ScheduledPostsState extends State<ScheduledPosts> {
  String communityName = "dummy name";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scheduled posts"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.watch_later_outlined),
          Text(
            "There aren't any scheduled posts in r/$communityName yet",
            style: AppTextStyles.primaryButtonHideTextStyle,
          ),
          ElevatedButton(
            onPressed: () {
              //confirm post screen with an extra part to schedule posts
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColors.blueColor)),
            child: const Text("Schedule a post"),
          )
        ],
      ),
    );
  }
}
