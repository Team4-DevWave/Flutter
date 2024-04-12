import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';

import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class FeedUnitSharedPost extends StatefulWidget {
  final Post dataOfPost;
  // ignore: lines_longer_than_80_chars
  const FeedUnitSharedPost(this.dataOfPost, {super.key});

  @override
  State<FeedUnitSharedPost> createState() => _FeedUnitSharedPostState();
}

class _FeedUnitSharedPostState extends State<FeedUnitSharedPost> {
  late int numbberOfvotes;
  int choiceBottum = -1; // 1 upvote 2 downvote

  @override
  void initState() {
    super.initState();
    numbberOfvotes = int.parse(widget.dataOfPost.numViews.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Add this line
        border: Border.all(
          color: AppColors.whiteGlowColor, // Specify the border color
          width: 1, // Specify the border thickness
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                        height: 125.h,
                        width: 250.w,
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(widget.dataOfPost.image.toString()
                            //'https://images.unsplash.com/photo-1682685797660-3d847763208e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
                            ),
                      )
                    : const SizedBox(),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "${numbberOfvotes.toString()} views",
                      style: AppTextStyles.secondaryTextStyle,
                    ),
                    SizedBox(
                      width: 20.w,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
