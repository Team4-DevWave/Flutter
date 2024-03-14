import 'package:flutter/material.dart';
import 'package:threddit_app/features/commenting/model/comment.dart';
import 'package:threddit_app/features/commenting/view/widgets/comment_item.dart';
import 'package:threddit_app/features/posting/data/data.dart';
import 'package:threddit_app/features/posting/model/post.dart';
import 'package:threddit_app/features/posting/view/widgets/post_card.dart';
import 'package:threddit_app/theme/colors.dart';

class PostScreen extends StatelessWidget {
  PostScreen({super.key});
  final Post currentPost = posts[0];
  final Comment currentComment =comments[0];
  @override
  Widget build(BuildContext context) {
    currentPost.addComment(currentComment);
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
                  IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
                  const CircleAvatar(
                    radius: 18,
                  ),
                  const SizedBox(width: 5)
                ],
              ),
            ],
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

            ],
          ),
          bottomNavigationBar: BottomAppBar(
            height: 60,
            color: AppColors.backgroundColor,
            child: GestureDetector(
              child: const TextField(
                decoration: InputDecoration(
                    labelText: 'Add a comment',
                    labelStyle: TextStyle(color: Color.fromARGB(171, 255, 255, 255)),
                    filled: true,
                    fillColor: Color.fromARGB(212, 87, 87, 87)),
              ),
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }
}
