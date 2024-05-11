import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/global_keys.dart';
import 'package:threddit_clone/features/commenting/model/comment_notifier.dart';
import 'package:threddit_clone/features/commenting/view_model/comment_provider.dart';
import 'package:threddit_clone/features/home_page/view_model/saved_post.dart';
import 'package:threddit_clone/features/post/viewmodel/save_post.dart';
import 'package:threddit_clone/features/posting/view/widgets/options_bottom%20sheet.dart';
import 'package:threddit_clone/features/reporting/view/report_bottom_sheet.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/models/comment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/theme/text_styles.dart';
import 'package:http/http.dart' as http;

///this class is used to display a single comment in the comments section of a post
///it displays the user's avatar, username, the content of the comment, the time since the comment was posted, the number of upvotes and downvotes on the comment
///it also displays the options to save, copy, report, block and collapse the comment (bottom sheet)
///it handles most of the operations related to a comment like upvoting, downvoting, saving, copying, reporting, blocking and collapsing the comment
///it also handles the editing and deleting of a comment

class CommentItem extends ConsumerStatefulWidget {
  const CommentItem({super.key, required this.comment, required this.uid});
  final Comment comment;
  final String uid;
  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends ConsumerState<CommentItem> {
  late TextEditingController _commentController;

  bool _isLoading = false;
  bool _isSaved = false;
  bool _isBlocked = false;

  void _setVariables() async {
    setState(() {
      _isLoading = true;
    });
    final response =
        await ref.read(savecommentProvider.notifier).isSaved(widget.comment.id);
    final isBlocked = await checkUserBlockState(widget.comment.user.id);
    response.fold(
        (l) => showSnackBar(
            navigatorKey.currentContext!, "Could not retrieve saved state"),
        (success) {
      setState(() {
        _isSaved = success;
        _isLoading = false;
        _isBlocked = isBlocked;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _setVariables();
    _commentController = TextEditingController(text: widget.comment.content);
  }

  void upVoteComment(WidgetRef ref) async {
    ref.read(commentVoteProvider((commentID: widget.comment.id, voteType: 1)));
    if (widget.comment.userVote == 'upvoted') {
      widget.comment.votes.upvotes--;
      widget.comment.userVote = 'none';
    } else if (widget.comment.userVote == 'downvoted') {
      widget.comment.votes.downvotes--;
      widget.comment.votes.upvotes++;
      widget.comment.userVote = 'upvoted';
    } else {
      widget.comment.votes.upvotes++;
      widget.comment.userVote = 'upvoted';
    }
    setState(() {});
  }

  void downVoteComment(WidgetRef ref) async {
    ref.read(commentVoteProvider((commentID: widget.comment.id, voteType: -1)));
    if (widget.comment.userVote == 'upvoted') {
      widget.comment.votes.upvotes--;
    }
    if (widget.comment.userVote == 'downvoted') {
      widget.comment.votes.downvotes--;
      widget.comment.userVote = 'none';
    } else {
      widget.comment.votes.downvotes++;
      widget.comment.userVote = 'downvoted';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Function to delete the comment
    void deleteComment() {
      ref
          .read(commentsProvider.notifier)
          .deleteComment(widget.comment.id, widget.comment.post);
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
                                  children: widget.uid != widget.comment.user.id
                                      ? [
                                          ListTile(
                                            title: Text(
                                              _isLoading
                                                  ? 'Loading...'
                                                  : (_isSaved
                                                      ? 'Unsave'
                                                      : 'Save'),
                                              style: const TextStyle(
                                                  color: AppColors.whiteColor),
                                            ),
                                            leading: Icon(
                                              Icons.save,
                                              color: _isLoading
                                                  ? AppColors.whiteHideColor
                                                  : (_isSaved
                                                      ? AppColors.whiteColor
                                                      : AppColors
                                                          .redditOrangeColor),
                                            ),
                                            onTap: () async {
                                              final saved = await ref
                                                  .watch(savecommentProvider
                                                      .notifier)
                                                  .savecommentRequest(
                                                      widget.comment.id);
                                              saved.fold(
                                                (failure) => showSnackBar(
                                                    navigatorKey
                                                        .currentContext!,
                                                    failure.message),
                                                (success) {
                                                  setState(() {
                                                    _isSaved =
                                                        !_isSaved; // Toggle the saved state
                                                  });
                                                  if (!_isSaved) {
                                                    // Check if un-saved
                                                    ref
                                                        .read(
                                                            updatesSaveProvider
                                                                .notifier)
                                                        .state = widget.comment.id;
                                                  }
                                                  Navigator.pop(context);
                                                  showSnackBar(
                                                      navigatorKey
                                                          .currentContext!,
                                                      'Comment ${_isSaved ? 'Saved' : 'Unsaved'} successfully');
                                                },
                                              );
                                            },
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
                                            title: _isBlocked
                                                ? const Text(
                                                    'Unblock account',
                                                    style: TextStyle(
                                                        color: Colors.orange),
                                                  )
                                                : const Text(
                                                    'Block account',
                                                    style: TextStyle(
                                                        color: Colors.orange),
                                                  ),
                                            leading: const Icon(
                                              Icons.block,
                                              color: Colors.orange,
                                            ),
                                            onTap: () {
                                              _isBlocked
                                                  ? unblockUser(
                                                      client: http.Client(),
                                                      userToUnBlock: widget.comment
                                                          .user.username,
                                                      context: context)
                                                  : blockUser(
                                                      userToBlock: widget.comment
                                                          .user.username,
                                                      context: context,
                                                    );
                                              _isBlocked = !_isBlocked;
                                              setState(() {});
                                            },
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
                                            title: Text(
                                              _isLoading
                                                  ? 'Loading...'
                                                  : (_isSaved
                                                      ? 'Unsave'
                                                      : 'Save'),
                                              style: const TextStyle(
                                                  color: AppColors.whiteColor),
                                            ),
                                            leading: Icon(
                                              Icons.save,
                                              color: _isLoading
                                                  ? AppColors.whiteHideColor
                                                  : (_isSaved
                                                      ? AppColors.whiteColor
                                                      : AppColors
                                                          .redditOrangeColor),
                                            ),
                                            onTap: () async {
                                              final saved = await ref
                                                  .watch(savecommentProvider
                                                      .notifier)
                                                  .savecommentRequest(
                                                      widget.comment.id);
                                              saved.fold(
                                                (failure) => showSnackBar(
                                                    navigatorKey
                                                        .currentContext!,
                                                    failure.message),
                                                (success) {
                                                  setState(() {
                                                    _isSaved =
                                                        !_isSaved; // Toggle the saved state
                                                  });
                                                  showSnackBar(
                                                      navigatorKey
                                                          .currentContext!,
                                                      'Post ${_isSaved ? 'Saved' : ''} successfully');
                                                },
                                              );
                                            },
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
                                                              height: 80.h,
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
                                                                        ref.read(commentsProvider.notifier).editComment(
                                                                            widget.comment.id,
                                                                            _commentController.text);
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
                        icon: Icon(
                          Icons.arrow_upward_outlined,
                          size: 30.spMin,
                        ),
                        color: widget.comment.userVote == 'upvoted'
                            ? Colors.red
                            : Colors.white),
                    Text(
                      '${widget.comment.votes.upvotes - widget.comment.votes.downvotes == 0 ? "vote" : widget.comment.votes.upvotes - widget.comment.votes.downvotes}',
                      style: AppTextStyles.primaryTextStyle
                          .copyWith(color: AppColors.whiteColor),
                    ),
                    IconButton(
                      onPressed: () {
                        downVoteComment(ref);
                      },
                      icon: Icon(
                        Icons.arrow_downward_outlined,
                        size: 30.spMin,
                      ),
                      color: widget.comment.userVote == 'downvoted'
                          ? Colors.blue
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
