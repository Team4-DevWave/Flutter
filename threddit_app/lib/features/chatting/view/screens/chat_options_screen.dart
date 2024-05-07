import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/app/route.dart';
import 'package:threddit_clone/features/chatting/model/chat_repository.dart';
import 'package:threddit_clone/features/chatting/model/chat_room_model.dart';

// ignore: must_be_immutable
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
    //_isMuted = widget.chatroom.isMuted;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void leaveChatroomfn(BuildContext context) async{
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Leave Chatroom"),
          content: const Text("Are you sure you want to leave the chatroom?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
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
                          Text('leaving chat room..'),
                        ],
                      ),
                    );
                  },
                );
                try {
                  final response =
                      await ref.read(leaveChatRoom(widget.chatroom.id).future);
                  if (response == 204) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                } catch (e) {
                  // Handle error
                  print('Error leaving chatroom: $e');
                }
              },
              child: const Text("Leave"),
            ),
          ],
        );
      },
    );
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
            widget.chatroom.chatroomName != "New Chat"
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
            child: widget.chatroom.chatroomName != "New Chat"
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
                          "Add Members",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.person_add_alt,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteClass.inviteMembers,
                            arguments: {
                              'chatroom': widget.chatroom,
                              'username': widget.username,
                            },
                          );
                        },
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
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RouteClass.chatMembers,
                            arguments: {
                              'chatroom': widget.chatroom,
                              'username': widget.username,
                            },
                          );
                        },
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
                          onTap: () {
                           leaveChatroomfn(context);
                          },
                        ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                      ListTile(
                        title: const Text(
                          "Hide Chat",
                          style: TextStyle(color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.hide_source_outlined,
                          color: Colors.white,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
