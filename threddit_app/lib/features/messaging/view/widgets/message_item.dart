import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/models/message.dart';
import 'package:threddit_clone/theme/colors.dart';

class MessageItem extends ConsumerStatefulWidget {
  const MessageItem({super.key, required this.message, required this.uid});
  final Message message;
  final String uid;
  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends ConsumerState<MessageItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(widget.message.createdAt);
    final hoursSincePost = difference.inHours;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(widget.message.from.username,style: const TextStyle(color:Color.fromARGB(55, 255, 255, 255) ),),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      child: Icon(Icons.circle,color: const Color.fromARGB(60, 255, 255, 255),size: 4.sp,),
                    ),
                    Text("$hoursSincePost h",style: const TextStyle(color:Color.fromARGB(55, 255, 255, 255) )),
                  ],
                ),
                Row(
                  children: [Text(widget.message.subject,style: const TextStyle(color:Color.fromARGB(55, 255, 255, 255) ))],
                ),
                Row(
                  children: [Text(widget.message.message,style: const TextStyle(color:Color.fromARGB(55, 255, 255, 255) ))],
                )

              ],
            )),
      ),
    );
  }
}
