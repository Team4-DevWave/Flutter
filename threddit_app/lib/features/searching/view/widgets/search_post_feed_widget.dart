import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/model/lanunch_url.dart';

import 'package:threddit_clone/features/posting/model/repository/post_repository.dart';
import 'package:threddit_clone/features/posting/view_model/post_provider.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';

import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:video_player/video_player.dart';

/// The `SearchFeedUnit` widget is responsible for rendering a single post in the search feed.
/// It displays various details such as the post author, posting time, post content (text and/or image/video), and any additional attributes like NSFW or spoiler tags.
///
/// The widget takes a [dataOfPost] parameter representing the post data to be displayed and a [uid] parameter representing the user ID.
///
/// The `build` method of the widget constructs the UI layout for the post,
/// including the post author, posting time, content (title and text body), and any media content (image or video). Additionally,
/// it handles rendering of NSFW or spoiler tags if present.
///
/// The post content is displayed within a `Container`, which is decorated with a `BoxDecoration` to provide a border and circular border radius.
/// The border color is set to a semi-transparent white color, and the width is adjusted based on screen width.
///  Horizontal and vertical padding is applied to create space around the content.
///
/// If the post contains an image or video, it is displayed using the `Image` or `VideoPlayer` widget, respectively.
///  Users can play/pause videos by tapping on the video player.
///
/// If the post type is a URL, the `AnyLinkPreview` widget is used to display a preview of the linked content.
/// Tapping on the preview opens the link in the default browser.
///
/// The widget also listens for user interactions such as tapping on the author's username or tapping on the post content to navigate to the post details screen.
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
  UserModelMe? user;
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
  void didChangeDependencies() {
    setUserModel();
    super.didChangeDependencies();
  }

  Future<void> setUserModel() async {
    user = ref.read(userModelProvider)!;
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
                Container(
                  height: 20.h,
                  child: Markdown(
                    onTapLink: (text, href, title) {
                      launchUrlFunction(Uri.parse(href ?? ""));
                    },
                    padding: EdgeInsets.zero,
                    data: widget.dataOfPost.textBody ?? '',
                    styleSheet: MarkdownStyleSheet(
                        a: const TextStyle(
                          color: const Color.fromARGB(255, 7, 114, 255),
                        ),
                        p: AppTextStyles.secondaryTextStyle),
                  ),
                ),
                // Text(
                //   widget.dataOfPost.textBody ?? '',
                //   style: AppTextStyles.secondaryTextStyle,
                // ),
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
              : const SizedBox(),
          //const Divider(color: AppColors.whiteHideColor),
        ],
      ),
    );
  }
}
