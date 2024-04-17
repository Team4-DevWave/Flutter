import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/Moderation/view/widgets/moderation.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';

import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/view/widgets/FeedunitSharedpost.dart';
import 'package:threddit_clone/features/listing/view/widgets/widget_container_with_radius.dart';
import 'package:threddit_clone/features/post/view/widgets/share_bottomsheet.dart';
import 'package:threddit_clone/features/posting/view/widgets/options_bottom%20sheet.dart';
import 'package:threddit_clone/features/posting/view_model/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// The [FeedUnitShare] widget is a [ConsumerStatefulWidget] that displays a shared post in the feed.
///
/// It takes a user ID, a post, and a parent post as parameters.
class FeedUnitShare extends ConsumerStatefulWidget {
  final Post parentPost;
  final Post dataOfPost;
  final String uid;

  /// Creates a [FeedUnitShare] widget.
  ///
  /// Takes a user ID, a post, and a parent post as parameters.
  const FeedUnitShare(this.uid,
      {super.key, required this.dataOfPost, required this.parentPost});

  @override
  ConsumerState<FeedUnitShare> createState() => _FeedUnitShareState();
}

/// The [_FeedUnitShareState] class is the state object for a [FeedUnitShare] widget.
///
/// It manages the number of votes, whether the post is locked or spam, and the choice for the bottom sheet.
class _FeedUnitShareState extends ConsumerState<FeedUnitShare> {
  late int numbberOfvotes;
  late bool isLocked;
  late bool isSpam;
  int choiceBottum = -1; // 1 upvote 2 downvote
  final now = DateTime.now();
  @override
  void initState() {
    super.initState();

    numbberOfvotes = int.parse(widget.parentPost.numViews.toString());
  }

  /// Fetches the moderation options for the post.
  ///
  /// Sets the [isLocked] and [isSpam] variables based on the response from the server.
  Future getModOptions() async {
    isLocked = await ref.watch(moderationApisProvider.notifier).getLocked();
    isSpam = await ref.watch(moderationApisProvider.notifier).getSpam();
  }

  /// Toggles the NSFW status of the post.
  ///
  /// Calls the [toggleNSFW] function with the post's ID and updates the post's NSFW status.
  void toggleNsfw() async {
    ref.read(toggleNSFW(widget.dataOfPost.id));
    widget.dataOfPost.nsfw = !widget.dataOfPost.nsfw;
    Navigator.pop(context);
    setstate() {}
  }

  void toggleSPOILER() async {
    ref.read(toggleSpoiler(widget.dataOfPost.id));
    widget.dataOfPost.spoiler = !widget.dataOfPost.spoiler;
    Navigator.pop(context);
    setstate() {}
  }

  @override
  Widget build(BuildContext context) {
    getModOptions();
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
              'uid': widget.uid,
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: Text(
                        'r/${widget.parentPost.userID!.username}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 7.w,
                    ),
                    Text(
                      '${hoursSincePost}h ago',
                      style: const TextStyle(color: AppColors.whiteHideColor),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              OptionsBotttomSheet(
                                  post: widget.dataOfPost,
                                  toggleSPOILER: toggleSPOILER,
                                  toggleNsfw: toggleNsfw,
                                  uid: widget.uid)
                            ],
                          );
                        },
                        backgroundColor: AppColors.backgroundColor);
                  },
                  child: const Icon(
                    Icons.more_vert,
                    color: AppColors.whiteHideColor,
                  ),
                )
              ],
            ),
            if (widget.dataOfPost.nsfw || widget.dataOfPost.spoiler)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.dataOfPost.nsfw)
                      Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.pink,
                                  border: Border.all(
                                      color: AppColors.backgroundColor),
                                  borderRadius: BorderRadius.circular(
                                      35) // Adjust the radius as needed
                                  ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: const Text("NSFW",
                                  style: TextStyle(color: Colors.white))),
                          SizedBox(
                            width: 10.w,
                          ),
                        ],
                      ),
                    if (widget.dataOfPost.spoiler)
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.purple,
                            border:
                                Border.all(color: AppColors.backgroundColor),
                            borderRadius: BorderRadius.circular(
                                35) // Adjust the radius as needed
                            ),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: const Text("SPOILER",
                            style: TextStyle(color: Colors.white)),
                      ),
                  ],
                ),
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
                        'uid': widget.uid,
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
                              } else {
                                setState(() {
                                  numbberOfvotes--;
                                  choiceBottum = -1;
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
                              } else {
                                setState(() {
                                  numbberOfvotes++;
                                  choiceBottum = -1;
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteClass.postScreen,
                                arguments: {
                                  'currentpost': widget.dataOfPost,
                                  'uid': widget.uid,
                                },
                              );
                            },
                            child: const Icon(
                              Icons.comment,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            widget.parentPost.commentsCount.toString(),
                            style: const TextStyle(color: AppColors.whiteColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        getModOptions().then((value) =>
                            moderation(context, ref, isSpam, isLocked));
                      });
                    },
                    icon: const Icon(
                      Icons.shield,
                      color: AppColors.realWhiteColor,
                    )),
                IconButton(
                  icon:
                      const Icon(Icons.share, color: AppColors.realWhiteColor),
                  onPressed: () {
                    share(context, ref, widget.dataOfPost);
                  },
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
