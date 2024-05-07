import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/commenting/view/widgets/comment_item.dart';
import 'package:threddit_clone/features/commenting/view/widgets/add_comment.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer.dart';
import 'package:threddit_clone/features/posting/view/widgets/shared_post_card.dart';
import 'package:threddit_clone/features/posting/view/widgets/bottom_sheet_owner.dart';
import 'package:threddit_clone/features/posting/view/widgets/options_bottom%20sheet.dart';
import 'package:threddit_clone/features/posting/view_model/history_manager.dart';
import 'package:threddit_clone/features/posting/view_model/post_provider.dart';
import 'package:threddit_clone/features/posting/view/widgets/post_card.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/features/commenting/model/comment_notifier.dart';

/// This widget displays the post screen
/// It displays the post and all the comments on the post
/// it also displays the add comment widget
/// it calls either the standard post card or the shared post card based on whether the post has a parent post or not

class PostScreen extends ConsumerStatefulWidget {
  final String uid;
  final Post currentPost;
  const PostScreen({super.key, required this.uid, required this.currentPost});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  @override
  void initState() {
    super.initState();
   ref.read(commentsProvider.notifier).fetchComments(widget.currentPost.id);
    HistoryManager.addPostToHistory(widget.currentPost);
    print(widget.currentPost.id);
  }

  void _openAddCommentOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => AddComment(
              postID: widget.currentPost.id,
              uid: widget.uid,
            ));
  }

  @override
  Widget build(BuildContext context) {
    
    void toggleNsfw() async {
      ref.read(toggleNSFW(widget.currentPost.id));
      widget.currentPost.nsfw = !widget.currentPost.nsfw;
      Navigator.pop(context);
      setstate() {}
    }

    void toggleSPOILER() async {
      ref.read(toggleSpoiler(widget.currentPost.id));
      widget.currentPost.spoiler = !widget.currentPost.spoiler;
      Navigator.pop(context);
      setstate() {}
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(199, 10, 10, 10),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          backgroundColor: AppColors.backgroundColor,
                          builder: (context) {
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    widget.currentPost.userID!.id != widget.uid
                                        ? [
                                            OptionsBotttomSheet(
                                                post: widget.currentPost,
                                                toggleSPOILER: toggleSPOILER,
                                                toggleNsfw: toggleNsfw,
                                                uid: widget.uid)
                                          ]
                                        : [
                                            ModeratorBotttomSheet(
                                                post: widget.currentPost,
                                                toggleSPOILER: toggleSPOILER,
                                                toggleNsfw: toggleNsfw)
                                          ]);
                          });
                    },
                    icon: const Icon(Icons.more_horiz)),
                Builder(
                  // Use Builder to obtain a Scaffold's context
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
                SizedBox(width: 5.w)
              ],
            ),
          ],
        ),
        endDrawer: const RightDrawer(),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  widget.currentPost.parentPost == null
                      ? PostCard(
                          post: widget.currentPost,
                          uid: widget.uid,
                        )
                      : SharedPostCard(
                          post: widget.currentPost,
                          uid: widget.uid,
                        ),
                  Consumer(
                    builder: (context, watch, child) {
                      final comments = ref.watch(commentsProvider);
                      return Column(
                        children: comments.map((comment) {
                          return CommentItem(comment: comment,uid:widget.uid);
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            AddComment(
              postID: widget.currentPost.id,
              uid: widget.uid,
            )
          ],
        ),
      ),
    );
  }
}
