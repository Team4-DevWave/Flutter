import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/Moderation/model/schedule_post.dart';
import 'package:threddit_clone/features/Moderation/view_model/schedule_post.dart';
import 'package:threddit_clone/features/post/viewmodel/post_provider.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/theme/theme.dart';

class ScheduledPosts extends ConsumerStatefulWidget {
  const ScheduledPosts({super.key, required this.communityName});
  final String? communityName;
  @override
  ConsumerState<ScheduledPosts> createState() => _ScheduledPostsState();
}

class _ScheduledPostsState extends ConsumerState<ScheduledPosts> {
  List<SchedulePostModel> posts = [];
  bool isLoading = false;
  void _getData() async {
    setState(() {
      isLoading = true;
    });
    final res = await ref.read(schedulePostProvider.notifier).getSchPosts();
    res.fold((l) => showSnackBar(context, l.message), (r) => posts = r);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }


  @override
  Widget build(BuildContext context) {
    String communityName = widget.communityName ?? "";
    String username = ref.read(userModelProvider)!.username!;

    return isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Scheduled posts"),
              actions: [
                posts.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          ref
                              .read(postDataProvider.notifier)
                              .updateCommunityName(communityName);
                          Navigator.pushNamed(context, RouteClass.postSchedule)
                              .then((value) {
                            _getData();
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ))
                    : const SizedBox()
              ],
            ),
            body: posts.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.watch_later_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Center(
                        child: Text(
                          maxLines: 2,
                          "There aren't any scheduled posts in r/$communityName yet",
                          style: AppTextStyles.primaryButtonHideTextStyle,
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(postDataProvider.notifier)
                              .updateCommunityName(communityName);
                          Navigator.pushNamed(context, RouteClass.postSchedule)
                              .then((value) => _getData());
                        },
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(AppColors.blueColor)),
                        child: Text(
                          "Schedule a post",
                          style: AppTextStyles.buttonTextStyle,
                        ),
                      )
                    ],
                  )
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      DateTime date = DateTime.parse(post.date!);
                      String timeSubstring;
                      if (post.time != null) {
                        timeSubstring = post.time!.substring(
                            post.time!.indexOf("(") + 1,
                            post.time!.indexOf(")"));
                      } else {
                        timeSubstring = "00:00";
                      }
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                            padding: EdgeInsets.all(10.spMin),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  style: BorderStyle.solid,
                                  color: AppColors.whiteHideColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Will be posted in ${date.day}/${date.month}/${date.year} at time $timeSubstring",
                                  style: AppTextStyles.primaryTextStyle,
                                ),
                                const Divider(),
                                Text(
                                  username,
                                  style: AppTextStyles
                                      .primaryButtonHideTextStyle
                                      .copyWith(fontSize: 14.spMin),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  post.title!,
                                  style: AppTextStyles.boldTextStyle
                                      .copyWith(fontSize: 16.spMin),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                SizedBox(
                                    height: 60.h,
                                    child: Text(
                                      "${post.body ?? ""} ",
                                      style: AppTextStyles
                                          .primaryButtonHideTextStyle
                                          .copyWith(fontSize: 14.spMin),
                                    )),
                                InkWell(
                                  onTap: () {
                                    posts.removeAt(index);
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.delete_outline,
                                        color: AppColors.whiteHideColor,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        "Cancel Post",
                                        style: AppTextStyles
                                            .primaryButtonHideTextStyle,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )),
                      );
                    }),
          );
  }
}
