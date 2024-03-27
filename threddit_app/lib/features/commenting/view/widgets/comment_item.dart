import 'package:flutter/material.dart';
import 'package:threddit_clone/features/commenting/view_model/comment_provider.dart';
import 'package:threddit_clone/features/commenting/model/comment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

class CommentItem extends ConsumerStatefulWidget {
  const CommentItem({super.key, required this.comment, required this.uid});
  final Comment comment;
  final String uid;
  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends ConsumerState<CommentItem> {
  @override
  Widget build(BuildContext context) {
    void upVotePost(WidgetRef ref) async {
      final upvoteFunction = ref.read(commentUpvoteProvider(widget.comment));
      upvoteFunction(widget.uid);
      setState(() {});
    }

    void downVotePost(WidgetRef ref) async {
      final downvoteFunction =
          ref.read(commentDownvoteProvider(widget.comment));
      downvoteFunction(widget.uid);
      setState(() {});
    }

    final now = DateTime.now();
    final difference = now.difference(widget.comment.createdAt);
    final hoursSincePost = difference.inHours;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: CircleAvatar(
                      radius: 18,
                    ),
                  ),
                  Text(
                    widget.comment.username,
                    style: AppTextStyles.primaryTextStyle.copyWith(
                      color: const Color.fromARGB(114, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(width: 5),
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
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.comment.text,
                style: AppTextStyles.primaryTextStyle
                    .copyWith(color: Colors.white, fontSize: 15),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.more_horiz_outlined)),
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.reply_outlined)),
                  IconButton(
                    onPressed: () {
                      upVotePost(ref);
                    },
                    icon: const Icon(
                      Icons.arrow_upward_outlined,
                      size: 30,
                    ),
                    color: widget.comment.upvotes.contains(widget.uid)
                        ? const Color.fromARGB(255, 217, 77, 67)
                        : Colors.white,
                  ),
                  Text(
                    '${widget.comment.upvotes.length - widget.comment.downvotes.length == 0 ? "vote" : widget.comment.upvotes.length - widget.comment.downvotes.length}',
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
                    color: widget.comment.downvotes.contains(widget.uid)
                        ? Color.fromARGB(255, 97, 137, 212)
                        : Colors.white,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
