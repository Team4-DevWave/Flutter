import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/features/posting/view/widgets/options_bottom%20sheet.dart';
import 'package:threddit_clone/features/user_system/view_model/settings_functions.dart';
import 'package:threddit_clone/models/message.dart';
import 'package:threddit_clone/theme/colors.dart';
import 'package:http/http.dart' as http;

class MessageItem extends ConsumerStatefulWidget {
  const MessageItem({super.key, required this.message, required this.uid});
  final Message message;
  final String uid;
  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends ConsumerState<MessageItem> {
  bool _isblocked = false;
  // ignore: unused_field
  bool _isLoading = false;
  String otherUsername = '';
  String otherId = '';
  @override
  void initState() {
    super.initState();
    otherUsername = widget.message.from.id != widget.uid
        ? widget.message.from.username
        : widget.message.to.username;
    otherId = widget.message.from.id != widget.uid
        ? widget.message.from.id
        : widget.message.to.id;
    _setVariables();
  }

  void _setVariables() async {
    setState(() {
      _isLoading = true;
    });

    await checkUserBlockState(otherId).then(
      (value) {
        setState(() {
          _isblocked = value;
          _isLoading = false;
        });
      },
    );
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
                    Text(
                      widget.message.from.id == widget.uid
                          ? widget.message.to.username
                          : widget.message.from.username,
                      style: TextStyle(
                          color: widget.message.read ||
                                  widget.message.from.id == widget.uid
                              ? const Color.fromARGB(55, 255, 255, 255)
                              : Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                      child: Icon(
                        Icons.circle,
                        color: const Color.fromARGB(60, 255, 255, 255),
                        size: 4.sp,
                      ),
                    ),
                    Text("$hoursSincePost h",
                        style: TextStyle(
                            color: widget.message.read ||
                                    widget.message.from.id == widget.uid
                                ? const Color.fromARGB(55, 255, 255, 255)
                                : Colors.white)),
                    const Spacer(),
                    if (widget.message.from.id != widget.uid ||
                        widget.message.to.id != widget.uid)
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: AppColors.backgroundColor,
                              builder: (context) {
                                return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        child: ListTile(
                                          title: _isblocked
                                              ? const Text(
                                                  'Unblock account',
                                                  style: TextStyle(
                                                      color: Colors.orange),
                                                )
                                              : const Text(
                                                  'Block account',
                                                  style: TextStyle(
                                                      color: Colors.orange),
                                                ),
                                          leading: const Icon(
                                            Icons.block,
                                            color: Colors.orange,
                                          ),
                                          onTap: () {
                                            _isblocked
                                                ?{ unblockUser(
                                                    client: http.Client(),
                                                    userToUnBlock:
                                                        otherUsername,
                                                    context: context),
                                                    Navigator.pop(context)
                                                }
                                                :{ blockUser(
                                                    userToBlock: otherUsername,
                                                    context: context,
                                                  ),
                                                  Navigator.pop(context)
                                                };
                                            
                                            setState(() {_isblocked = !_isblocked;});
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: FilledButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: FilledButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 55, 55, 55),
                                            foregroundColor:
                                                const Color.fromARGB(
                                                    123, 255, 255, 255),
                                          ),
                                          child: const Text("Close"),
                                        ),
                                      )
                                    ]);
                              });
                        },
                        icon: const Icon(Icons.more_horiz),
                      ),
                  ],
                ),
                Row(
                  children: [
                    Text(widget.message.subject,
                        style: TextStyle(
                            color: widget.message.read ||
                                    widget.message.from.id == widget.uid
                                ? const Color.fromARGB(55, 255, 255, 255)
                                : Colors.white))
                  ],
                ),
                Row(
                  children: [
                    Text(widget.message.message,
                        style: TextStyle(
                            color: widget.message.read ||
                                    widget.message.from.id == widget.uid
                                ? const Color.fromARGB(55, 255, 255, 255)
                                : Colors.white))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
