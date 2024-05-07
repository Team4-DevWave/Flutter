import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';

String formatDateTime(DateTime messageTime) {
   DateTime now = DateTime.now();
  Duration difference = now.difference(messageTime);

  if (difference.inHours < 24) {
    // Message sent less than 24 hours ago, return time
    return DateFormat.Hm().format(messageTime); // Format: HH:mm
  } else if (difference.inHours >= 24 && difference.inHours < 48) {
    // Message sent between 24 and 48 hours ago, return 'Yesterday'
    return 'Yesterday';
  } else {
    // Message sent more than 48 hours ago, return number of days
    int daysAgo = difference.inDays;
    return '$daysAgo ${daysAgo == 1 ? 'day' : 'days'} ago';
  }
}

// ignore: must_be_immutable
class ChatPreview extends ConsumerStatefulWidget {
  ChatPreview({super.key, required this.chat,required this.username});
  Chatroom chat;
  final String username;
  @override
  // ignore: library_private_types_in_public_api
  _ChatPreviewState createState() => _ChatPreviewState();
}

class _ChatPreviewState extends ConsumerState<ChatPreview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: 5.0.h),
              child: Row(
                children: [
                 widget.chat.chatroomName!="New Chat"
                      ? const CircleAvatar(
                          radius: 23.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage('assets/images/group-avatars.png'),
                        )
                      : const CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Color.fromARGB(255, 76, 175, 172),
                          backgroundImage:
                              AssetImage('assets/images/Default_Avatar.png'),
                        ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.chat.chatroomName!="New Chat"
                              ? widget.chat.chatroomName
                              :( widget.chat.chatroomMembers[0].username!=widget.username?widget.chat.chatroomMembers[0].username:widget.chat.chatroomMembers[1].username),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.chat.latestMessage != null
                              ? '${widget.chat.latestMessage!.sender.username}: ${widget.chat.latestMessage!.message}'
                              : 'No messages yet',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (widget.chat.latestMessage != null)
                    Text(
                      formatDateTime(
                        DateTime.parse(widget.chat.latestMessage!.dateSent),
                      ),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal),
                    ),
                ],
              ),
            )),
      ),
    );
  }
}
