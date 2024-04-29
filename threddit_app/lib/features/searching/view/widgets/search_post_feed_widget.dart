import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/Moderation/view/widgets/moderation.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/model/lanunch_url.dart';

import 'package:threddit_clone/features/post/view/widgets/share_bottomsheet.dart';
import 'package:threddit_clone/features/posting/model/repository/post_repository.dart';
import 'package:threddit_clone/features/posting/view/widgets/options_bottom%20sheet.dart';
import 'package:threddit_clone/features/posting/view_model/post_provider.dart';

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
class SearchFeedUnit extends ConsumerStatefulWidget {
  final Post dataOfPost;
  final String uid;
  // ignore: lines_longer_than_80_chars
  const SearchFeedUnit(this.dataOfPost, this.uid, {super.key});

  @override
  ConsumerState<SearchFeedUnit> createState() => _SearchFeedUnitState();
}

class _SearchFeedUnitState extends ConsumerState<SearchFeedUnit> {
  late bool isSpam;
  late bool isLocked;
  late int numbberOfvotes;
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

  Future getModOptions() async {
    isLocked = await ref.watch(moderationApisProvider.notifier).getLocked();
    isSpam = await ref.watch(moderationApisProvider.notifier).getSpam();
  }

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

  void upVotePost(WidgetRef ref) async {
    ref.read(votePost((postID: widget.dataOfPost.id, voteType: 1)));
    if (widget.dataOfPost.userVote == 'upvoted') {
      widget.dataOfPost.votes!.upvotes--;
      widget.dataOfPost.userVote = 'none';
    } else if (widget.dataOfPost.userVote == 'downvoted') {
      widget.dataOfPost.votes!.downvotes--;
      widget.dataOfPost.votes!.upvotes++;
      widget.dataOfPost.userVote = 'upvoted';
    } else {
      widget.dataOfPost.votes!.upvotes++;
      widget.dataOfPost.userVote = 'upvoted';
    }
    setState(() {});
  }

  void downVotePost(WidgetRef ref) async {
    ref.read(votePost((postID: widget.dataOfPost.id, voteType: -1)));
    if (widget.dataOfPost.userVote == 'downvoted') {
      widget.dataOfPost.votes!.downvotes--;
      widget.dataOfPost.userVote = 'none';
    }
    if (widget.dataOfPost.userVote == 'upvoted') {
      widget.dataOfPost.votes!.upvotes--;
      widget.dataOfPost.votes!.downvotes++;
      widget.dataOfPost.userVote = 'downvoted';
    } else {
      widget.dataOfPost.votes!.downvotes++;
      widget.dataOfPost.userVote = 'downvoted';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final difference = now.difference(widget.dataOfPost.postedTime);
    final hoursSincePost = difference.inHours;
    getModOptions();
    return Container(
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
                    child: Text(
                      'u/${widget.dataOfPost.userID?.username}',
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
              )),
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
                          border: Border.all(color: AppColors.backgroundColor),
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
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, bottom: 8.0, top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.dataOfPost.title,
                  style: AppTextStyles.boldTextStyle,
                ),
                Text(
                  widget.dataOfPost.textBody ?? '',
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
                      height: 250.h,
                      width: 350.w,
                      fit: BoxFit.fitWidth,
                      image: NetworkImage(widget.dataOfPost.image.toString()),
                    )
                  : (widget.dataOfPost.video != null &&
                          widget.dataOfPost.video != '')
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Stack(alignment: Alignment.center, children: [
                            VideoPlayer(_controller),
                            Positioned(
                              child: Container(
                                width: 50.w,
                                height: 50.h,
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
          widget.dataOfPost.type == 'url'
              ? Center(
                  child: AnyLinkPreview(
                    link: widget.dataOfPost.linkURL ?? '',
                    onTap: () {
                      launchUrlFunction(
                          Uri.parse(widget.dataOfPost.linkURL ?? ''));
                    },
                  ),
                )
              : SizedBox(),
          const Divider(color: AppColors.whiteHideColor),
        ],
      ),
    );
  }
}
