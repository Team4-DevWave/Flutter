import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/post/view/widgets/share_bottomsheet.dart';

import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/features/listing/view/widgets/widget_container_with_radius.dart';
import 'package:video_player/video_player.dart';

/// The selected code in the `post_feed_widget.dart` file is responsible for decorating a
/// `Container` widget. The `BoxDecoration` class is used to provide a border and a
/// circular border radius to the `Container`.

/// The `border` property of `BoxDecoration` is set to a `Border` object that is created
/// using the `Border.all` method. This method creates a uniform border around the
/// `Container`. The color of the border is set to a semi-transparent white color, and
/// the width of the border is set to `2.w`, which is a width relative to the screen
/// width.

/// The `borderRadius` property of `BoxDecoration` is set to a `BorderRadius` object
/// that is created using the `BorderRadius.circular` method. This method creates a
/// circular border radius with a radius of 15.

/// The `padding` property of the `Container` is set to symmetric horizontal padding of
/// `16.0` and vertical padding of `4.0`. This adds space around the child of the
/// `Container`, separating the child from the border.
class FeedUnit extends ConsumerStatefulWidget {
  final Post dataOfPost;
  // ignore: lines_longer_than_80_chars
  const FeedUnit(this.dataOfPost, {super.key});

  @override
  ConsumerState<FeedUnit> createState() => _FeedUnitState();
}

class _FeedUnitState extends ConsumerState<FeedUnit> {
  late int numbberOfvotes;
  final now = DateTime.now();
  late VideoPlayerController _controller;
  int choiceBottum = -1; // 1 upvote 2 downvote

  @override
  void initState() {
    super.initState();
    numbberOfvotes = int.parse(widget.dataOfPost.numViews.toString());
    if (widget.dataOfPost.video != null) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.dataOfPost.video!),
      )..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final difference = now.difference(widget.dataOfPost.postedTime);
    final hoursSincePost = difference.inHours;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          RouteClass.postScreen,
          arguments: {
            'currentpost': widget.dataOfPost,
            'uid': '65f780011b4a7f2cf036ed12',
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
                      '${hoursSincePost}h ago',
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
                    : (widget.dataOfPost.video != null)
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child:
                                Stack(alignment: Alignment.center, children: [
                              VideoPlayer(_controller),
                              Positioned(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              )
                            ]),
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
