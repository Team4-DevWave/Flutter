import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';

import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/view/widgets/FeedunitSharedpost.dart';
import 'package:threddit_clone/features/listing/view/widgets/widget_container_with_radius.dart';
import 'package:threddit_clone/features/post/view/widgets/share_bottomsheet.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class FeedUnitShare extends ConsumerStatefulWidget {
  final Post parentPost;
  final Post dataOfPost;

  const FeedUnitShare(
      {super.key, required this.dataOfPost, required this.parentPost});

  @override
  ConsumerState<FeedUnitShare> createState() => _FeedUnitShareState();
}

class _FeedUnitShareState extends ConsumerState<FeedUnitShare> {
  late int numbberOfvotes;
  int choiceBottum = -1; // 1 upvote 2 downvote
  final now = DateTime.now();
  @override
  void initState() {
    super.initState();
    numbberOfvotes = int.parse(widget.parentPost.numViews.toString());
  }

  @override
  Widget build(BuildContext context) {
    final difference = now.difference(widget.dataOfPost.postedTime);
    final hoursSincePost = difference.inHours;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteClass.postScreen,
            arguments: {
              'currentpost': widget.parentPost,
              'uid': '65f780011b4a7f2cf036ed12',
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  child: Text(
                    'r/${widget.parentPost.userID!.username}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 7.w,
                ),
                Text(
                  '${hoursSincePost}h ago',
                  style: TextStyle(color: AppColors.whiteHideColor),
                ),
              ],
            ),
            Text(
              widget.parentPost.title,
              style: AppTextStyles.boldTextStyle,
            ),
            Text(
              widget.parentPost.textBody ?? '',
              style: AppTextStyles.secondaryTextStyle,
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteClass.postScreen,
                      arguments: {
                        'currentpost': widget.parentPost.parentPost!,
                        'uid': '65f780011b4a7f2cf036ed12',
                      },
                    );
                  },
                  child: FeedUnitSharedPost(widget.dataOfPost)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    AddRadiusBoarder(
                      childWidget: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (choiceBottum == -1 || choiceBottum == 2) {
                                setState(() {
                                  if (numbberOfvotes ==
                                      int.parse(widget.dataOfPost.numViews
                                              .toString()) -
                                          1) {
                                    numbberOfvotes += 2;
                                  } else {
                                    numbberOfvotes++;
                                  }
                                  choiceBottum = 1;
                                });
                              }
                            },
                            child: Icon(
                              Icons.arrow_upward,
                              color: (choiceBottum == 1)
                                  ? AppColors.redditOrangeColor
                                  : AppColors.whiteColor,
                            ),
                          ),
                          const VerticalDivider(
                            thickness: 1,
                          ),
                          Text(
                            numbberOfvotes.toString(),
                            style: AppTextStyles.secondaryTextStyle,
                          ),
                          const VerticalDivider(
                            thickness: 1,
                          ),
                          InkWell(
                            onTap: () {
                              if (choiceBottum == -1 || choiceBottum == 1) {
                                setState(() {
                                  if (numbberOfvotes ==
                                      int.parse(widget.dataOfPost.numViews
                                              .toString()) +
                                          1) {
                                    numbberOfvotes -= 2;
                                  } else {
                                    numbberOfvotes--;
                                  }
                                  choiceBottum = 2;
                                });
                              }
                            },
                            child: Icon(
                              Icons.arrow_downward,
                              color: (choiceBottum == 2)
                                  ? AppColors.redditOrangeColor
                                  : AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(143, 255, 255, 255),
                          width: 2.w,
                        ),
                        borderRadius: BorderRadius.circular(
                            15), // Add this line to make the border circular
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.comment,
                            color: AppColors.whiteColor,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            widget.dataOfPost.commentsCount.toString(),
                            style: const TextStyle(color: AppColors.whiteColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundColor),
                    onPressed: () {
                      share(context, ref, widget.dataOfPost);
                    },
                    child: Text(
                      'Share',
                      style: AppTextStyles.primaryTextStyle,
                    ),
                  ),
                )
              ],
            ),
            const Divider(color: AppColors.whiteHideColor),
          ],
        ),
      ),
    );
  }
}
