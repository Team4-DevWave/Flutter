import 'package:flutter/material.dart';
import 'package:threddit_app/features/commenting/model/comment.dart';
import 'package:threddit_app/features/commenting/view/widgets/add_comment.dart';
import 'package:threddit_app/features/commenting/view/widgets/comment_item.dart';
import 'package:threddit_app/features/posting/data/data.dart';
import 'package:threddit_app/features/posting/model/post.dart';
import 'package:threddit_app/features/posting/view/widgets/post_card.dart';
import 'package:threddit_app/theme/colors.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late Post currentPost;
  late Comment currentComment;

  @override
  void initState() {
    super.initState();
    currentPost = posts[0];
    currentComment = comments[0];
    currentPost.addComment(currentComment);
  }

  void _openAddCommentOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => const AddComment());
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
              onPressed: () {},
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
                  Builder( // Use Builder to obtain a Scaffold's context
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
              children: <Widget>[
              ],
            ),
      
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    PostCard(post: currentPost),
                    const Padding(padding: EdgeInsets.only(bottom: 8)),
                    for (var comment in currentPost.comments)
                      CommentItem(comment: comment),
                  ],
                ),
              ),
              AddComment()
            ],
          ),

          // bottomNavigationBar: BottomAppBar(
          //   height: 60,
          //   color: AppColors.backgroundColor,
          //   child: Container(
          //     alignment: Alignment.center,
          //     child: TextField(
          //       onTap: _openAddCommentOverlay,
          //       decoration: const InputDecoration(
          //         labelText: 'Add a comment',
          //         labelStyle:
          //             TextStyle(color: Color.fromARGB(171, 255, 255, 255)),
          //         filled: true,
          //         fillColor: Color.fromARGB(212, 87, 87, 87),
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
