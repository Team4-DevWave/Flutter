import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/community/view%20model/community_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:threddit_clone/models/post.dart';
import 'package:threddit_clone/theme/theme.dart';
import 'package:video_player/video_player.dart';

class PostClassic extends ConsumerStatefulWidget {
  const PostClassic({super.key, required this.post});
  final Post post;

  @override
  ConsumerState<PostClassic> createState() => _PostClassicState();
}

class _PostClassicState extends ConsumerState<PostClassic> {
  late VideoPlayerController _controller;

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
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(widget.post.postedTime);
    final hoursSincePost = difference.inHours;
    String communityImage = '';
    if (widget.post.community != null) {
      final communityAsyncValue =
          ref.watch(fetchcommunityProvider(widget.post.community!));
      communityAsyncValue.whenData((community) {
        communityImage = community.srLooks.icon!;
      });
    }
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: AppColors.whiteHideColor),
        color: AppColors.backgroundColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    children: widget.post.community == null
                        ? [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundImage: AssetImage(
                                    'assets/images/Default_Avatar.png'),
                              ),
                            ),
                            Text(
                              'u/${widget.post.userID}',
                              style: AppTextStyles.primaryTextStyle.copyWith(
                                  fontSize: 12,
                                  color: AppColors.whiteHideColor),
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
                          ]
                        : [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundImage: NetworkImage(communityImage),
                              ),
                            ),
                            Text(
                              'r/${widget.post.community}',
                              style: AppTextStyles.primaryTextStyle.copyWith(
                                  fontSize: 12,
                                  color: AppColors.whiteHideColor),
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
                          ]),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: SizedBox(
                    width: 250,
                    child: Text(
                      widget.post.title,
                      style: AppTextStyles.primaryTextStyle.copyWith(
                          color: const Color.fromARGB(238, 255, 255, 255),
                          fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.post.video != null || widget.post.image != null)
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: widget.post.image != null
                        ? Image(image: NetworkImage(widget.post.image!))
                        : _controller.value.isInitialized
                            ? GestureDetector(
                                onTap: () {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                  setState(() {});
                                },
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
                              )
                            : const Loading(),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
