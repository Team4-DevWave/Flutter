import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/view/widgets/share_bottomsheet.dart';

import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/features/listing/view/widgets/widget_container_with_radius.dart';

class FeedUnit extends StatefulWidget {
  final Post dataOfPost;
  // ignore: lines_longer_than_80_chars
  const FeedUnit(this.dataOfPost, {super.key});

  @override
  State<FeedUnit> createState() => _FeedUnitState();
}

class _FeedUnitState extends State<FeedUnit> {
  late int numbberOfvotes;
  int choiceBottum = -1; // 1 upvote 2 downvote

  @override
  void initState() {
    super.initState();
    numbberOfvotes = int.parse(widget.dataOfPost.numViews.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'r/${widget.dataOfPost.userID?.username}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 7.w,
                    ),
                    Text(
                      widget.dataOfPost.postedTime.toString(),
                      style: TextStyle(color: AppColors.whiteHideColor),
                    ),
                  ],
                )),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteClass.communityScreen,
                        arguments: {
                          'id': widget.dataOfPost.subredditID!.name,
                          'uid': widget.dataOfPost.userID!.id
                        });
                  },
                  child: const Icon(
                    Icons.more_vert,
                    color: AppColors.whiteHideColor,
                  ),
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.dataOfPost.title,
                    style: AppTextStyles.boldTextStyle,
                  ),
                  Text(
                    widget.dataOfPost.textBody.toString(),
                    style: AppTextStyles.secondaryTextStyle,
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.backgroundColor),
                    borderRadius:
                        BorderRadius.circular(35) // Adjust the radius as needed
                    ),
                child: (widget.dataOfPost.image != null)
                    ? Image(
                        height: 250.h,
                        width: 360.w,
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(widget.dataOfPost.image.toString()
                            //'https://images.unsplash.com/photo-1682685797660-3d847763208e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
                            ),
                      )
                    : const SizedBox(),
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
                SharePost(
                  post: widget.dataOfPost,
                ),
              ],
            ),
            const Divider(color: AppColors.whiteHideColor),
          ],
        ),
      ),
    );
  }
}
