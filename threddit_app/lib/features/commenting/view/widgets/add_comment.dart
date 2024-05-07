import 'package:flutter/material.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/commenting/model/comment_notifier.dart';
import 'package:threddit_clone/features/home_page/model/newpost_model.dart';
import 'package:threddit_clone/features/user_system/model/user_model_me.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///this widget is composed of the text field that is used to add a comment to a post and the send button that is used to send the comment
///the add comment function is called when the send button is pressed and the comment is added to the post
///the comment is added to the post by calling the addComment function from the comment provider
///the addComment function takes the post ID, the content of the comment and the user ID as it's parameters
///the addComment function returns a Future that is used to add the comment to the post
///the comment controller is used to get the content of the comment that is being added to the post

class AddComment extends ConsumerStatefulWidget {
  const AddComment({super.key, required this.post, required this.uid});
  final String uid;
  final Post post;
  @override
  ConsumerState<AddComment> createState() {
    return _AddComment();
  }
}

class _AddComment extends ConsumerState<AddComment> {
  final _commentController = TextEditingController();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  void addComment(WidgetRef ref) async {
     String username = ref.read(userModelProvider)!.username!;
    ref.read(commentsProvider.notifier).addComment(widget.post.id, _commentController.text,username);
    
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return Container(
          color: AppColors.backgroundColor,
          height: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: navigatorKey,
                          controller: _commentController,
                          onTap: () {},
                          decoration: const InputDecoration(
                            hintText: 'Add a comment',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(171, 255, 255, 255),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(212, 87, 87, 87),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          addComment(ref);
                          
                          setState(() {
                            _commentController.clear();
                           FocusScope.of(context).unfocus();
                          });
                        },
                        icon: const Icon(Icons.send),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
