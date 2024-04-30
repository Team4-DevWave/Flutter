import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:threddit_clone/features/chatting/model/chat_message_model.dart';
String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays == 0) {
   
    return DateFormat('HH:mm').format(dateTime);
  } else {
    
    return DateFormat('yMMMEd').format(dateTime);
  }
}
class ChatItem extends ConsumerStatefulWidget {
  const ChatItem({super.key,required this.message,required this.username});
  final ChatMessage message;
  final String username;
  @override
  // ignore: library_private_types_in_public_api
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends ConsumerState<ChatItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom:5.0.h),
              child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 25.0,
            backgroundColor: Color.fromARGB(255, 229, 194, 99),
            backgroundImage: AssetImage('assets/images/Default_Avatar.png'),
          ),
         SizedBox(width: 8.0.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.sender.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0.h),
                Text(
                  widget.message.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatDateTime(DateTime.parse(widget.message.dateSent)),
            style: const TextStyle(
              color: Color.fromARGB(135, 255, 255, 255),
              fontSize: 10,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
            )),
      );
  }
}
