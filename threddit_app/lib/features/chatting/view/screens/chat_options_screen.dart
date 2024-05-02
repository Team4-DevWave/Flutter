import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';

class ChatOptionsScreen extends ConsumerStatefulWidget {
  ChatOptionsScreen(
      {super.key, required this.username, required this.chatroom});
  final String username;
  Chatroom chatroom;
  @override
  _ChatOptionsScreenState createState() => _ChatOptionsScreenState();
}

class _ChatOptionsScreenState extends ConsumerState<ChatOptionsScreen>
    with SingleTickerProviderStateMixin {
  bool _isMuted = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 56, 56, 56),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color.fromARGB(255, 56, 56, 56),
          title: Text(
            widget.chatroom.isGroup
                ? widget.chatroom.chatroomName
                : (widget.chatroom.chatroomMembers[0].username !=
                        widget.username
                    ? widget.chatroom.chatroomMembers[0].username
                    : widget.chatroom.chatroomMembers[1].username),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(10.0.sp),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0.sp),
              color: const Color.fromARGB(199, 10, 10, 10),
            ),
            child: widget.chatroom.isGroup
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.chatroom.chatroomAdmin.username ==
                          widget.username)
                        ListTile(
                          title: const Text(
                            "Rename",
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: const Icon(
                            Icons.drive_file_rename_outline_rounded,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteClass.renameChatroom,
                              arguments: {
                                'chatroom': widget.chatroom,
                                'username': widget.username,
                              },
                            );
                          },
                        ),
                      ListTile(
                        title: const Text(
                          "Invite People",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.person_add_alt,
                          color: Colors.white,
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text(
                          "View members",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.people_alt_outlined,
                          color: Colors.white,
                        ),
                        trailing: Text(
                          widget.chatroom.chatroomMembers.length.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        title: const Text(
                          "Mute notifications",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.block_rounded,
                          color: Colors.white,
                        ),
                        trailing: Switch(
                          value: _isMuted,
                          onChanged: (bool value) {
                            // Update the backend
                            setState(() {
                              _isMuted = value;
                            });
                          },
                          activeColor: Colors
                              .blue, // Customize the color when the switch is on
                        ),
                      ),
                      if (widget.chatroom.chatroomAdmin.username !=
                          widget.username)
                        ListTile(
                          title: const Text(
                            "Leave Group",
                            style: TextStyle(color: Colors.red),
                          ),
                          leading: const Icon(
                            Icons.exit_to_app,
                            color: Colors.red,
                          ),
                          onTap: () {},
                        ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('Username'),
                        subtitle:
                            Text(widget.chatroom.chatroomMembers[0].username),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
