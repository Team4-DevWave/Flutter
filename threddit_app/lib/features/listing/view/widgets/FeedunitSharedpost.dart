import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/chatting/view/widgets/chat_item.dart';

import 'package:threddit_clone/features/home_page/model/newpost_model.dart';

import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:video_player/video_player.dart';

/// The `FeedUnitSharedPost.dart` file defines a stateful widget `FeedUnitSharedPost`
/// that is used to display a single post in a feed. This widget takes a `Post` object
/// as a parameter and displays its details. The `Post` object is passed to the widget
/// through its constructor. The state for this widget is managed by the
/// `_FeedUnitSharedPostState` class.

/// Upon initialization of the `_FeedUnitSharedPostState` class, the number of votes for
/// the post is set to the number of views of the post. This is done in the `initState`
/// method, which is a lifecycle method in Flutter that is called exactly once and then
/// never again.

/// The `build` method of the `_FeedUnitSharedPostState` class returns a `Container`
/// widget that displays the details of the post. The details include the username, post
/// time, title, body text, image (if any), number of views, and number of comments. The
/// `Container` widget is decorated with a border and a circular border radius for
/// aesthetic purposes.

/// The `choiceBottum` variable is used to track the user's voting choice for the post.
/// A value of 1 represents an upvote, while a value of 2 represents a downvote. This
/// variable is initialized to -1, indicating that the user has not yet made a voting
/// choice.

/// The `FeedUnitSharedPost` widget is designed to be flexible and reusable, allowing it
/// to be used in any part of the application that requires displaying a post.

class FeedUnitSharedPost extends StatefulWidget {
  final Post dataOfPost;

  const FeedUnitSharedPost(this.dataOfPost, {super.key});

  @override
  State<FeedUnitSharedPost> createState() => _FeedUnitSharedPostState();
}

class _FeedUnitSharedPostState extends State<FeedUnitSharedPost> {
  late int numbberOfvotes;
  int choiceBottum = -1; // 1 upvote 2 downvote
  final now = DateTime.now();
  late VideoPlayerController _controller;
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
    final hoursSincePost = formatDateTime(widget.dataOfPost.postedTime);

    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Add this line
        border: Border.all(
          color: const Color.fromARGB(
              131, 255, 255, 255), // Specify the border color
          width: 1.w, // Specify the border thickness
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
                    Text(
                      'r/${widget.dataOfPost.userID?.username}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 7.w,
                    ),
                    Text(
                      '${hoursSincePost}',
                      style: const TextStyle(color: AppColors.whiteHideColor),
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
                child: (widget.dataOfPost.image != null &&
                        widget.dataOfPost.image != '')
                    ? Image(
                        height: 200.h,
                        width: 300.w,
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(widget.dataOfPost.image.toString()),
                      )
                    : (widget.dataOfPost.video != null &&
                            widget.dataOfPost.video != '')
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child:
                                Stack(alignment: Alignment.center, children: [
                              VideoPlayer(_controller),
                              Positioned(
                                child: Container(
                                  width: 125.h,
                                  height: 200.w,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 32.sp,
                                  ),
                                ),
                              )
                            ]),
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
