import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/Moderation/view_model/moderation_apis.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/model/lanunch_url.dart';
import 'package:threddit_clone/features/listing/view/widgets/FeedunitSharedpost.dart';
import 'package:threddit_clone/features/posting/model/repository/post_repository.dart';
import 'package:threddit_clone/features/posting/view_model/post_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

/// The `SearchFeedUnitShare` class is a `ConsumerStatefulWidget` that represents a shared post in a feed.
/// It displays the post's details, such as the title, body, and number of votes, and allows the user to upvote or downvote the post,
/// mark it as NSFW or a spoiler, and share it.
/// The class also provides methods for toggling the NSFW and spoiler statuses, upvoting and downvoting the post, and getting moderation options.
/// The `SearchFeedUnitShare` class takes a user ID, a `Post` object representing the shared post, and a `Post` object representing the parent post as parameters.
class SearchFeedUnitShare extends ConsumerStatefulWidget {
  final Post parentPost;
  final Post dataOfPost;
  final String uid;
  const SearchFeedUnitShare(this.uid,
      {super.key, required this.dataOfPost, required this.parentPost});

  @override
  ConsumerState<SearchFeedUnitShare> createState() =>
      _SearchFeedUnitShareState();
}

class _SearchFeedUnitShareState extends ConsumerState<SearchFeedUnitShare> {
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

  Future getModOptions() async {
    isLocked = await ref.watch(moderationApisProvider.notifier).getLocked();
    isSpam = await ref.watch(moderationApisProvider.notifier).getSpam();
  }

  void toggleNsfw() async {
    ref.read(toggleNSFW(widget.dataOfPost.id));
    widget.dataOfPost.nsfw = !widget.dataOfPost.nsfw;
    Navigator.pop(context);
    setState(() {});
  }

  void toggleSPOILER() async {
    ref.read(toggleSpoiler(widget.dataOfPost.id));
    widget.dataOfPost.spoiler = !widget.dataOfPost.spoiler;
    Navigator.pop(context);
    setState(() {});
  }

  void upVotePost(WidgetRef ref) async {
    ref.read(votePost((postID: widget.parentPost.id, voteType: 1)));
    if (widget.parentPost.userVote == 'upvoted') {
      widget.parentPost.votes!.upvotes--;
      widget.parentPost.userVote = 'none';
    } else if (widget.parentPost.userVote == 'downvoted') {
      widget.parentPost.votes!.downvotes--;
      widget.parentPost.votes!.upvotes++;
      widget.parentPost.userVote = 'upvoted';
    } else {
      widget.parentPost.votes!.upvotes++;
      widget.parentPost.userVote = 'upvoted';
    }
    setState(() {});
  }

  void downVotePost(WidgetRef ref) async {
    ref.read(votePost((postID: widget.parentPost.id, voteType: -1)));
    if (widget.parentPost.userVote == 'downvoted') {
      widget.parentPost.votes!.downvotes--;
      widget.parentPost.userVote = 'none';
    }
    if (widget.parentPost.userVote == 'upvoted') {
      widget.parentPost.votes!.upvotes--;
      widget.parentPost.votes!.downvotes++;
      widget.parentPost.userVote = 'downvoted';
    } else {
      widget.parentPost.votes!.downvotes++;
      widget.parentPost.userVote = 'downvoted';
    }
    setState(() {});
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
                child: FeedUnitSharedPost(widget.dataOfPost),
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
      ),
    );
  }
}
