import 'package:flutter/material.dart';
import 'package:threddit_clone/features/commenting/view_model/comment_provider.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddComment extends ConsumerStatefulWidget {
  const AddComment({super.key, required this.postID, required this.uid});
  final String uid;
  final String postID;
  @override
  ConsumerState<AddComment> createState() {
    return _AddComment();
  }
}

class _AddComment extends ConsumerState<AddComment> {
  final _commentController = TextEditingController();

  void addComment(WidgetRef ref) async {
    final addCommentFuture = ref.read(addCommentProvider(
        [_commentController.text, widget.postID, widget.uid]));
    await addCommentFuture;
    setState(() {});
    //Navigator.pop(context); // Close the bottom sheet after adding the comment
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

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
                        },
                        icon: Icon(Icons.send),
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
