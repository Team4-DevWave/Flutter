import 'package:flutter/material.dart';
import 'package:threddit_app/models/comment.dart';
import 'package:threddit_app/theme/colors.dart';
import 'package:threddit_app/theme/text_styles.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({super.key, required this.comment});
  final Comment comment;
  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(widget.comment.createdAt);
    final hoursSincePost = difference.inHours;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Padding(
                    padding:EdgeInsets.only(right: 10.0),
                    child:  CircleAvatar(
                      radius: 18,
                    ),
                  ),
                  Text(
                    widget.comment.username,
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
                widget.comment.text,
                style: AppTextStyles.primaryTextStyle
                    .copyWith(color: Colors.white, fontSize: 15),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz_outlined)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.reply_outlined)),
                  IconButton(onPressed: (){}, icon:const Icon (Icons.arrow_upward_outlined, size: 30,) ),
                    Text('${widget.comment.upvotes.length-widget.comment.downvotes.length==0?"vote":widget.comment.upvotes.length-widget.comment.downvotes.length}',style: AppTextStyles.primaryTextStyle.copyWith(color: AppColors.whiteColor),),
                    IconButton(onPressed: (){}, icon:const Icon (Icons.arrow_downward_outlined, size: 30,) ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
