import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/commenting/view/widgets/comment_item.dart';
import 'package:threddit_clone/features/commenting/view/widgets/add_comment.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer.dart';
import 'package:threddit_clone/features/reporting/view/report_bottom_sheet.dart';
import 'package:threddit_clone/features/posting/view/widgets/post_card.dart';
import 'package:threddit_clone/models/comment.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/features/commenting/view_model/comment_provider.dart';

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
                          context: context,
                          backgroundColor: AppColors.backgroundColor,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: widget.currentPost.userID != widget.uid
                                  ? [
                                      ListTile(
                                          title: const Text(
                                            'More actions...',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          }),
                                      ListTile(
                                        title: const Text(
                                          'Subscribe to post',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading:
                                            const Icon(Icons.notifications),
                                        onTap: () {},
                                      ),
                                      ListTile(
                                        title: const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: const Icon(Icons.save),
                                        onTap: () {},
                                      ),
                                      ListTile(
                                        title: const Text(
                                          'Copy text',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: const Icon(Icons.copy),
                                        onTap: () {},
                                      ),
                                      ListTile(
                                        title: const Text(
                                          'Report',
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                        leading: const Icon(
                                          Icons.flag_outlined,
                                          color: Colors.orange,
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
                                                userID: widget.uid,
                                                reportedID:
                                                    widget.currentPost.id,
                                                type: "post",
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      ListTile(
                                        title: const Text(
                                          'Block account',
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                        leading: const Icon(
                                          Icons.block,
                                          color: Colors.orange,
                                        ),
                                        onTap: () {},
                                      ),
                                      ListTile(
                                        title: const Text(
                                          'Hide',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: const Icon(Icons.hide_source),
                                        onTap: () {},
                                      )
                                    ]
                                  : <Widget>[
                                      ListTile(
                                          title: const Text(
                                            'More actions...',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          }),
                                      ListTile(
                                        title: const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: const Icon(Icons.save),
                                        onTap: () {},
                                      ),
                                      ListTile(
                                        title: const Text(
                                          'Copy text',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: const Icon(Icons.copy),
                                        onTap: () {},
                                      ),
                                      ListTile(
                                        title: Text(
                                          widget.currentPost.spoiler
                                              ? 'UnMark Spoiler'
                                              : "Mark Spoiler",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: const Icon(
                                            Icons.warning_amber_rounded),
                                        onTap: () {},
                                      ),
                                      ListTile(
                                        title: Text(
                                          widget.currentPost.nsfw
                                              ? 'UnMark NSFW'
                                              : "Mark NSFW",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading: const Icon(Icons.eighteen_mp),
                                        onTap: () {},
                                      ),
                                      ListTile(
                                        title: const Text(
                                          "Delete post",
                                          style:
                                              TextStyle(color: Colors.orange),
                                        ),
                                        leading: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.orange,
                                        ),
                                        onTap: () {},
                                      ),
                                      ListTile(
                                        title: const Text(
                                          "Crosspost to community",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        leading:
                                            const Icon(Icons.share_outlined),
                                        onTap: () {},
                                      ),
                                    ],
                            );
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
                const SizedBox(width: 5)
              ],
            ),
          ],
        ),
        endDrawer: const RightDrawer(),
        body: Column(
          children: [
            Expanded(
              child: ListView(children:[
              PostCard(
                    post: widget.currentPost,
                    uid: widget.uid,
                    onCommentPressed: _openAddCommentOverlay,
                  ),
                  Consumer(
                builder: (context, watch, child) {
                  final AsyncValue<List<Comment>> postComments =
                      ref.watch(commentsProvider((widget.currentPost.id)));
                  return postComments.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) =>
                        Center(child: Text('Error: $error')),
                    data: (comments) {
                      return Column(
                        children: [
                           const Padding(
                                    padding: EdgeInsets.only(bottom: 8)),
                                if (comments.isNotEmpty)
                                  ...comments
                                      .map((comment) => CommentItem(
                                            comment: comment,
                                            uid: widget.uid,
                                          ))
                                      .toList(),
                        ],
                      );
                    }
                  );
                }
                  )
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
