import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/listing/model/lanunch_url.dart';
import 'package:threddit_clone/features/post/view/widgets/share_bottomsheet.dart';
import 'package:threddit_clone/features/posting/view/widgets/poll.dart';
import 'package:threddit_clone/features/posting/view_model/post_provider.dart';
import 'package:threddit_clone/features/posting/model/repository/post_repository.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:video_player/video_player.dart';

/// This widget displays the post card
/// It displays the post and all the details of the post
/// it also displays the options that the user can perform on the post
/// it also displays the upvote and downvote buttons
/// it also displays the share button
/// it also displays the comments button
/// it also calls the correct bottom based on the moderation case of the user

class PostCard extends ConsumerStatefulWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.uid,
  });
  final Post post;
  final String uid;
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  late VideoPlayerController _controller;
  UserModelMe? user;
  @override
  void initState() {
    super.initState();
    if (widget.post.video != null) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.post.video!),
      )..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    user = ref.read(userModelProvider)!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext) {
    widget.post.userPollVote ??= '';
    void toggleNsfw() {
      widget.post.nsfw = !widget.post.nsfw;
      setState(() {});
      ref.read(toggleNSFW(widget.post.id));
      Navigator.pop(context);
    }

    void toggleSPOILER() async {
      widget.post.spoiler = !widget.post.spoiler;
      setState(() {});
      ref.read(toggleSpoiler(widget.post.id));
      Navigator.pop(context);
    }

    void upVotePost(WidgetRef ref) async {
      ref.read(votePost((postID: widget.post.id, voteType: 1)));
      if (widget.post.userVote == 'upvoted') {
        widget.post.votes!.upvotes--;
        widget.post.userVote = 'none';
      } else if (widget.post.userVote == 'downvoted') {
        widget.post.votes!.downvotes--;
        widget.post.votes!.upvotes++;
        widget.post.userVote = 'upvoted';
      } else {
        widget.post.votes!.upvotes++;
        widget.post.userVote = 'upvoted';
      }
      setState(() {});
    }

    void downVotePost(WidgetRef ref) async {
      ref.read(votePost((postID: widget.post.id, voteType: -1)));
      if (widget.post.userVote == 'upvoted') {
        widget.post.votes!.upvotes--;
      }
      if (widget.post.userVote == 'downvoted') {
        widget.post.votes!.downvotes--;
        widget.post.userVote = 'none';
      } else {
        widget.post.votes!.downvotes++;
        widget.post.userVote = 'downvoted';
      }
      setState(() {});
    }

    final now = DateTime.now();
    final difference = now.difference(widget.post.postedTime);
    final hoursSincePost = difference.inHours;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: widget.post.userID!.profilePicture != null &&
                          widget.post.userID!.profilePicture != ''
                      ? CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              NetworkImage(widget.post.userID!.profilePicture!))
                      : const CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              AssetImage('assets/images/Default_Avatar.png'),
                        ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.post.subredditID != null)
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteClass.communityScreen,
                            arguments: {
                              'id': widget.post.subredditID!.name,
                              'uid': widget.uid
                            },
                          );
                        },
                        child: Text('r/${widget.post.subredditID?.name}',
                            style: AppTextStyles.primaryTextStyle.copyWith(
                                fontSize: 12,
                                color: const Color.fromARGB(98, 255, 255, 255),
                                fontWeight: FontWeight.bold)),
                      ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            widget.post.userID!.username == user?.username
                                ? Navigator.pushNamed(
                                    context, RouteClass.userProfileScreen)
                                : Navigator.pushNamed(
                                    context, RouteClass.otherUsers,
                                    arguments: widget.post.userID!.username);
                          },
                          child: Text(
                            'u/${widget.post.userID!.username}',
                            style: AppTextStyles.primaryTextStyle.copyWith(
                                fontSize: 12,
                                color: const Color.fromARGB(206, 20, 113, 190)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.circle,
                          size: 4,
                          color: Color.fromARGB(98, 255, 255, 255),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${hoursSincePost}h',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(110, 255, 255, 255),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            if (widget.post.nsfw || widget.post.spoiler)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.post.nsfw)
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.pink,
                              border:
                                  Border.all(color: AppColors.backgroundColor),
                              borderRadius: BorderRadius.circular(
                                  35) // Adjust the radius as needed
                              ),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: const Text("NSFW",
                              style: TextStyle(color: Colors.white))),
                    SizedBox(
                      width: 10.w,
                    ),
                    if (widget.post.spoiler)
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: Text(
                widget.post.title,
                style: AppTextStyles.primaryTextStyle.copyWith(
                    color: const Color.fromARGB(238, 255, 255, 255),
                    fontSize: 18),
              ),
            ),
            if (widget.post.textBody != null)
              Text(
                widget.post.textBody!,
                style: AppTextStyles.primaryTextStyle.copyWith(
                    color: const Color.fromARGB(196, 255, 255, 255),
                    fontSize: 15),
              ),
            (widget.post.image != null && widget.post.image != '')
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.network(widget.post.image!),
                  )
                : (widget.post.video != null && widget.post.video != '')
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: _controller.value.isInitialized
                            ? GestureDetector(
                                onTap: () {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                  setState(() {});
                                },
                                child: AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        VideoPlayer(_controller),
                                        Positioned(
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
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
                                ),
                              )
                            : const CircularProgressIndicator(),
                      )
                    : widget.post.type=='poll'?PollWidget(votes: widget.post.poll!.values.fold(0, (prev, curr) => prev + curr), options: widget.post.poll!.keys.toList(),userVote: widget.post.userPollVote!,postId: widget.post.id,) :const SizedBox(),
            widget.post.type == 'url'
                ? Center(
                    child: AnyLinkPreview(
                      link: widget.post.linkURL ?? '',
                      onTap: () {
                        launchUrlFunction(Uri.parse(widget.post.linkURL ?? ''));
                      },
                    ),
                  )
                : const SizedBox(),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      upVotePost(ref);
                    },
                    icon: const Icon(
                      Icons.arrow_upward_outlined,
                      size: 30,
                    ),
                    color: widget.post.userVote == 'upvoted'
                        ? Colors.red
                        : Colors.white),
                Text(
                  '${widget.post.votes!.upvotes - widget.post.votes!.downvotes == 0 ? "vote" : widget.post.votes!.upvotes - widget.post.votes!.downvotes}',
                  style: AppTextStyles.primaryTextStyle
                      .copyWith(color: AppColors.whiteColor),
                ),
                IconButton(
                  onPressed: () {
                    downVotePost(ref);
                  },
                  icon: const Icon(
                    Icons.arrow_downward_outlined,
                    size: 30,
                  ),
                  color: widget.post.userVote == 'downvoted'
                      ? Colors.blue
                      : Colors.white,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: widget.uid == widget.post.userID!.id
                        ? [
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor:
                                          AppColors.backgroundColor,
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              title: Text(
                                                widget.post.spoiler
                                                    ? 'UnMark Spoiler'
                                                    : 'Mark Spoiler',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(
                                                  Icons.warning_rounded),
                                              onTap: () {
                                                toggleSPOILER();
                                              },
                                            ),
                                            ListTile(
                                              title: const Text(
                                                'Lock Comments',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(Icons.lock),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: Text(
                                                widget.post.nsfw
                                                    ? 'UnMark NSFW'
                                                    : 'Mark NSFW',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(Icons.copy),
                                              onTap: () {
                                                toggleNsfw();
                                              },
                                            ),
                                            ListTile(
                                              title: const Text(
                                                'Distinguish as moderator',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(
                                                Icons.star_outline_outlined,
                                              ),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: const Text(
                                                'Remove post',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(
                                                Icons.delete,
                                              ),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: const Text(
                                                'Remove as spam',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(
                                                  Icons.folder_delete_outlined),
                                              onTap: () {},
                                            ),
                                            ListTile(
                                              title: const Text(
                                                'Approve',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: const Icon(
                                                  Icons.verified_user_rounded),
                                              onTap: () {},
                                            )
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(Icons.add_moderator_sharp)),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.insights,
                                color: Colors.purple,
                              ),
                            )
                          ]
                        : [
                            ElevatedButton.icon(
                              onPressed: () {
                                share(context, ref, widget.post);
                              },
                              icon: const Icon(
                                Icons.ios_share_rounded,
                                color: Colors.white,
                              ),
                              label: const Text("Share"),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white),
                            ),
                          ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
