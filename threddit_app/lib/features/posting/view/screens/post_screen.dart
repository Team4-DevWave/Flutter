import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:threddit_clone/features/commenting/view/widgets/comment_item.dart';
import 'package:threddit_clone/features/commenting/model/comment.dart';
import 'package:threddit_clone/features/commenting/view/widgets/add_comment.dart';
import 'package:threddit_clone/features/posting/data/data.dart';
import 'package:threddit_clone/features/commenting/model/post.dart';
import 'package:threddit_clone/features/posting/view/widgets/post_card.dart';
import 'package:threddit_clone/theme/colors.dart';

class PostScreen extends ConsumerStatefulWidget {
  final Post currentPost;
  const PostScreen({super.key, required this.currentPost});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _openAddCommentOverlay() {
    // showModalBottomSheet(
    //     useSafeArea: true,
    //     isScrollControlled: true,
    //     context: context,
    //     builder: (ctx) => AddComment(
    //           postID: widget.currentPost.id,
    //           uid: 'user1',
    //         ));
  }

  @override
  Widget build(BuildContext context) {
    List<Comment> postComments = comments
        .where((comment) => comment.postId == widget.currentPost.id)
        .toList();
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(199, 10, 10, 10),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
                    onPressed: () {}, icon: const Icon(Icons.more_horiz)),
                Builder(
                  // Use Builder to obtain a Scaffold's context
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.face_2_rounded),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
                const SizedBox(width: 5)
              ],
            ),
          ],
        ),
        endDrawer: Drawer(
          backgroundColor: AppColors.backgroundColor,
          width: 330,
          child: ListView(
            padding: EdgeInsets.zero,
            children: const <Widget>[],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  PostCard(
                    post: widget.currentPost,
                    uid: 'user1',
                    onCommentPressed: _openAddCommentOverlay,
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 8)),
                  ...postComments.map((comment) => CommentItem(
                        comment: comment,
                        uid: 'user1',
                      )),
                ],
              ),
            ),
            AddComment(
              postID: widget.currentPost.id,
              uid: 'user1',
            )
          ],
        ),
      ),
    );
  }
}
