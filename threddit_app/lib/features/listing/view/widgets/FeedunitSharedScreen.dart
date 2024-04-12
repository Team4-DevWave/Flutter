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

/// The `FeedUnitShare.dart` file defines a stateful widget `FeedUnitShare` that is used
/// to display a shared post in a feed. This widget takes two `Post` objects as parameters:
/// `parentPost` and `dataOfPost`. The `parentPost` represents the original post that was
/// shared, while `dataOfPost` represents the post that contains the share.

/// The `Post` objects are passed to the widget through its constructor. The state for
/// this widget is managed by the `_FeedUnitShareState` class.

/// Upon initialization of the `_FeedUnitShareState` class, the number of votes for the
/// post is set to the number of views of the parent post. This is done in the `initState`
/// method, which is a lifecycle method in Flutter that is called exactly once and then
/// never again.

/// The `build` method of the `_FeedUnitShareState` class returns a `Padding` widget that
/// contains a `Column` widget. This `Column` widget displays the details of the shared
/// post and the original post. The details include the username, post time, title, body
/// text, image (if any), number of views, and number of comments.

/// The `choiceBottum` variable is used to track the user's voting choice for the post.
/// A value of 1 represents an upvote, while a value of 2 represents a downvote. This
/// variable is initialized to -1, indicating that the user has not yet made a voting
/// choice.

/// The `FeedUnitShare` widget is designed to be flexible and reusable, allowing it to be
/// used in any part of the application that requires displaying a shared post.
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
              // IconButton(
              //     onPressed: () {
              //       Navigator.pushNamed(
              //         context,
              //         RouteClass.postScreen,
              //         arguments: {
              //           'currentpost': widget.dataOfPost,
              //           'uid': 'wewe',
              //         },
              //       );
              //     },
              //     icon: Icon(Icons.share, color: AppColors.whiteColor)),
              // SharePost(
              //   post: widget.dataOfPost,
              // ),
            ],
          ),
          const Divider(color: AppColors.whiteHideColor),
        ],
      ),
    );
  }
}
