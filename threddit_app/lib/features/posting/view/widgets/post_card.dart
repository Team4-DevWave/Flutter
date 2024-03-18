import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_app/features/posting/view_model/post_provider.dart';
import 'package:threddit_app/features/commenting/model/post.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';

class PostCard extends ConsumerStatefulWidget {
  const PostCard(
      {Key? key,
      required this.post,
      required this.uid,
      required this.onCommentPressed});
  final Post post;
  final String uid;
  final VoidCallback onCommentPressed;
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  @override
  Widget build(BuildContext context) {
    void upVotePost(WidgetRef ref) async {
      final upvoteFunction = ref.read(postUpvoteProvider(widget.post));
      upvoteFunction(widget.uid);
      setState(() {});
    }

    void downVotePost(WidgetRef ref) async {
      final downvoteFunction = ref.read(postDownvoteProvider(widget.post));
      downvoteFunction(widget.uid);
      setState(() {});
    }

    final isTypeImage = widget.post.type == 'image';
    final isTypeText = widget.post.type == 'text';
    final isTypeLink = widget.post.type == 'link';

    final now = DateTime.now();
    final createdAt = widget.post.createdAt ?? now;
    final difference = now.difference(widget.post.createdAt);
    final hoursSincePost = difference.inHours;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
      ),
      //padding: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(
                    radius: 16,
                  ),
                ),
                //Image.asset(Photos.defaultavatar,width: 16,height: 16,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('r/${widget.post.communityName}',
                        style: AppTextStyles.primaryTextStyle.copyWith(
                            fontSize: 12,
                            color: const Color.fromARGB(98, 255, 255, 255),
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text(
                          'u/${widget.post.username}',
                          style: AppTextStyles.primaryTextStyle.copyWith(
                              fontSize: 12,
                              color: const Color.fromARGB(206, 20, 113, 190)),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: Text(
                widget.post.title,
                style: AppTextStyles.primaryTextStyle.copyWith(
                    color: const Color.fromARGB(238, 255, 255, 255),
                    fontSize: 18),
              ),
            ),
            if (widget.post.description != null)
              Text(
                widget.post.description!,
                style: AppTextStyles.primaryTextStyle.copyWith(
                    color: const Color.fromARGB(196, 255, 255, 255),
                    fontSize: 15),
              ),
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
                  color: widget.post.upvotes.contains(widget.uid)
                      ? const Color.fromARGB(255, 217, 77, 67)
                      : Colors.white,
                ),
                Text(
                  '${widget.post.upvotes.length - widget.post.downvotes.length == 0 ? "vote" : widget.post.upvotes.length - widget.post.downvotes.length}',
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
                  color: widget.post.downvotes.contains(widget.uid)
                      ? Color.fromARGB(255, 97, 137, 212)
                      : Colors.white,
                ),
                IconButton(
                    onPressed: widget.onCommentPressed,
                    icon: const Icon(Icons.comment)),
                Text(
                    '${widget.post.commentCount == 0 ? "comment" : widget.post.commentCount}',
                    style: AppTextStyles.primaryTextStyle
                        .copyWith(color: AppColors.whiteColor)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.uid == widget.post.uid)
                        IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                      if (widget.uid != widget.post.uid)
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.refresh))
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
