import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/home_page/view_model/saved_post.dart';

import 'package:threddit_clone/features/searching/model/search_comment_model.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_post_feed_widget.dart';
import 'package:threddit_clone/features/searching/view/widgets/search_shared_feed_unit.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';

///this class is used to display a single comment in the comments section of a post
///it displays the user's avatar, username, the content of the comment, the time since the comment was posted, the number of upvotes and downvotes on the comment
///it also displays the options to save, copy, report, block and collapse the comment (bottom sheet)
///it handles most of the operations related to a comment like upvoting, downvoting, saving, copying, reporting, blocking and collapsing the comment
///it also handles the editing and deleting of a comment

class SearchCommentItem extends ConsumerStatefulWidget {
  const SearchCommentItem(
      {super.key,
      required this.comment,
      required this.uid,
      required this.parentPost});
  final SearchCommentModel comment;
  final String uid;
  final Post? parentPost;
  @override
  _SearchCommentItemState createState() => _SearchCommentItemState();
}

class _SearchCommentItemState extends ConsumerState<SearchCommentItem> {
  late TextEditingController _commentController;

  bool _isLoading = false;
  bool _isSaved = false;
  void _setVariables() async {
    setState(() {
      _isLoading = true;
    });
    final response =
        await ref.read(savecommentProvider.notifier).isSaved(widget.comment.id);
    response.fold(
        (l) => showSnackBar(
            navigatorKey.currentContext!, "Could not retrieve saved state"),
        (success) {
      setState(() {
        _isSaved = success;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _setVariables();
    _commentController = TextEditingController(text: widget.comment.content);
  }

  @override
  Widget build(BuildContext context) {
    // Function to delete the comment
    // void deleteComment() {
    //   ref.watch(deleteCommentProvider(
    //       (postId: widget.comment.post, commentId: widget.comment.id)));
    // }

    final now = DateTime.now();
    final difference = now.difference(widget.comment.createdAt);
    final hoursSincePost = difference.inHours;

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
            child: Builder(builder: (context) {
              if (widget.comment.post != null) {
                return ListTile(
                    title: widget.comment.post!.parentPost != null
                        ? SearchFeedUnitShare(
                            dataOfPost: widget.comment.post!.parentPost!,
                            parentPost: widget.comment.post!,
                            widget.uid!)
                        : SearchFeedUnit(widget.comment.post!, widget.uid!),
                    subtitle: Container(
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(20.w),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.redditOrangeColor,
                            blurRadius: 4,
                            offset: Offset(-4, 8), // Shadow position
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteClass.postScreen,
                          arguments: {
                            'currentpost': widget.comment.post,
                            'uid': widget.uid,
                          },
                        ),
                        contentPadding: const EdgeInsets.all(0),
                        title: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(
                                    'assets/images/Default_Avatar.png'),
                              ),
                            ),
                            Text(
                              widget.comment.user.username,
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
                        subtitle: Container(
                          padding: EdgeInsets.only(top: 10.h, left: 25.w),
                          child: Text(
                            widget.comment.content,
                            style: AppTextStyles.primaryTextStyle
                                .copyWith(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ));
              } else {
                return ListTile(
                  title: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage:
                              AssetImage('assets/images/Default_Avatar.png'),
                        ),
                      ),
                      Text(
                        widget.comment.user.username,
                        style: AppTextStyles.primaryTextStyle.copyWith(
                          color: const Color.fromARGB(114, 255, 255, 255),
                        ),
                      ),
                      //const SizedBox(width: 5),
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
                  subtitle: Container(
                    padding: EdgeInsets.only(top: 10.h, left: 25.w),
                    child: Text(
                      widget.comment.content,
                      style: AppTextStyles.primaryTextStyle
                          .copyWith(color: Colors.white, fontSize: 15),
                    ),
                  ),
                );
              }
            })),
      ),
    );
  }
}
