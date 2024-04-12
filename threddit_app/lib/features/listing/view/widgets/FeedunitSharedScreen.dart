import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';

import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/view/widgets/FeedunitSharedpost.dart';
import 'package:threddit_clone/features/listing/view/widgets/widget_container_with_radius.dart';
import 'package:threddit_clone/features/post/view/widgets/share_bottomsheet.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class FeedUnitShare extends StatefulWidget {
  final Post parentPost;
  final Post dataOfPost;

  const FeedUnitShare(
      {super.key, required this.dataOfPost, required this.parentPost});

  @override
  State<FeedUnitShare> createState() => _FeedUnitShareState();
}

class _FeedUnitShareState extends State<FeedUnitShare> {
  late int numbberOfvotes;
  int choiceBottum = -1; // 1 upvote 2 downvote

  @override
  void initState() {
    super.initState();
    numbberOfvotes = int.parse(widget.parentPost.numViews.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                widget.dataOfPost.postedTime.toString().substring(0, 10),
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
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteClass.postScreen,
                arguments: {
                  'currentpost': widget.dataOfPost,
                  'uid': 'wewe',
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: FeedUnitSharedPost(widget.dataOfPost),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AddRadiusBoarder(
                    childWidget: Row(
                      children: [
                        IconButton(
                            onPressed: () {
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
                            icon: Icon(
                              Icons.arrow_upward,
                              color: (choiceBottum == 1)
                                  ? AppColors.redditOrangeColor
                                  : AppColors.whiteColor,
                            )),
                        Text(
                          numbberOfvotes.toString(),
                          style: AppTextStyles.secondaryTextStyle,
                        ),
                        const VerticalDivider(
                          thickness: 1,
                        ),
                        IconButton(
                            onPressed: () {
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
                            icon: Icon(
                              Icons.arrow_downward,
                              color: (choiceBottum == 2)
                                  ? AppColors.redditOrangeColor
                                  : AppColors.whiteColor,
                            )),
                      ],
                    ),
                  ),
                  Container(
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
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RouteClass.postScreen,
                      arguments: {
                        'currentpost': widget.dataOfPost,
                        'uid': 'wewe',
                      },
                    );
                  },
                  icon: Icon(Icons.share, color: AppColors.whiteColor)),
              SharePost(
                post: widget.dataOfPost,
              ),
            ],
          ),
          const Divider(color: AppColors.whiteHideColor),
        ],
      ),
    );
  }
}
