import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/commenting/view_model/comment_provider.dart';

import 'package:threddit_clone/features/posting/view_model/post_provider.dart';
import 'package:threddit_clone/features/reporting/view/report_bottom_sheet.dart';
import 'package:threddit_clone/models/comment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/models/votes.dart';
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
  late TextEditingController _commentController;
  late AsyncValue<Votes> upvotes;
  late AsyncValue<Votes> downvotes;
  bool upVoted = false;
  bool downVoted = false;
  @override
  void initState() {
    super.initState();
    upvotes = ref.read(getUserUpvotesProvider);
    downvotes = ref.read(getUserDownvotesProvider);
    _commentController = TextEditingController(text: widget.comment.content);
  }

  void upVoteComment(WidgetRef ref) async {
    ref.read(commentVoteProvider((commentID: widget.comment.id, voteType: 1)));
    if (upVoted) {
      widget.comment.votes.upvotes--;
    } else {
      widget.comment.votes.upvotes++;
      if (downVoted) {
        widget.comment.votes.downvotes--;
      }
    }
    upVoted = !upVoted;
    downVoted = false;
    setState(() {});
  }

  void downVoteComment(WidgetRef ref) async {
    ref.read(commentVoteProvider((commentID: widget.comment.id, voteType: -1)));
    if (downVoted) {
      widget.comment.votes.downvotes--;
    } else {
      widget.comment.votes.downvotes++;
      if (upVoted) {
        widget.comment.votes.upvotes--;
      }
    }
    downVoted = !downVoted;
    upVoted = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool upvoteStatus = upvotes.maybeWhen(
      data: (votes) {
        upVoted = true;
        return votes.containsComment(widget.comment.id);
      },
      orElse: () {
        return false;
      },
    );

    bool downvoteStatus = downvotes.maybeWhen(
      data: (votes) => votes.containsComment(widget.comment.id),
      orElse: () {
        downVoted = false;
        return false;
      },
    );

    // Function to delete the comment
    void deleteComment() {
      ref.watch(deleteCommentProvider(
          (postId: widget.comment.post, commentId: widget.comment.id)));
    }

    Future<void> showDeleteConfirmationDialog(BuildContext context) async {
      return showDialog<void>(
        context: context,
        barrierDismissible:
            false, // Prevent user from dismissing dialog by tapping outside
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColors.backgroundColor,
            title: const Text(
              'Confirm Delete',
              style: TextStyle(color: Colors.white),
            ),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Are you sure?',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'You cannot restore comments that have been deleted.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Close the dialog and delete the comment
                  Navigator.of(context).pop();
                  deleteComment(); // Call your delete comment function here
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: const Text('Delete'),
              ),
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 43, 43, 43),
                    foregroundColor: const Color.fromARGB(112, 255, 255, 255)),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    final now = DateTime.now();
    final difference = now.difference(widget.comment.createdAt);
    final hoursSincePost = difference.inHours;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundColor,
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                      widget.comment.user,
                      style: AppTextStyles.primaryTextStyle.copyWith(
                        color: const Color.fromARGB(114, 255, 255, 255),
                      ),
                    ),
                    SizedBox(width: 5.w),
                    const Icon(
                      Icons.circle,
                      size: 4,
                      color: Color.fromARGB(98, 255, 255, 255),
                    ),
                    SizedBox(width: 10.w),
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
                  widget.comment.content,
                  style: AppTextStyles.primaryTextStyle
                      .copyWith(color: Colors.white, fontSize: 15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: AppColors.backgroundColor,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: widget.uid != widget.comment.user
                                      ? [
                                          ListTile(
                                            title: const Text(
                                              'Save',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            leading: const Icon(
                                              Icons.save,
                                              color: Colors.white,
                                            ),
                                            onTap: () {},
                                          ),
                                          ListTile(
                                            title: const Text(
                                              'Copy text',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            leading: const Icon(
                                              Icons.copy,
                                              color: Colors.white,
                                            ),
                                            onTap: () {},
                                          ),
                                          ListTile(
                                            title: const Text(
                                              'Report',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            leading: const Icon(
                                              Icons.flag_outlined,
                                              color: Colors.white,
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showModalBottomSheet(
                                                useSafeArea: true,
                                                isScrollControlled: true,
                                                context: context,
                                                backgroundColor:
                                                    AppColors.backgroundColor,
                                                builder: (context) {
                                                  return ReportBottomSheet(
                                                    reportedID:
                                                        widget.comment.id,
                                                    userID: widget.uid,
                                                    type: "comment",
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          ListTile(
                                            title: const Text(
                                              'Block account',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            leading: const Icon(
                                              Icons.block,
                                              color: Colors.white,
                                            ),
                                            onTap: () {},
                                          ),
                                          ListTile(
                                            title: const Text(
                                              'Collapse thread',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            leading: const Icon(
                                              Icons.compare_arrows_rounded,
                                              color: Colors.white,
                                            ),
                                            onTap: () {},
                                          )
                                        ]
                                      : [
                                          ListTile(
                                            title: const Text(
                                              'Save',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            leading: const Icon(
                                              Icons.save,
                                              color: Colors.white,
                                            ),
                                            onTap: () {},
                                          ),
                                          ListTile(
                                            title: const Text(
                                              'Copy text',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            leading: const Icon(
                                              Icons.copy,
                                              color: Colors.white,
                                            ),
                                            onTap: () {},
                                          ),
                                          ListTile(
                                            title: const Text(
                                              'Collapse thread',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            leading: const Icon(
                                              Icons.compare_arrows_rounded,
                                              color: Colors.white,
                                            ),
                                            onTap: () {},
                                          ),
                                          ListTile(
                                            title: const Text(
                                              'Edit',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            leading: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    AppColors.backgroundColor,
                                                showDragHandle: true,
                                                builder: (context) {
                                                  return SafeArea(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                context)
                                                            .padding
                                                            .top,
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom,
                                                      ),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom, // Adjust for keyboard
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 80,
                                                              child: TextField(
                                                                controller:
                                                                    _commentController,
                                                                maxLines: null,
                                                                expands: true,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  hintText:
                                                                      'Add a comment',
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      if (_commentController
                                                                          .text
                                                                          .isNotEmpty) {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                        ref.read(
                                                                            editCommentProvider((
                                                                          commentId: widget
                                                                              .comment
                                                                              .id,
                                                                          newContent:
                                                                              _commentController.text
                                                                        )));
                                                                      } else {
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return AlertDialog(
                                                                                title: const Text("Error"),
                                                                                content: const Text("Comment cannot be empty"),
                                                                                actions: <Widget>[
                                                                                  ElevatedButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                                                      child: const Text(
                                                                                        "Ok",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      )),
                                                                                ],
                                                                              );
                                                                            });
                                                                      }
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .blue),
                                                                    child:
                                                                        const Text(
                                                                      "Save",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          ListTile(
                                            title: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            leading: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showDeleteConfirmationDialog(
                                                  context);
                                            },
                                          )
                                        ],
                                );
                              });
                        },
                        icon: const Icon(Icons.more_horiz_outlined)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.reply_outlined)),
                    IconButton(
                      onPressed: () {
                        upVoteComment(ref);
                      },
                      icon: const Icon(
                        Icons.arrow_upward_outlined,
                        size: 30,
                      ),
                      color: upVoted ? Colors.red : Colors.white,
                    ),
                    Text(
                      '${widget.comment.votes.upvotes - widget.comment.votes.downvotes == 0 ? "vote" : widget.comment.votes.upvotes - widget.comment.votes.downvotes}',
                      style: AppTextStyles.primaryTextStyle
                          .copyWith(color: AppColors.whiteColor),
                    ),
                    IconButton(
                      onPressed: () {
                        downVoteComment(ref);
                      },
                      icon: const Icon(
                        Icons.arrow_downward_outlined,
                        size: 30,
                      ),
                      color: downVoted
                          ? const Color.fromARGB(255, 97, 137, 212)
                          : Colors.white,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
