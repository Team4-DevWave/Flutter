import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/models/message.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:threddit_clone/features/user_system/view/widgets/utils.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final String uid;
  final Message message;
  const MessageScreen({super.key, required this.uid, required this.message});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
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
      child: Scaffold(
        backgroundColor: const Color.fromARGB(199, 10, 10, 10),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Consumer(builder: (context, watch, child) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(19, 19, 19, 1),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(widget.message.subject,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16))
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.message.from.username,
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(116, 255, 255, 255)),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0.w),
                                  child: Icon(
                                    Icons.circle,
                                    color:
                                        const Color.fromARGB(60, 255, 255, 255),
                                    size: 4.sp,
                                  ),
                                ),
                                Text("${hoursSincePost.toString()}h",
                                    style: const TextStyle(
                                        color: Color.fromARGB(
                                            116, 255, 255, 255))),
                                const Spacer(),
                                if (widget.message.from.id != widget.uid ||
                                    widget.message.to.id != widget.uid)
                                  IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          backgroundColor:
                                              AppColors.backgroundColor,
                                          builder: (context) {
                                            return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  GestureDetector(
                                                    child: ListTile(
                                                      title: const Text(
                                                        "Block account",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      leading: const Icon(
                                                          Icons.block),
                                                      onTap: () {
                                                        blockUser(
                                                          userToBlock: widget
                                                              .message
                                                              .from
                                                              .username,
                                                          context: context,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    child: ListTile(
                                                      title: const Text(
                                                        "Report",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      leading: const Icon(
                                                          Icons.flag_outlined),
                                                      onTap: () {
                                                        //report user
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: FilledButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      style: FilledButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                55, 55, 55),
                                                        foregroundColor:
                                                            const Color
                                                                .fromARGB(123,
                                                                255, 255, 255),
                                                      ),
                                                      child:
                                                          const Text("Close"),
                                                    ),
                                                  )
                                                ]);
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.more_horiz,
                                      color: Color.fromARGB(116, 255, 255, 255),
                                    ),
                                  )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0.h),
                              child: Row(
                                children: [
                                  Text(widget.message.message,
                                      style:
                                          const TextStyle(color: Colors.white))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
