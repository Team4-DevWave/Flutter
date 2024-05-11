import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:threddit_clone/features/chatting/model/chat_message_model.dart';
import 'package:threddit_clone/features/chatting/model/chat_notifier.dart';
import 'package:threddit_clone/features/reporting/view/report_bottom_sheet.dart';
import 'package:threddit_clone/theme/colors.dart';

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

class ChatItem extends ConsumerStatefulWidget {
  const ChatItem({super.key, required this.message, required this.username});
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

  void deleteMessagefn(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 10, 10, 10),
          title: const Text(
            "Delete this message?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "It will be removed for everyone in the chat",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: FilledButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                )),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevent dialog from being dismissed
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('deleting message..'),
                        ],
                      ),
                    );
                  },
                );
                try {
                  await ref
                      .read(chatNotifierProvider.notifier)
                      .deleteMessage(widget.message.id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                } catch (e) {
                  // Handle error
                  print('Error deleting message: $e');
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          showDragHandle: true,
          scrollControlDisabledMaxHeightRatio: double.infinity,
          backgroundColor: const Color.fromARGB(255, 10, 10, 10),
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                widget.username == widget.message.sender.username
                    ? ListTile(
                        leading: const Icon(Icons.delete, color: Colors.white),
                        title: const Text(
                          "Delete Message",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          deleteMessagefn(context);
                        },
                      )
                    : ListTile(
                        leading: const Icon(Icons.report, color: Colors.white),
                        title: const Text(
                          "Report Message",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          showModalBottomSheet(
                            useSafeArea: true,
                            isScrollControlled: true,
                            context: context,
                            backgroundColor: AppColors.backgroundColor,
                            builder: (context) {
                              return ReportBottomSheet(
                                userID: widget.username,
                                reportedID: widget.message.id,
                                type: "chat",
                              );
                            },
                          );
                        },
                      ),
              ]),
            );
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.all(8.0.sp),
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: 5.0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.message.sender.profilePicture != null &&
                          widget.message.sender.profilePicture != ''
                      ? CircleAvatar(
                          radius: 25.0,
                          backgroundColor:
                              const Color.fromARGB(255, 229, 194, 99),
                          backgroundImage: NetworkImage(
                              widget.message.sender.profilePicture!),
                        )
                      : const CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Color.fromARGB(255, 229, 194, 99),
                          backgroundImage:
                              AssetImage('assets/images/Default_Avatar.png'),
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
      ),
    );
  }
}
