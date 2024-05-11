import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/models/comment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///this class is used to display a single comment in the comments section of a post
///it displays the user's avatar, username, the content of the comment, the time since the comment was posted, the number of upvotes and downvotes on the comment
///it also displays the options to save, copy, report, block and collapse the comment (bottom sheet)
///it handles most of the operations related to a comment like upvoting, downvoting, saving, copying, reporting, blocking and collapsing the comment
///it also handles the editing and deleting of a comment

class CommentItemForProfile extends ConsumerStatefulWidget {
  const CommentItemForProfile(
      {super.key, required this.comment, required this.uid});
  final Comment comment;
  final String uid;
  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends ConsumerState<CommentItemForProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'u/' + widget.comment.user.username,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Text(
                    "${DateTime.now().difference(widget.comment.createdAt).inHours}h",
                    style: TextStyle(
                        color: const Color.fromARGB(120, 255, 255, 255),
                        fontSize: 12.sp),
                  )
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                widget.comment.content,
                style: TextStyle(
                    color: Color.fromARGB(188, 255, 255, 255), fontSize: 15.sp),
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                children: [
                  Text(
                    "number of votes : ${widget.comment.votes.upvotes - widget.comment.votes.downvotes}",
                    style: TextStyle(
                        color: Color.fromARGB(160, 255, 255, 255),
                        fontSize: 14.sp),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Icon(Icons.arrow_upward,
                      color: Color.fromARGB(160, 255, 255, 255)),
                ],
              ),
              Divider(
                color: const Color.fromARGB(255, 50, 50, 50),
                thickness: 1.h,
              )
            ],
          ),
          // TextButton(
          //   onPressed: () {

          //   },
          //   child: Text(
          //     'View Post',
          //     style: TextStyle(color: Colors.white, fontSize: 16.sp),
          //   ),
          // )
        ],
      ),
    );
  }
}
