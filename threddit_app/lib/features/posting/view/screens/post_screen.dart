import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/commenting/view/widgets/comment_item.dart';
import 'package:threddit_clone/features/commenting/view/widgets/add_comment.dart';
import 'package:threddit_clone/features/home_page/view/widgets/right_drawer.dart';
import 'package:threddit_clone/features/reporting/view/report_bottom_sheet.dart';
//import 'package:threddit_clone/models/post101.dart';
import 'package:threddit_clone/features/posting/view/widgets/post_card.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/features/commenting/view_model/comment_provider.dart';
import 'package:threddit_clone/models/post.dart';

class PostScreen extends ConsumerStatefulWidget {
  final Post currentPost;
  final String uid;
  const PostScreen({super.key, required this.currentPost, required this.uid});

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
              postID: widget.currentPost.id!,
              uid: 'user2',
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
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
                                children: <Widget>[
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
                                    leading: const Icon(Icons.notifications),
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
                                      style: TextStyle(color: Colors.orange),
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
                                            reportedID: widget.currentPost.id,
                                            type: "post",
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'Block account',
                                      style: TextStyle(color: Colors.orange),
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
          body: Consumer(
            builder: (context, watch, child) {
              var postComments =
                  ref.watch(commentsProvider(widget.currentPost.id!));
              return postComments.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error')),
                data: (postComments) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            PostCard(
                              post: widget.currentPost,
                              uid: 'user2',
                              onCommentPressed: _openAddCommentOverlay,
                            ),
                            const Padding(padding: EdgeInsets.only(bottom: 8)),
                            if (postComments != [])
                              ...postComments
                                  .map((comment) => CommentItem(
                                        comment: comment,
                                        uid: 'user2',
                                      ))
                                  .toList(),
                          ],
                        ),
                      ),
                      AddComment(
                        postID: widget.currentPost.id!,
                        uid: 'user2',
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
